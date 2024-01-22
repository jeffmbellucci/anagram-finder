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

  def substrings(str, length = 4)
    output = []
    0.upto(str.length - 1) do |i|
      i.upto(str.length - 1) { |j| output << str[i..j] }
    end
    output.select { |str| str == length }.uniq
  end

  def factorial(n)
    (1..n).inject(:*)
  end
end

WordFinder.new(
  key_letter_or_word: 'c',
  start_letters: 'in',
  letters: 'nomadicnomadicnomadic',
  word_length: 7
).find


# # create analgorithm that takes in a string and returns all possible anagrams using thescrable_dictionary.txt file in this same directory, and returns an array of all possible anagrams, or an empty array if none exist, avoid factorial time complexity
# def load_dictionary(file_path)
#   dictionary = Hash.new { |hash, key| hash[key] = [] }

#   File.foreach(file_path) do |line|
#     word = line.strip.downcase
#     sorted_word = word.chars.sort.join
#     dictionary[sorted_word] << word
#   end

#   dictionary
# end

# def find_scrabble_words(letters, dictionary, word_length)
#   possible_words = []

#   letters.chars.permutation(word_length) do |permutation|
#     sorted_permutation = permutation.sort.join
#     possible_words.concat(dictionary[sorted_permutation])
#   end

#   possible_words.uniq.select { |word| word.length == word_length }
# end

# # Load the dictionary from the file
# scrabble_dictionary = load_dictionary("scrabble_dictionary.txt")

# # Get input from the user
# puts "Enter a set of letters to find Scrabble words:"
# user_letters = gets.chomp

# puts "Enter the desired word length:"
# word_length = gets.chomp.to_i

# # Find and display Scrabble words of the specified length
# scrabble_words = find_scrabble_words(user_letters, scrabble_dictionary, word_length)

# if scrabble_words.empty?
#   puts "No Scrabble words of length #{word_length} found."
# else
#   puts "Scrabble Words of length #{word_length}: #{scrabble_words.join(', ')}"
# end