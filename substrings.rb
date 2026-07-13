# frozen_string_literal: true

# Monkey pactch substrings method to String class
class String
  def substrings(options = {})
    defaults = { all: true, length: 2 }
    defaults.merge(options)

    subs = []
    0.upto(length - 1) do |i|
      i.upto(length - 1) { |j| subs << self[i..j] }
    end
    defaults[:all] ? subs.uniq : subs.uniq.select { |sub| sub.length == defaults[:length] }
  end
end

p 'bandband'.substrings # => ["b", "ba", "ban", "band", "a", "an", "and", "n", "nd", "d"]
