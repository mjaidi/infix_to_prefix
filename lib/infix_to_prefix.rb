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

# Method to Check if input is an operand
def is_operand?(c)
  c == '+' || c == '-' || c == '*' || c == '/' ? true : false
end

# SOLUTION
def infix_to_prefix(string)
  InfixPrefix.new(string).prefix_output
end





# ALTERNATIVE SOLUTION (found online)
def infix_to_prefix_2(string)
  %w[^ / * + -].map do |o|
    String.send(:define_method, o) do |n|
      "(#{o} #{n} #{self})"
    end
  end
  return eval string.gsub(/\w/,'?\0')
end


# To be able to run and read files from command line
ARGV.each do|file|
  f = File.read(file)
  puts 'original version:' + '  ' + f
  puts 'prefix version:' + '  ' +  infix_to_prefix(f)
end
