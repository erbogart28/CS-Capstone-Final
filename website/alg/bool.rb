require 'strscan'
require 'set'


module BType
  OR = 'or'.freeze
  AND = 'and'.freeze
  LEAF = 'leaf'.freeze
  TRUE = 'true'.freeze
end


class BoolNode
  attr_accessor :data, :type
  def initialize(options = {data: nil, left: nil, right: nil, type: BType::LEAF})
    @data = options[:data]
    @left = options[:left]
    @right = options[:right]
    @type = options[:type]
  end

  def evaluate(completed)
    return true if @type == BType::TRUE
    if @type == BType::LEAF
      completed.include? @data
    elsif @type == BType::OR
      @left.evaluate(completed) || @right.evaluate(completed)
    else
      @left.evaluate(completed) && @right.evaluate(completed)
    end
  end
end


class BoolExp
  attr_accessor :root

  def initialize(prereq, completed)
    @text = prereq
    @completed = completed
    @scanner = StringScanner.new(prereq)
    if !prereq || prereq[0] == '(' || valid_operand?(prereq)
      @root = create_tree
    else
      @root = BoolNode.new({type: BType::TRUE})
    end
  end

  def evaluate

    @root.evaluate(@completed)
  end

  def create_tree
    left = nil
    char = ''
    loop do
      if @scanner.eos?
        return left
      elsif (char = @scanner.getch) == ')'
        @scanner.pos += 1 unless @scanner.eos?
        return left
      elsif char == '('
        if left.nil?
          left = create_tree
        else
          type = read_tok(3)
          right = create_tree
          left = BoolNode.new(left: left, right: right, type: type)
        end

      else
        @scanner.pos -= 1 # due to the getch we need to move back
        if left.nil?
          left = BoolNode.new(data: read_tok(7), type: BType::LEAF)

        elsif !@scanner.eos?
          type = read_tok 3
          if @scanner.peek(1) == '('
            right = create_tree
          else
            right = BoolNode.new(data: read_tok(7), type: BType::LEAF)
            right.type = BType::TRUE unless valid_operand?(right.data)
            if @scanner.eos? || @scanner.pos == @text.length - 1
              @scanner.terminate
            end
          end
          left = BoolNode.new(left: left, right: right, type: type)
        else
          return left
        end
      end
    end
  end

  def valid_operand?(tok)
    tok[0..1].match /[A-Z]{2}/
  end

  def valid_operator?(tok)
    tok.start_with?('or', 'and')
  end

  def read_tok(len)
    tok = @scanner.peek(len)
    if tok.end_with? ' '
      tok.strip!
    elsif tok.end_with? ')'
      tok = tok.chomp!(')')
    elsif @scanner.pos + len < @text.length - 1 && @text[@scanner.pos + len] != ')'
      @scanner.pos += 1
    end
    unless @scanner.eos?
      @scanner.pos += @text[@scanner.pos + len - 1] == ')' || tok.start_with?('SE','IT','PM', 'IS') ? len -1 : len
    end
    tok
  end
end



# b = BoolExp.new("CSC 406 and CSC 402")
# puts b.to_s
#
# b = BoolExp.new("CSC 453 and (CSC 435 or TDC 405 or TDC 463)")
# puts b.to_s
#
# b = BoolExp.new("(CSC 402 or CSC 404) and CSC 423")
# puts b.to_s
#
# b = BoolExp.new("IT 403 and (CSC 401 or IT 411)")
# puts b.to_s
#
# b = BoolExp.new("CSC 423 or consent of instructor", Set.new)
# puts b.to_s
#
b = BoolExp.new("SE 477 or IS 565 or ACT 500 or IS 430 or PM 430 or ECT 455", Set.new)
puts b.to_s
