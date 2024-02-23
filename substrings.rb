class String # Monkey pactch substrings method to String class

  def substrings(options= {})
    defaults = { all: true, length: 2 }
    defaults.merge(options)

    subs = []
    0.upto(self.length - 1) do |i|
      i.upto(self.length - 1) { |j| subs << self[i..j] }
    end
    defaults[:all] ? subs.uniq : subs.uniq.select { |sub| sub.length == defaults[:length] }
  end

end

p 'bandband'.substrings # => ["b", "ba", "ban", "band", "a", "an", "and", "n", "nd", "d"]