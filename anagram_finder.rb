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
  anagrams.find('star').sort == ["tsar", "tars", "arts", "rast", "rats"].sort &&
  anagrams.find('stare').sort == ["strae", "stear", "taser", "tares", "tears", "teras", "aster", "arets", "rates", "resat", "reast", "earst"].sort &&
  anagrams.find('alerts').sort == ["alters", "artels", "laster", "estral", "ratels", "talers", "tarsel", "salter", "slater", "staler", "stelar"].sort &&
  anagrams.find('pester').sort == ["peters", "petres", "preset"].sort &&
  anagrams.find('present').sort == ["penster", "repents", "serpent"].sort

  solved ? "All tests passed!" : "Test(s) failed."
end

puts solution_tester
