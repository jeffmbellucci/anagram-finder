require 'open-uri'

class Anagrams
  attr_reader :dict

  def initialize
    dict_url = 'https://raw.githubusercontent.com/jeffmbellucci/anagram-finder/main/scrabble_dictionary.txt'
    dict_file = URI.open(dict_url)
    @dict = dict_file.readlines.map(&:chomp)
  end

  def find(anagram)
    shorter_dict = dict.select { |word| anagram.length == word.length }
    possible_words = anagram.chars.permutation.map(&:join)
    possible_words.select { |word| shorter_dict.include?(word) }.uniq - [anagram]
  end
end

def solution_tester
  anagrams = Anagrams.new
  solved = anagrams.find('zoo') == []
  solved &&= anagrams.find('stop').sort == %w[spot tops opts post pots].sort
  solved &&= anagrams.find('star').sort == %w[tsar tars arts rast rats].sort
  solved &&= anagrams.find('least').sort == %w[leats slate setal salet stela steal stale teals tesla tales taels].sort
  solved &&= anagrams.find('cinema').sort == %w[iceman anemic].sort
  solved &&= anagrams.find('pester').sort == %w[peters petres preset].sort
  solved &&= anagrams.find('present').sort == %w[penster repents serpent].sort

  solved ? 'All tests passed!' : 'Test(s) failed.'
end

puts Anagrams.new.find('acid')