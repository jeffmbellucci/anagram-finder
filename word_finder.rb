class WordFinder
  attr_reader :letters, :dict, :candidates

  def initialize(options = {})
    defaults = { letters: '',
      word_length: 4,
      key_letter_or_word: '',
      start_letters: '' }
    opts = defaults.merge(options)

    pp opts
    @letters = opts[:letters]
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)

    full_dict_length = @dict.length
    puts "\nFull dictionary length: #{full_dict_length} words."
    @candidates = opts[:letters].chars.permutation(opts[:word_length]).map(&:join).uniq

    puts "Candidates (#{candidates.length} words) are #{percentage(candidates.length, full_dict_length)}% of full dictionary."
    @dict.select! { |word| word.length == opts[:word_length] &&
      word.include?(opts[:key_letter_or_word]) &&
      (word[0..opts[:start_letters].length - 1] == opts[:start_letters] ||
      options[:start_letters].empty?)}

    puts "Remaining candidates (#{dict.length} words) are now #{100.0 - percentage(dict.length, full_dict_length)}% shorter than full dictionary."
    puts  "Using '#{opts[:start_letters]}' to start and containing '#{opts[:key_letter_or_word]}' using only '#{letters.split('').join(',')}'."
  end

  def find
    pp candidates.select { |word| dict.include?(word) }
  end

  private

  def percentage(a, b, decimal_places = 4)
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

WordFinder.new(
  {
    key_letter_or_word: '',
    start_letters: 'la',
    letters: 'zaltionzaltionlt',
    word_length:7
  }
).find
