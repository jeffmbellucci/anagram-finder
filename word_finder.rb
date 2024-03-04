class WordFinder
  attr_reader :letters, :dict, :dict_hash, :candidates, :word_length

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

    @word_length = opts[:word_length].is_a?(Integer) ? opts[:word_length] : letters.length

    puts "\nFull dictionary length: #{full_dict_length} words."
    @candidates = opts[:letters].chars.permutation(word_length).map(&:join).uniq

    puts "Candidates (#{candidates.length} words) are #{percentage(candidates.length,
                                                                   full_dict_length)}% of full dictionary."
    @dict_hash.select! do |word|
      word.length == word_length &&
        word.include?(opts[:key_letter_or_word]) &&
        (word[0..opts[:start_letters].length - 1] == opts[:start_letters] ||
        options[:start_letters].empty?) &&
        (word[-opts[:end_letters].length..-1] == opts[:end_letters] ||
        options[:start_letters].empty?)
    end

    puts "Remaining candidates (#{dict_hash.length} words) are now #{100.0 - percentage(dict_hash.length,
                                                                                        full_dict_length)}% shorter than full dictionary."
    puts "Using '#{opts[:start_letters]}' to start and containing '#{opts[:key_letter_or_word]}' using only '#{letters.split('').join(',')}'."
  end

  def find
    pp(candidates.select { |word| dict_hash[word] })
  end

  private

  def percentage(a, b, decimal_places = 4)
    (a.to_f / b.to_f * 100.0).round(decimal_places)
  end

  def factorial(n)
    (1..n).inject(:*)
  end
end

results = WordFinder.new(
  key_letter_or_word: '',
  start_letters: '',
  end_letters: '',
  letters: 'abcdefghijklnopqrstuvwxyz',
  word_length: 5
).find

puts "Possibilities:\n"
puts results.filter_map { |word| word if word[0] == 's' && word[-3..-1] == 'ate' }


# Copilot advice:
# I see a few things that may help you improve your code.
# Use a Set for the dictionary
# The current code uses an array for the dictionary.  This is inefficient for lookups.  Instead, it would be better to use a Set.  This is because the Set is implemented as a hash table and lookups are \$O(1)\$ instead of \$O(n)\$ for an array.  This will make the code much faster.
# Use a Trie for the dictionary
# Another way to improve the performance of the dictionary lookup is to use a Trie.  This is a tree structure that is very efficient for dictionary lookups.  It is \$O(m)\$ where \$m\$ is the length of the word.  This is much faster than the Set which is \$O(1)\$ for a hash table lookup, but the hash table lookup is \$O(n)\$ for a list of words.  This will make the code even faster.
# Use a better algorithm
# The current algorithm is \$O(n!)\$ because it generates all permutations of the input letters and then checks each one to see if it's in the dictionary.  This is very inefficient.  A better algorithm would be to use the Trie to generate all possible words that can be made from the input letters and then check each one to see if it's in the dictionary.  This would be \$O(m)\$ where \$m\$ is the length of the word.  This is much faster than the current algorithm.
# Use a better data structure
# The current code uses a hash table to store the dictionary.  This is inefficient because the hash table has to be searched for each word.  A better data structure would be a Trie.  This is a tree structure that is very efficient for dictionary lookups.  It is \$O(m)\$ where \$m\$ is the length of the word.  This is much faster than the hash table lookup which is \$O(1)\$ for a hash table lookup, but the hash table lookup is \$O(n)\$ for a list of words.  This will make the code even faster.
# Use a better algorithm
# The current algorithm is \$O(n!)\$ because it generates all permutations of the input letters and then checks each one to see if it's in the dictionary.  This is very inefficient.  A better algorithm would be to use the Trie to generate all possible words that
