class TrieNode
  attr_accessor :children, :is_word

  def initialize
    @children = {}
    @is_word = false
  end
end

class Trie
  def initialize
    @root = TrieNode.new
  end

  def insert(word)
    node = @root
    word.each_char do |char|
      node.children[char] ||= TrieNode.new
      node = node.children[char]
    end
    node.is_word = true
  end

  def search(word)
    node = search_prefix(word)
    node && node.is_word
  end

  def starts_with(prefix)
    node = search_prefix(prefix)
    !node.nil?
  end

  private

  def search_prefix(prefix)
    node = @root
    prefix.each_char do |char|
      return nil unless node.children[char]
      node = node.children[char]
    end
    node
  end
end
