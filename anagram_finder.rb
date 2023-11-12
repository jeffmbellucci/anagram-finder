class Anagrams
  def initialize
    # Your code here
  end

  def find(word)
   # Your code here
  end
end

def solution_tester
  anagrams = Anagrams.new
  solved = anagrams.find('zoo') == [] &&
  anagrams.find('stop').sort == ["spot", "tops", "opts", "post", "pots"].sort &&
  anagrams.find('star').sort == ["tsar", "tars", "arts", "rast", "rats"].sort &&
  anagrams.find('least').sort == ["leats", "slate", "setal", "salet", "stela", "steal", "stale", "teals", "tesla", "tales", "taels"].sort &&
  anagrams.find('cinema').sort == ["iceman", "anemic"].sort &&
  anagrams.find('pester').sort == ["peters", "petres", "preset"].sort &&
  anagrams.find('present').sort == ["penster", "repents", "serpent"].sort

  solved ? "All tests passed!" : "Test(s) failed."
end

puts solution_tester
