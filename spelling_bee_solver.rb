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

  # Return only the words that contain all the letter
  def anagrams
    dict.select { |word| word.chars.sort.join == letters.chars.sort.join } - [letters]
  end

  private

  def percentage(a, b, decimal_places = 4)
    (a.to_f / b.to_f * 100.0).round(decimal_places)
  end
end

# This class will be used to get user inputs and run the solver
class SpellingBeeSolver
  attr_reader :letters, :word_length, :key_letter_or_word, :start_letters, :end_letters, :all_words, :output

  def initialize
    # get the 7 allowed letters
    puts 'Input the 7 letters in the spelling bee puzzle:'
    @letters = gets.chomp.downcase
    until (@letters.length == 7)
      puts 'That is not 7 letters, please enter 7 letters.'
      @letters = gets.chomp.downcase
    end

    # Get the mandatory letter
    puts 'Input the center letter:'
    @key_letter_or_word = gets.chomp.downcase
    until (letters.include?(@key_letter_or_word) && @key_letter_or_word.length == 1)
      puts 'Invalid input, please enter a single letter that is one the 7 letters you entered.'
      @key_letter_or_word = gets.chomp.downcase
    end

    puts "Would you like to see all the possible words (Y), or would you like a more refined search?(N) (Y/N):"
    @find_all = gets.chomp.upcase

    until (@find_all == 'Y' || @find_all == 'N')
      puts 'Invalid input, please enter (Y/N).'
      @find_all = gets.chomp.upcase
    end

    # Allow the user to input the word length, start letters, and end letters
    if @find_all == 'N'
      puts "Input the maximum word length you want to find, or hit 'Enter' for the default (15 letters):"
      @word_length = gets.chomp.to_i
      @word_length = @word_length == 0 ? 15 : @word_length
      puts 'Input the first letter or prefix of the words you want find (enter blank to skip):'
      @start_letters = gets.chomp.downcase || ''
      puts 'Enter a suffix or last letter for the words (enter blank to skip):'
      @end_letters = gets.chomp.downcase || ''

      @output = spelling_bee_solver(letters: , word_length: , key_letter_or_word: , start_letters: , end_letters: , all_words: )
    else
      # Output all the words
      @output = spelling_bee_solver(letters: , word_length: 15 , key_letter_or_word: , start_letters: '' , end_letters: '' , all_words: )
    end

    print "Jeff is working hard to find those words"; 15.times{ sleep 0.1; print '.' }; puts "\n"
    sleep(0.3)
    puts "Here are the words that Jeff found based on your inputs, ranked in order of most common to least:\n\n"
    puts "Sorry, I couldn't find any words that meet your criteria." if @output.empty?
    puts output if !@output.empty?

    puts "\nIf your word is not in the list we can run an expanded search, would you like to do that? (Y/N):"
      @expanded = gets.chomp.upcase

      until (@expanded == 'Y' || @expanded == 'N')
        puts 'Invalid input, please enter (Y/N).'
        @expanded = gets.chomp.upcase
      end

    puts "\n"
    if @expanded == 'Y'
      puts "The expanded search was unable to find any more words." if (@entire_output - @limited_output).empty?
      puts @entire_output - @limited_output
    end
    puts "Thanks for playing!" if @expanded == 'N'
  end

  # Main method to solve the spelling bee puzzle, pass false as the last argument to return only the words in the frequency hash
  def spelling_bee_solver(letters:, word_length: 15, key_letter_or_word:, start_letters:, end_letters:, all_words: false)
    output = []
    # open word_frequency.csv and return as a hash with the words as keys and the frequency as integer values
    frequency = CSV.read('./word_frequency.csv').to_h.transform_values(&:to_i)
    # iterate through the word lengths from the word_length to 4
    word_length.downto(4).each do |word_length|
    output << WordFinder.new(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:).find
    end
    # order the words by the frequency of the word in the English language or infinite if not found
    # only select words that are in the frequency hash if all_words is false, otherwise return all words sorted by frequency
    @entire_output = output.flatten.sort_by { |word| frequency[word] || 0 }.reverse.map(&:upcase)
    @limited_output = output.flatten.select { |word| frequency[word] }.sort_by { |word| frequency[word] }.reverse.map(&:upcase)
    all_words ? @entire_output : @limited_output
  end
end


class AnagramFinder
  attr_reader :letters
# not currently working, but it was at one point, will need to check git history
  def initialize
    # get the letters from the user
    puts 'Input the letters you want anagrams for:'
    @letters = gets.chomp.downcase

    puts WordFinder.new(letters: , word_length: 15, key_letter_or_word: '', start_letters: '', end_letters: '').anagrams.map(&:upcase)
  end


  def find_all(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:)
    output = []
    word_length.downto(7).each do |word_length|
      output << WordFinder.new(letters: letters, word_length:, key_letter_or_word:, start_letters:, end_letters:).anagrams
    end
    output
  end
end

#AnagramFinder.new
#pp WordFinder.new(letters: 'plantim' , word_length: '', key_letter_or_word: '', start_letters: '', end_letters: '').anagrams


# Execute the SpellingBeeSolver

SpellingBeeSolver.new