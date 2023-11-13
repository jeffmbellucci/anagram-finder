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
  solved = anagrams.find('zoo') == []
  solved &&= anagrams.find('stop').sort == %w[spot tops opts post pots].sort
  solved &&= anagrams.find('star').sort == %w[tsar tars arts rast rats].sort
  solved &&= anagrams.find('least').sort == %w[leats slate setal salet stela steal stale teals tesla tales taels].sort
  solved &&= anagrams.find('cinema').sort == %w[iceman anemic].sort
  solved &&= anagrams.find('pester').sort == %w[peters petres preset].sort
  solved &&= anagrams.find('present').sort == %w[penster repents serpent].sort

  puts solved ? 'All tests passed!' : 'Test(s) failed.'
end

solution_tester