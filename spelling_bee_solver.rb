require 'csv'

class WordFinder
  attr_reader :letters, :dict, :candidates, :word_length, :key_letter_or_word, :start_letters, :end_letters

  def initialize(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:)
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)
    @letters = letters
    @word_length = word_length.is_a?(Integer) ? word_length.to_i : 15
    @key_letter_or_word = key_letter_or_word
    @start_letters = start_letters
    @end_letters = end_letters
    # puts "\nFull dictionary length: #{full_dict_length} words."
    # puts "Using '#{opts[:start_letters]}' to start and containing '#{opts[:key_letter_or_word]}' using only '#{letters.split('').join(',')}'."
  end

  def find
    dict.select do |word|
      (word.length == word_length) &&
      # only select words that contain the letters
      word.chars.all? { |letter| letters.include?(letter) } &&
      # only select words that start with the start letters or are empty
      (word[0..start_letters.length - 1] == start_letters || start_letters.empty?) &&
      # words that contain the key letter or word
      (word.include?(key_letter_or_word) || key_letter_or_word.empty?) &&
      # words that end with the end letters
      (word[-end_letters.length..-1] == end_letters || end_letters.empty?)
    end
  end

  # Return only the words that contain all the letter
  def anagrams
    dict.select { |word| word.chars.sort.join == letters.chars.sort.join } - [letters]
  end

  private

  def percentage(a, b, decimal_places = 4)
    (a.to_f / b.to_f * 100.0).round(decimal_places)
  end
end

# Main method to solve the spelling bee puzzle, pass false as the last argument to return only the words in the frequency hash
def spelling_bee_solver(letters:, word_length: 15, key_letter_or_word:, start_letters:, end_letters:, all_words: true)
  output = []
  # open word_frequency.csv and return as a hash with the words as keys and the frequency as integer values
  frequency = CSV.read('./word_frequency.csv').to_h.transform_values(&:to_i)
  # iterate through the word lengths from the word_length to 4
  word_length.downto(4).each do |word_length|
   output << WordFinder.new(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:).find
  end
  # order the words by the frequency of the word in the English language or infinite if not found
  # only select words that are in the frequency hash
  entire_output = output.flatten.sort_by { |word| frequency[word] || 0 }.reverse
  limited_output = output.flatten.select { |word| frequency[word] }.sort_by { |word| frequency[word] }.reverse
  output = all_words ? entire_output : limited_output
  output.each do |word|
    puts "#{word} - #{frequency[word]}"
  end
end

# not currently working, but it was at one point, will need to check git history
def all_panagrams(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:)
  output = []
  word_length.downto(7).each do |word_length|
    output << WordFinder.new(letters: letters, word_length:, key_letter_or_word:, start_letters:, end_letters:).anagrams
  end
  output
end



#pp WordFinder.new(letters: 'playome' , word_length: '', key_letter_or_word: '', start_letters: '', end_letters: '').anagrams

#spelling_bee_solver(letters: 'playome', key_letter_or_word: 'a', word_length: 15, start_letters: '', end_letters: '')

#pp WordFinder.new(letters: 'qwertyuodfghjklzxvm', word_length: 5, key_letter_or_word: '', start_letters: '', end_letters: '').find.select { |word| word.include?('r') && word.include?('e') && word.include?('t') && word[1] != 'r' && word[2] != 'r' && word[3] == 'e'  && word[4] != 'e' && word[4] != 't'}

