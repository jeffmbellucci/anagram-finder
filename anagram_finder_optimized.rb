# frozen_string_literal: true

require 'open-uri'

class Anagrams
  # class cache so we only load & process the list once
  @@sorted_dict = nil

  def initialize
    load_dict unless @@sorted_dict
    @dict = @@sorted_dict
  end

  # find all anagrams of `anagram` (excluding itself)
  def find(anagram)
    @dict[signature(anagram)] - [anagram]
  end

  private

  # builds the hash only once
  def load_dict
    dict_url = 'https://raw.githubusercontent.com/jeffmbellucci/anagram-finder/main/scrabble_dictionary.txt'
    words = URI.open(dict_url).readlines.map(&:chomp)
    @@sorted_dict = Hash.new { |h, k| h[k] = [] }
    words.each do |word|
      @@sorted_dict[signature(word)] << word
    end
  end

  # O(k) signature: 26-element frequency vector packed to a string
  def signature(word)
    counts = Array.new(26, 0)
    word.each_byte do |b|
      counts[b - 97] += 1 if b.between?(97, 122)
    end
    counts.pack('C*')
  end
end

def solution_tester
  anagrams = Anagrams.new
  puts anagrams.find('cinema').sort == %w[iceman anemic]
end

puts Anagrams.new.find('leint')
puts Anagrams.new.find('cinema')
