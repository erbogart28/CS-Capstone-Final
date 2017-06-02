require 'strscan'
require 'timeout'

class WhenIfsController < ApplicationController
  before_action :set_when_if, only: [:show, :edit, :update, :destroy]

  # GET /when_ifs
  # GET /when_ifs.json
  def index
    @when_if = WhenIf.new
    @user_id = session[:user_id].last
  end

  def run
    degree = params[:when_if][:degree_id]
    concentration = params[:when_if][:concentration]
    puts concentration
    @course_load = params[:when_if][:course_load].to_i
    start_quarter = params[:when_if][:start_quarter]
    s = ShortestPath.new(concentration, 'AuO', (19 / @course_load), @course_load)
    s = s.shortest_path
    s.each do |quarter|
      quarter.map! { |code| Course.find_by course_code: code }
    end
    @quarters =  [
        "Fall",
        "Winter",
        "Spring",
        "Summer 10 week",
        "Fall",
        "Winter",
        "Spring",
        "Summer 10 week"
    ]
    @path = s
  end

  # GET /when_ifs/1
  # GET /when_ifs/1.json
  def show
    @when_if = WhenIf.find(params[:id])
    h = {
        'Fall'.freeze => 'AuO',
        'Winter'.freeze => 'WiO',
        'Spring'.freeze => 'SpO',
    }
    course_count = get_course_count(@when_if.concentration)

    s = ShortestPath.new(
        @when_if.concentration,
        h[@when_if.start_quarter],
        (course_count / @when_if.course_load).ceil,
        @when_if.course_load
    )
    begin
      s = timeout(10) { s.shortest_path }
      s.each do |quarter|
        quarter.map! { |code| Course.find_by course_code: code }
      end
      @quarters =  [
          "Fall",
          "Winter",
          "Spring",
          "Summer 10 week",
          "Fall",
          "Winter",
          "Spring",
          "Summer 10 week"
      ]
      @path = s
    rescue TimeoutError
      @path = []
    end
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
    @when_if = WhenIf.create(when_if_params)
    redirect_to @when_if
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
  def get_course_count(concentration)
    case concentration
      when 'Business Analysis/Systems Analysis'
        12 # todo finish
      when 'Business Intelligence'
        14
      when 'Database Administration'
        13
      when 'IT Enterprise Management'
        12
      when 'Standard'
        11
      else
        19
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_when_if
    # -      @when_if = WhenIf.find(params[:id])
    @when_if = WhenIf.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def when_if_params
    params.require(:when_if).permit(:concentration, :course_load, :start_quarter, :degree_id, :user_id)
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
    @type = options[:type].strip
  end

  def evaluate(completed)
    return true if @type == BType::TRUE
    if @type == BType::LEAF
      res = completed.include? @data
      # p res, @data
      res
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
    # p @root if @text == 'SE 477 or IS 565 or ACT 500 or IS 430 or PM 430 or ECT 455'
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
          type = read_tok(3)
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
      begin
        @scanner.pos += @text[@scanner.pos + len - 1] == ')' || tok.start_with?('SE','IT','PM', 'IS') ? len -1 : len
      rescue StandardError
        @scanner.terminate
      end
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
    list_nodes = [Node.new([],[],0, @next_quarter.key(@start_quarter.to_sym), nil)]
    node = nil
    loop do
      n = list_nodes.last
      if n.nil?
        p node
      end
      node = n

      if node.depth >= @max_depth
        # p 'max depth'
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
    if @deg.id == 12
      Degree.find(10).degree_reqs.each do |course|
        course.priority += 10
        unless course.history.nil?
          hist = course.history.split ','
          hist.each do |quart|
            @quarter_hash[quart.to_sym] << course
          end
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
      if c.prereqs.nil?
        !node.completed.include?(c.course_code)
      else
        b = BoolExp.new(c.prereqs, node.completed)
        res = b.evaluate
        # p c.course_code, "====================================", node.completed unless res
        res && !node.completed.include?(c.course_code)
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
    # case @deg.id
    #   when 1..7 # CS
    #     result &= contains_n_from? node.completed, @priority_hash[0], 6
    #     p '1' if result
    #     result &= contains_n_from? node.completed, @priority_hash[1], 5
    #     p '2' if result
    #     result &= contains_n_from? node.completed, @priority_hash[@deg.id+1], 4
    #     p '3' if result
    #     result &= node.completed.size >= 19
    #   when 8 # Business Analysis/Systems Analysis
    #     # # p node.completed
    #     # # p 0
    #     # result &= contains_n_from? node.completed, @priority_hash[1], 4
    #     # # p "1 #{result}" if result
    #     # result &= contains_n_from? node.completed, @priority_hash[2], 5
    #     # p "2 #{result}" if result
    #     # result &= contains_n_from? node.completed, @priority_hash[3], 2
    #     # p "3 #{result}" if result
    #     # result &= node.completed.include? @priority_hash[4][0]
    #     # p "4 #{result}" if result
    #     result
    #   when 9 # Business Intelligence
    #     result &= contains_n_from? node.completed, @priority_hash[0], 2
    #     result &= contains_n_from? node.completed, @priority_hash[1], 4
    #     result &= contains_n_from? node.completed, @priority_hash[2], 4
    #     result &= contains_n_from? node.completed, @priority_hash[3], 3
    #     result &= node.completed.include? @priority_hash[4][0]
    #   when 10 # Database Administration
    #     result &= contains_n_from? node.completed, @priority_hash[0], 1
    #     result &= contains_n_from? node.completed, @priority_hash[1], 4
    #     result &= contains_n_from? node.completed, @priority_hash[2], 4
    #     result &= contains_n_from? node.completed, @priority_hash[3], 3
    #     result &= node.completed.include? @priority_hash[4][0]
    #   when 11 # IT Enterprise Management
    #     result &= contains_n_from? node.completed, @priority_hash[0], 4
    #     result &= contains_n_from? node.completed, @priority_hash[1], 4
    #     result &= contains_n_from? node.completed, @priority_hash[2], 3
    #     result &= node.completed.include? @priority_hash[4][0]
    #   when 12 # Standard
    #     result &= contains_n_from? node.completed, @priority_hash[0], 4
    #   else
    #     result = false
    # end
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