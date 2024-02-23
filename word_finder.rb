class WordFinder
  attr_reader :letters, :dict, :dict_hash, :candidates

  def initialize(options = {})
    defaults = { letters: '',
                 word_length: 4,
                 key_letter_or_word: '',
                 start_letters: '' }
    opts = defaults.merge(options)
    @letters = opts[:letters]
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)
    @dict_hash = @dict.each_with_object({}) { |word, hash| hash[word] = word.chars.sort.join }

    full_dict_length = @dict_hash.length

    puts "\nFull dictionary length: #{full_dict_length} words."
    @candidates = opts[:letters].chars.permutation(opts[:word_length]).map(&:join).uniq

    puts "Candidates (#{candidates.length} words) are #{percentage(candidates.length,
                                                                   full_dict_length)}% of full dictionary."
    @dict_hash.select! do |word|
      word.length == opts[:word_length] &&
        word.include?(opts[:key_letter_or_word]) &&
        (word[0..opts[:start_letters].length - 1] == opts[:start_letters] ||
        options[:start_letters].empty?)
    end

    puts "Remaining candidates (#{dict_hash.length} words) are now #{100.0 - percentage(dict_hash.length,
                                                                                   full_dict_length)}% shorter than full dictionary."
    puts "Using '#{opts[:start_letters]}' to start and containing '#{opts[:key_letter_or_word]}' using only '#{letters.split('').join(',')}'."
  end

  def find
   pp candidates.select { |word| dict_hash[word] }
  end

  private

  def percentage(a, b, decimal_places = 4)
    (a.to_f / b.to_f * 100.0).round(decimal_places)
  end

  def factorial(n)
    (1..n).inject(:*)
  end
end

WordFinder.new(
  key_letter_or_word: 'b',
  start_letters: 'band',
  letters: 'bundacebundacean',
  word_length: 7
).find

