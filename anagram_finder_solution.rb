require 'open-uri'

class Anagrams
  attr_reader :dict

  def initialize
    dict_url = 'https://raw.githubusercontent.com/jeffmbellucci/anagram-finder/main/scrabble_dictionary.txt'
    dict_file = URI.open(dict_url)
    @dict = dict_file.readlines.map(&:chomp)
    @sorted_dict = @dict.group_by { |word| word.chars.sort.join }
  end

  def find(anagram)
    sorted_anagram = anagram.chars.sort.join
    @sorted_dict[sorted_anagram] ? @sorted_dict[sorted_anagram] - [anagram] : []
  end
end

def solution_tester
  anagrams = Anagrams.new
  solved = anagrams.find('cinema').sort == %w[iceman anemic].sort
  puts solved
end

puts Anagrams.new.find('relations')