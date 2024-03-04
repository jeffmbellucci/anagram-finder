class TrieNode
  attr_accessor :children, :is_word

  def initialize
    @children = {}
    @is_word = false
  end
end

class Trie
  def initialize
    @root = TrieNode.new
  end

  def insert(word)
    node = @root
    word.each_char do |char|
      node.children[char] ||= TrieNode.new
      node = node.children[char]
    end
    node.is_word = true
  end

  def search(word)
    node = search_prefix(word)
    node && node.is_word
  end

  def starts_with(prefix)
    node = search_prefix(prefix)
    !node.nil?
  end

  private

  def search_prefix(prefix)
    node = @root
    prefix.each_char do |char|
      return nil unless node.children[char]
      node = node.children[char]
    end
    node
  end
end

class WordFinder
  attr_reader :letters, :dict, :dict_trie, :candidates, :word_length

  def initialize(options = {})
    defaults = { letters: '',
                 word_length: 4,
                 key_letter_or_word: '',
                 start_letters: '' }
    opts = defaults.merge(options)
    @letters = opts[:letters]
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)
    @dict_trie = Trie.new
    @dict.each { |word| @dict_trie.insert(word) }

    full_dict_length = @dict.length
    @word_length = opts[:word_length].is_a?(Integer) ? opts[:word_length] : letters.length

    puts "\nFull dictionary length: #{full_dict_length} words."
    puts "Using '#{opts[:start_letters]}' to start and containing '#{opts[:key_letter_or_word]}' using only '#{letters.split('').join(',')}'."
    @dict.select! { |word| word.length == word_length }
    # only select words that contain the letters
    @dict.select! { |word| word.chars.all? { |letter| letters.include?(letter) } }
    # words that start with the start letters using starts_with
    @dict.select! { |word| dict_trie.starts_with(opts[:start_letters]) || opts[:start_letters].empty? }
    # words that contain the key letter or word
    @dict.select! { |word| word.include?(opts[:key_letter_or_word]) || opts[:key_letter_or_word].empty? }
    # words that end with the end letters
    @dict.select! { |word| word[-opts[:end_letters].length..-1] == opts[:end_letters] || opts[:end_letters].empty? }

    puts "Dictionary length after filtering: #{dict.length} words."
    puts "Remaining candidates (#{dict.length} words) are now #{100.0 - percentage(dict.length, full_dict_length)}% shorter than full dictionary."
  end

  def find
    puts "Possibilities are:\n"
    @dict
  end

  private

  def percentage(a, b, decimal_places = 4)
    (a.to_f / b.to_f * 100.0).round(decimal_places)
  end
end

pp WordFinder.new(
  key_letter_or_word: 'h',
  start_letters: '',
  end_letters: '',
  letters: 'elphants',
  word_length: 10
).find



