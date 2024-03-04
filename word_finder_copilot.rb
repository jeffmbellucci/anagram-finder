class WordFinder
  attr_reader :letters, :dict, :dict_trie, :candidates, :word_length

  def initialize(options = {})
    defaults = { letters: '',
                 word_length: '',
                 key_letter_or_word: '',
                 start_letters: '' }
    opts = defaults.merge(options)
    @letters = opts[:letters]
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)

    full_dict_length = @dict.length
    @word_length = opts[:word_length].is_a?(Integer) ? opts[:word_length] : letters.length

    puts "\nFull dictionary length: #{full_dict_length} words."
    puts "Using '#{opts[:start_letters]}' to start and containing '#{opts[:key_letter_or_word]}' using only '#{letters.split('').join(',')}'."

    # first filter the dictionary to only include words of the correct length
    @dict.select! do |word| word.length == word_length &&
      # only select words that contain the letters
      word.chars.all? { |letter| letters.include?(letter) } &&
      # only select words that start with the start letters or are empty
      (word[0..opts[:start_letters].length - 1] == opts[:start_letters] || opts[:start_letters].empty?) &&
      # words that contain the key letter or word
      (word.include?(opts[:key_letter_or_word]) || opts[:key_letter_or_word].empty?)  &&
      # words that end with the end letters
      (word[-opts[:end_letters].length..-1] == opts[:end_letters] || opts[:end_letters].empty?)
    end

    puts "Remaining candidates (#{dict.length} words after filter) are now #{100.0 - percentage(dict.length, full_dict_length)}% shorter than full dictionary."
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
  start_letters: 'e',
  end_letters: 's',
  letters: 'elphants',
  word_length:9
).find



