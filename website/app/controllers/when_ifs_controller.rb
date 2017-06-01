require 'strscan'

class WhenIfsController < ApplicationController
  before_action :set_when_if, only: [:show, :edit, :update, :destroy]

  # GET /when_ifs
  # GET /when_ifs.json
  def index
    @when_if = WhenIf.new
  end

  def run
    degree = params[:degree_id]
    concentration = params[:concentration]
    puts concentration
    course_load = params[:course_load].to_i
    start_quarter = params[:start_quarter]
    s = ShortestPath.new(concentration, 'AuO', (19 / course_load), 1)
    puts s.shortest_path
  end

  # GET /when_ifs/1
  # GET /when_ifs/1.json
  def show
  end

  # GET /when_ifs/new
  def new
  end

  # GET /when_ifs/1/edit
  def edit
  end

  # POST /when_ifs
  # POST /when_ifs.json
  def create
  end

  # PATCH/PUT /when_ifs/1
  # PATCH/PUT /when_ifs/1.json
  def update
  end

  # DELETE /when_ifs/1
  # DELETE /when_ifs/1.json
  def destroy
  end

  private
    def get_max_depth(degree, concentration, load)
      if degree == 'CS'
        (19 / load).ceil
      else
        case concentration
          when 'Business Analysis/Systems Analysis'
            -1 # todo finish
          else
            -1
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_when_if
      # -      @when_if = WhenIf.find(params[:id])

      @when_if = WhenIf.find(params[:start_quarter, :degree_id, :course_load, :concentration])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def when_if_params
      params.require(:when_if).permit(:concentration, :course_load, :start_quarter, :degree_id)
    end
end



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
            @scanner.terminate
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
      tok = tok.rstrip!
    elsif tok.end_with? ')'
      tok = tok.chomp!(')')
    elsif @scanner.pos + len < @text.length - 1 && @text[@scanner.pos + len] != ')'
      @scanner.pos += 1
    end
    unless @scanner.eos?
      @scanner.pos += @text[@scanner.pos + len - 1] == ')' || tok.start_with?('SE','IT') ? len -1 : len
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
# b = BoolExp.new("CSC 412 or consent of instructor")
# puts b.to_s
#

class ShortestPath

  def initialize(concentration, quarter, max_depth, classes_per_quarter)
    @next_quarter = {
        AuE: :WiE,
        WiE: :SpE,
        SpE: :S0E,
        S0E: :AuO,
        # S1E: :S2E,
        # S2E: :AuO,
        AuO: :WiO,
        WiO: :SpO,
        SpO: :S0O,
        S0O: :AuE,
        # S1O: :S2O,
        # S2O: :AuE
    }
    @quarter_hash = Hash.new { |h,v| h[v] = [] }
    @priority_hash = Hash.new { |h,v| h[v] = [] }
    @deg = Degree.find_by(concentration: concentration)
    map_by_quarter
    map_by_priority
    @start_quarter = quarter
    @max_depth = max_depth
    @cpq = classes_per_quarter
  end

  def shortest_path()
    list_nodes = [Node.new([],[],-1, @next_quarter.key(@start_quarter.to_sym), nil)]
    node = nil
    loop do
      node = list_nodes.last
      if node.depth >= @max_depth
        if goal_state(node)
          return get_path(node)
        else
          list_nodes.pop
        end
      else
        list_nodes.pop
        list_nodes += successor(node, @cpq)
      end
    end
  end

  private

  def map_by_quarter
    @deg.degree_reqs.each do |course|
      unless course.history.nil?
        hist = course.history.split ','
        hist.each do |quart|
          @quarter_hash[quart.to_sym] << course
        end
      end
    end
  end

  def map_by_priority
    @deg.degree_reqs.each do |course|
      @priority_hash[course.priority] << course.course_code unless course.priority.nil?
    end
  end

  def successor(node, classes_per_quarter)
    quart = @next_quarter[node.quarter]
    courses = @quarter_hash[quart]
    courses = courses.select do |c|
      p node.completed
      if c.prereqs.nil?
        !node.completed.include?(c.course_code)
      else
        b = BoolExp.new(c.prereqs, node.completed)
        b.evaluate && !node.completed.include?(c.course_code)
      end
    end
    # TODO: Concentration specific priority order
    courses.sort!{|a, b| -(a.priority <=> b.priority) }
    combos = courses.combination(classes_per_quarter).to_a
    combos.sort! do |a,b|
      -(a.inject(0) { |sum, c| sum + c.priority } <=> b.inject(0) { |sum, c| sum + c.priority })
    end
    successor_list = []
    combos.each do |combo|
      courses = combo.map(&:course_code)
      completed = Set.new(node.completed).merge(courses)
      successor_list << Node.new(courses, completed, node.depth+1, quart, node)
    end
    successor_list
  end

  def get_path(node)
    result = []
    while node.parent
      result << node.courses
      node = node.parent
    end
    result.reverse!
    result
  end

  def goal_state(node)
    result = true
    case @deg.id
    when 1..7 # CS
      result &= contains_n_from? node.completed, @priority_hash[0], 6
      result &= contains_n_from? node.completed, @priority_hash[1], 5
      result &= contains_n_from? node.completed, @priority_hash[@deg.id+1], 4
      result &= node.completed.size >= 19
    when 8 # Business Analysis/Systems Analysis
      result &= contains_n_from? node.completed, @priority_hash[1], 4
      result &= contains_n_from? node.completed, @priority_hash[2], 5
      result &= contains_n_from? node.completed, @priority_hash[3], 2
      result &= node.completed.include? @priority_hash[4][0]
    when 9 # Business Intelligence
      result &= contains_n_from? node.completed, @priority_hash[0], 2
      result &= contains_n_from? node.completed, @priority_hash[1], 4
      result &= contains_n_from? node.completed, @priority_hash[2], 4
      result &= contains_n_from? node.completed, @priority_hash[3], 3
      result &= node.completed.include? @priority_hash[4][0]
    when 10 # Database Administration
      result &= contains_n_from? node.completed, @priority_hash[0], 1
      result &= contains_n_from? node.completed, @priority_hash[1], 4
      result &= contains_n_from? node.completed, @priority_hash[2], 4
      result &= contains_n_from? node.completed, @priority_hash[3], 3
      result &= node.completed.include? @priority_hash[4][0]
    when 11 # IT Enterprise Management
      result &= contains_n_from? node.completed, @priority_hash[0], 4
      result &= contains_n_from? node.completed, @priority_hash[1], 4
      result &= contains_n_from? node.completed, @priority_hash[2], 3
      result &= node.completed.include? @priority_hash[4][0]
    when 12 # Standard
      result &= contains_n_from? node.completed, @priority_hash[0], 4
      result &= contains_n_from? node.completed, @priority_hash[1], 4
      result &= contains_n_from? node.completed, @priority_hash[2], 4
      result &= node.completed.include? @priority_hash[1][0]
    else
      result = false
    end
    result
  end

  def contains_n_from?(container, from, n)
    count = 0
    from.each do |item|
      count += 1 if container.include? item
      return true if count >= n
    end
    false
  end

end

class Node
  attr_accessor :courses, :completed, :depth, :quarter, :parent
  def initialize(courses, completed_classes, depth, quar_year, parent)
    @courses = courses
    @completed = completed_classes
    @depth = depth
    @quarter = quar_year
    @parent = parent
  end
end