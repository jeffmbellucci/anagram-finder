## Anagram Finder Challenge

"An anagram is defined as a word, phrase, or name formed by rearranging the letters of another, such as **_cinema_**, formed from **_iceman_**." - Oxford Languages  

Given a word (string), create an anagram finder that returns an array of all the possible anagrams strings for that word, not including itself.  If no anagrams exist, return an empty array.

- The anagrams must be valid English words, so an open source Scrabble dictionary containing around 280K lowercased words is provided in this repo to confirm them.  You can open the dictionary with Ruby file I/O, but I found it ever so slightly harder if you download the dictionary first, instead of just opening it.  However, using an an HTTP request is not a requirement, and any solution type will be accepted by the basic tester included in the skeleton file.

- I used a brute force solution, so I'd have a working one quickly to create test cases that I checked against other source to be sure of their validity.  I am very curious to see if anyone can come with something more clever and optimal, perhaps with some sort of letter tree(s) traversal with DFS or BFS, or maybe some kind of NLP? My guess is that truly optimizing this algorithm is a non-trivial problem.

- Brute force solutions are definitely acceptable, but they start to get slow quickly with longer words, which is why I kept the test case words relatively short.  I think my current solution is O(n!) which is admittedly brutal, and I am thinking about ways I might improve it. Even with brute force, the test cases should take no more than 2-3 seconds to complete. If people like this one, maybe I will make my next one fancier with RSpec...

- Here's the link if you choose to download the dictionary in your solution.
https://raw.githubusercontent.com/jeffmbellucci/anagram-finder/main/scrabble_dictionary.txt

- You can run your solution at the command line with `ruby anagram_finder.rb`. or natively in your IDE if you have a code runner, and it will tell you if it passes or fails, like so:<br/><img width="382" alt="anagram test" src="https://github.com/jeffmbellucci/anagram-finder/assets/5009669/d505308a-eb67-4881-b27f-ade164faaf19"><br/>
Or if it passes: <br/><img width="441" alt="anagram test passed" src="https://github.com/jeffmbellucci/anagram-finder/assets/5009669/0e92d65e-b72b-485b-86d3-0ba06ce04c1d">

- If you don't use file download in your solution, you can clone the repo so your File I/O can find the dictionary. You will see some pretty obscure words in the solutions, but I assure you that they are in the Scrabble Dictionary.  Enjoy. :)

I'll push my terrible solution for critique on Monday or so...
