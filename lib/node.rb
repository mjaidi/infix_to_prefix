# Node Definition for Binary Tree
class Node
  attr_reader :content, :children

  def initialize(content, children = [])
    @content = content
    @children = children
  end

  def create
    if is_operand?(content)
      content.call *children.map(&:create)
    else
      content
    end
  end
end
