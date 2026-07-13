# AGENTS.md

## Overview

Collection of standalone Ruby scripts for word puzzles (anagrams, Wordle, Spelling Bee). No bundler, no Gemfile, no test framework — each file runs independently.

## Running

```bash
ruby anagram_finder.rb          # skeleton with built-in test assertions
ruby anagram_finder_solution.rb # brute-force solution
ruby anagram_finder_optimized.rb # optimized (frequency-vector signature)
ruby wordle_solver.rb           # interactive CLI
ruby spelling_bee_solver.rb     # interactive CLI
```

There is no `bundle exec` or dependency installation step. All scripts use only the Ruby stdlib (`open-uri`, `csv`) or core classes.

## Key files

- `anagram_finder.rb` — skeleton to implement; contains `solution_tester` with hardcoded assertions
- `scrabble_dictionary.txt` (~280K words) — loaded via `File.readlines` (local) or `URI.open` (remote URL) depending on the script
- `word_frequency.csv` — used by `spelling_bee_solver.rb` for word ranking
- `letter_trie.rb` — standalone Trie implementation (not imported by other files)

## Gotchas

- Dictionary path is relative: scripts expect `./scrabble_dictionary.txt` from CWD. Run from the repo root or tests will fail with `Errno::ENOENT`.
- Some scripts fetch the dictionary over HTTP (`URI.open` from GitHub raw URL). This is not required — local `File.readlines` works and is faster.
- `spelling_bee_solver.rb` runs at the end of the file (top-level `SpellingBeeSolver.new` call at line 167). It's interactive and blocks on stdin.
- `wordle_solver.rb` line 34 uses `(a..z)` without quotes — this only works in an IRB/pry context where `a` and `z` are bound. The script will error as-is.
- `frozen_string_literal: true` is present in most files but not all (`spelling_bee_solver.rb`, `letter_trie.rb`).

## Style

- Ruby 3.x conventions. No linter or formatter configured.
- No module/namespace wrapping — all classes are defined at top level.
