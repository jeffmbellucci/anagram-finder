# frozen_string_literal: true
require 'csv'
require 'set'

PAGE_SIZE = 20

class WordleSolver
  def initialize
    @frequency = CSV.read('./word_frequency.csv').to_h.transform_values(&:to_i)

    @valid_guesses = File.readlines('./scrabble_dictionary.txt')
                .map(&:chomp)
                .map(&:downcase)
                .select { |word| word.length == 5 }
                .to_set

    @dict = @frequency.keys
                .map(&:downcase)
                .select { |word| word.length == 5 }
                .select { |word| @valid_guesses.include?(word) }

    reset_state
  end

  def solve
    puts 'Welcome to Wordle Solver!'
    puts "Enter guesses and results. Use CAPITAL for green, lowercase for yellow, '-' for gray."
    puts "Example: guess 'crane', result '-rA-E' means green at 2,4 and yellow at 1.\n\n"

    loop do
      6.times do |turn|
        puts "--- Guess #{turn + 1} of 6 ---"
        print 'Guess: '
        guess = read_input.strip.downcase

        until guess.length == 5 && guess.match?(/\A[a-zA-Z]{5}\z/) && @valid_guesses.include?(guess)
          if !guess.match?(/\A[a-zA-Z]{5}\z/)
            print 'Please enter exactly 5 letters: '
          else
            print 'Not a valid word. Try again: '
          end
          guess = read_input.strip.downcase
        end

        if turn > 0
          print 'Did you get it? (Y/N): '
          answer = read_input
          if yes?(answer)
            puts congratulate(turn + 1)
            break
          end
        end

        print 'Enter Result: '
        result = read_input.strip

        valid_result = result.length == 5 &&
                       result.match?(/\A[a-zA-Z-]{5}\z/) &&
                       (0...5).all? { |i| result[i] == '-' || result[i].downcase == guess[i] }
        until valid_result
          print 'Invalid. 5 chars, CAPITAL=green, lowercase=yellow, -=gray (letters must match guess): '
          result = read_input.strip
          valid_result = result.length == 5 &&
                         result.match?(/\A[a-zA-Z-]{5}\z/) &&
                         (0...5).all? { |i| result[i] == '-' || result[i].downcase == guess[i] }
        end

        candidates = []
        solved = false
        gave_up = false
        loop do
          saved_state = {
            known_positions: @known_positions.dup,
            must_include: @must_include.dup,
            eliminated: @eliminated.dup,
            cannot_be_at: @cannot_be_at.transform_values(&:dup),
            letter_min_count: @letter_min_count.dup,
            letter_exact_count: @letter_exact_count.dup
          }

          parse_feedback(guess, result)

          candidates = filter_words
          candidates = candidates.sort_by { |w| @frequency[w] || 0 }.reverse

          unless candidates.empty?
            solved = true
            break
          end

          puts "\nNo possible solutions remain. The constraints are contradictory."
          print 'Did you mistype your result? (Y/N): '
          answer = read_input
          if yes?(answer)
            @known_positions = saved_state[:known_positions]
            @must_include = saved_state[:must_include]
            @eliminated = saved_state[:eliminated]
            @cannot_be_at = saved_state[:cannot_be_at]
            @letter_min_count = saved_state[:letter_min_count]
            @letter_exact_count = saved_state[:letter_exact_count]
            print 'Re-enter result: '
            result = read_input.strip
            until result.length == 5 &&
                  result.match?(/\A[a-zA-Z-]{5}\z/) &&
                  (0...5).all? { |i| result[i] == '-' || result[i].downcase == guess[i] }
              print 'Invalid. 5 chars, CAPITAL=green, lowercase=yellow, -=gray: '
              result = read_input.strip
            end
          else
            gave_up = true
            break
          end
        end

        break if gave_up

        if candidates.length == 1
          if turn == 5
            puts "\nThe only remaining possibility was #{candidates[0].upcase}. Better luck next time!"
          else
            puts "\nThe only remaining possibility is #{candidates[0].upcase}. Congratulations, you got it!"
          end
          break
        end

        if solved
          puts "\nRemaining: #{candidates.length} word#{candidates.length == 1 ? '' : 's'}"
          display_candidates(candidates)
        end
      end

      puts "\nWould you like to try again? (Y/N): "
      answer = read_input
      break unless yes?(answer)

      reset_state
      puts "\n"
    end
  end

  private

  def reset_state
    @known_positions = {}
    @must_include = Set.new
    @eliminated = Set.new
    @cannot_be_at = {}
    @letter_min_count = Hash.new(0)
    @letter_exact_count = {}
  end

  def parse_feedback(guess, result)
    letter_greens = Hash.new(0)
    letter_yellows = Hash.new(0)

    (0...5).each do |i|
      letter = guess[i]
      feedback = result[i]

      if feedback.upcase == feedback && feedback != '-'
        @known_positions[i] = letter
        letter_greens[letter] += 1
      elsif feedback.downcase == feedback && feedback != '-'
        @cannot_be_at[letter] ||= Set.new
        @cannot_be_at[letter].add(i)
        letter_yellows[letter] += 1
      end
    end

    (0...5).each do |i|
      letter = guess[i]
      feedback = result[i]

      next unless feedback == '-'

      unless letter_greens[letter].positive? || letter_yellows[letter].positive?
        @eliminated.add(letter)
      end
    end

    all_letters = letter_greens.keys | letter_yellows.keys
    all_letters.each do |letter|
      total = letter_greens[letter] + letter_yellows[letter]
      @letter_min_count[letter] = total

      gray_count = (0...5).count { |i| guess[i] == letter && result[i] == '-' }
      @letter_exact_count[letter] = total if gray_count.positive?
    end
  end

  def filter_words
    @dict.select do |word|
      next false unless green_match?(word)
      next false unless has_all_required?(word)
      next false unless avoids_eliminated?(word)
      next false unless respects_cannot_be_at?(word)
      next false unless meets_min_counts?(word)
      next false unless meets_exact_counts?(word)

      true
    end
  end

  def green_match?(word)
    @known_positions.all? { |pos, letter| word[pos] == letter }
  end

  def has_all_required?(word)
    @must_include.all? { |letter| word.include?(letter) }
  end

  def avoids_eliminated?(word)
    @eliminated.none? { |letter| word.include?(letter) }
  end

  def respects_cannot_be_at?(word)
    @cannot_be_at.all? do |letter, positions|
      positions.none? { |pos| word[pos] == letter }
    end
  end

  def meets_min_counts?(word)
    @letter_min_count.all? { |letter, min| word.count(letter) >= min }
  end

  def meets_exact_counts?(word)
    @letter_exact_count.all? { |letter, exact| word.count(letter) == exact }
  end

  def display_candidates(candidates)
    offset = 0
    loop do
      batch = candidates[offset, PAGE_SIZE]
      break unless batch

      batch.each_with_index do |word, i|
        puts "#{offset + i + 1}: #{word.upcase}"
      end

      offset += PAGE_SIZE
      break unless offset < candidates.length

      print 'Show more? (Y/N): '
      answer = read_input
      break unless yes?(answer)
    end
    puts '--- End of Possible remaining guess words ---' if offset >= candidates.length
  end

  def congratulate(guesses)
    case guesses
    when 1
      "\nIncredible! A hole in one! You got today's WORDLE in 1 guess!"
    when 2
      "\nGenius! You got today's WORDLE in 2 guesses!"
    when 3
      "\nAmazing! You got today's WORDLE in 3 guesses!"
    when 4
      "\nNice work! You got today's WORDLE in 4 guesses!"
    when 5
      "\nGood job! You got today's WORDLE in 5 guesses!"
    when 6
      "\nPhew, just under the wire! You got today's WORDLE in 6 guesses!"
    end
  end

  def read_input
    gets&.chomp || ''
  end

  def yes?(input)
    input = input.strip.upcase
    input == 'Y' || input == '' || input == "\t"
  end

  def no?(input)
    input.strip.upcase == 'N'
  end

end

WordleSolver.new.solve
