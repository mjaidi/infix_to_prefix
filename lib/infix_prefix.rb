require_relative 'node'

class InfixPrefix
  def initialize(string)
    @infix = string.split(' ')
  end

  def prefix_output
    prefix = []
    traverse_tree(self.tree, prefix)
    # spaces cleanup
    prefix.join.gsub(')',') ').gsub(' )',')').gsub(')(', ') (').strip
  end

  protected

  # Define priority of precedence
  def priority(c)
     case c
      when "*", "/"
        2
      when "+", "-"
        1
      when "("
        0
     end
  end

  # Converting to postfix using shunting yard algorithm
  def postfix
    @postfix = []
    stack = []
    @infix.each do |c|
     c = "" << c  # Convert to string
      case c
        when "("
          stack.push(c)
          # @postfix << ')'
        when /\d|[a-z]|[A-z]/
          @postfix << c
        when "*", "/", "+", "-"
          finished = false
          until finished or stack.empty?
            if priority(c) > priority(stack.last)
              finished = true
            else
              @postfix << stack.pop
            end
          end
          stack.push c
        when ")"
          while stack.last != "("
            @postfix << stack.pop
          end
          stack.pop
      end
    end

    while !stack.empty?
     @postfix << stack.pop
    end

    return @postfix
  end

  #  Using postifix to create tree
  def tree
    stack = []
    postfix.each do |token|
      if is_operand?(token)
        stack.push Node.new(token, stack.pop(2))
      else
        stack.push Node.new(token)
      end
    end
    stack.pop
  end

  # Traverse Tree to create prefix and format it with brackets and spaces
  # NOTE IF WE DIDNT NEED THE BRACKETS WE COULD JUST REVERSE POSTFIX FROM SHUNTINGYARD ALGORITHM
  def traverse_tree(node, prefix)
    prefix << '('
    prefix << node.content
    prefix << " "
    node.children.map do |c|
      if is_operand?(c.content)
        traverse_tree(c,prefix)
      else
        prefix << c.content
        prefix << ' '
      end
    end
    prefix << ')'
  end
end



# Method to Check if input is an operand
def is_operand?(c)
  c == '+' || c == '-' || c == '*' || c == '/' ? true : false
end
