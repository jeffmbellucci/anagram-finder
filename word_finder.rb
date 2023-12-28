class WordFinder
  attr_reader :letters, :dict, :candidates

  def initialize(options = {})
    defaults = { letters: ('a'..'z').to_a.join, word_length: 5, key_letter_or_word: '', start_letter: '' }
    opts = defaults.merge(options)
    pp opts
    @letters = opts[:letters]
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)

    dict_length = @dict.length
    puts "Dictionary length: #{dict_length}"
    @candidates = opts[:letters].chars.permutation(opts[:word_length]).map(&:join)

    @dict.select! { |word| word.length == opts[:word_length] &&
      word.include?(opts[:key_letter_or_word]) &&
      (word[0] == opts[:start_letter] || options[:start_letter].empty?)}

    puts "Dictionary is now #{100.0 - percentage(dict.length, dict_length)}% shorter with #{opts[:word_length]} letters."
  end

  def find
    unique_candidates = candidates.uniq
    puts "number of candidate words: #{@candidates.length}"
    pp unique_candidates.select { |word| dict.include?(word) }
  end

  private

  def percentage(a, b, decimal_places = 3)
    (a.to_f/ b.to_f * 100.0).round(decimal_places)
  end

  def substrings(str, length = 4)
    output = []
    0.upto(str.length - 1) do |i|
      i.upto(str.length - 1) { |j| output << str[i..j]}
    end
    output.select { |str| str == length }.uniq
  end

  def factorial(n)
    (1..n).inject(:*)
  end
end

WordFinder.new(key_letter_or_word: 'zz', start_letter: '').find
