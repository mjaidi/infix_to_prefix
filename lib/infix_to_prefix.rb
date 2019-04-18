require_relative 'infix_prefix'

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
