class WordFinder
  attr_reader :letters, :dict, :candidates, :word_length, :key_letter_or_word, :start_letters, :end_letters

  def initialize(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:)
    @dict = File.readlines('./scrabble_dictionary.txt').map(&:chomp).map(&:downcase)
    @letters = letters
    @word_length = word_length.is_a?(Integer) ? word_length : 15
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

def spelling_bee_solver(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:)
  output = []
  word_length.downto(4).each do |word_length|
   output << WordFinder.new(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:).find
  end
  output.flatten
end

# not currently working, but it was at one point, will need to check git history
def all_panagrams(letters:, word_length:, key_letter_or_word:, start_letters:, end_letters:)
  output = []
  word_length.downto(7).each do |word_length|
    output << WordFinder.new(letters: letters, word_length:, key_letter_or_word:, start_letters:, end_letters:).anagrams
  end
  output
end

pp WordFinder.new(letters: 'laster' , word_length: '', key_letter_or_word: '', start_letters: '', end_letters: '').anagrams

pp spelling_bee_solver(letters: 'confirm', key_letter_or_word: 'o', word_length: 15, start_letters: '', end_letters: '')

