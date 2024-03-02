require 'set'

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
  attr_reader :letters, :trie, :candidates, :word_length, :dict

  def initialize(options = {})
    defaults = { letters: '',
                 word_length: 4,
                 key_letter_or_word: '',
                 start_letters: '' }
    opts = defaults.merge(options)
    @letters = opts[:letters]
    @trie = Trie.new
    @dict = Set.new(File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase))

    full_dict_length = @dict.length

    @word_length = opts[:word_length].is_a?(Integer) ? opts[:word_length] : letters.length

    puts "\nFull dictionary length: #{full_dict_length} words."

    @candidates = letters.chars.permutation(word_length).map(&:join).uniq

    puts "Candidates (#{candidates.length} words) are #{percentage(candidates.length, full_dict_length)}% of full dictionary."

    @dict.select! do |word|
      word.length == word_length &&
        word.include?(opts[:key_letter_or_word]) &&
        (word[0..opts[:start_letters].length - 1] == opts[:start_letters] || opts[:start_letters].empty?) &&
        (word[-opts[:end_letters].length..-1] == opts[:end_letters] || opts[:start_letters].empty?)
    end

    puts "Remaining candidates (#{dict.length} words) are now #{100.0 - percentage(dict.length, full_dict_length)}% shorter than full dictionary."
    puts "Using '#{opts[:start_letters]}' to start and containing '#{opts[:key_letter_or_word]}' using only '#{letters.split('').join(',')}'."
  end

  def find
    candidates.select { |word| trie.search(word) }
  end

  private

  def percentage(a, b, decimal_places = 4)
    (a.to_f / b.to_f * 100.0).round(decimal_places)
  end
end

pp results = WordFinder.new(
  key_letter_or_word: 'p',
  start_letters: 's',
  end_letters: '',
  letters: 'fpgraoinls',
  word_length:4
).find

pp results.filter_map { |word| word if word.include?('a') && word[1] == 'r' && word[2] != 'a' && word[3] != 's' }