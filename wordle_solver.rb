require 'csv'

class WordFinder
  attr_reader :letters, :dict, :word_length, :key_letter_or_word, :start_letters, :end_letters

  def initialize(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:)
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)
    @letters = letters
    @word_length = word_length.is_a?(Integer) ? word_length.to_i : 15
    @key_letter_or_word = key_letter_or_word
    @start_letters = start_letters
    @end_letters = end_letters
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
end

class WordleSolver
  attr_reader :possible_letters

  def initialize
    @possible_letters = (a..z).to_a
  end

  def solve
    6.times do
      puts "Enter your 5-letter guess:"
      word = gets.chomp.downcase
      until (@letters.length == 5)
        puts 'That is not 5 letters, please enter 5 letters.'
        @letters = gets.chomp.downcase
      end

      5.times do |i|
      puts "Is the first letter of your guess green? (Y/N)"
        green = gets.chomp.upcase

        until (green == 'Y' || green == 'N')
          puts 'Invalid input, please enter (Y/N).'
          green = gets.chomp.upcase
        end
      end
    end
  end
end

unused = ('a'..'z').to_a - 'craetoispdgy'.split('')
pp WordFinder.new(letters: unused, word_length: 5, key_letter_or_word: '', start_letters: '', end_letters: '').find.select { |word| word.include?('n') && word.include?('l') && word.include?('u') && word.include?('u') && word[0] != 't' && word[2] != 'A' && word[-2] == 'n'}

