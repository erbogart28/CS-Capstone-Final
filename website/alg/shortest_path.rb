$quarter_hash = Hash.new { |h,v| h[v] = [] }
$next_quarter = {
    AuE: :WiE,
    WiE: :SpE,
    SpE: :S1E,
    # S0E: :AuO,
    S1E: :S2E,
    S2E: :AuO,
    AuO: :WiO,
    WiO: :SpO,
    SpO: :S1O,
    # S0O: :AuE,
    S1O: :S2O,
    S2O: :AuE
}

def map_by_quarter(cons)
  p 'fuck'
  Degree.find_by(concentration: cons).degree_reqs.each do |course|
    unless course.history.nil?
      hist = course.history.split ','
      hist.each do |quart|
        $quarter_hash[quart] << course
      end
    end
  end
end


class Node
  def initialize(courses, completed_classes, depth, quar_year, parent)
    @course = courses
    @completed = completed_classes
    @depth = depth
    @quarter = quar_year
    @parent = parent
  end
end

def successor(node, classes_per_quarter)
  quart = $next_quarter[node.quarter.to_sym]
  courses = $quarter_hash[node.quarter]
  courses = courses.select do |c|
    BoolExp.new(c.prereqs, node.completed).evaluate
  end
  # TODO: Concentration specific priority order
  combos = courses.combination(classes_per_quarter).sort! do |a,b|
    i = 0
    while i < classes_per_quarter && a[i].priority == b[i].priority
      i += 1
    end
    -(a.priortity <=> b.priority)
  end
  successor_list = []
  combos.each do |combo|
    courses = combo.map(&:course_code)
    completed = Set.new(node.completed).merge(courses)
    successor_list << Node.new(courses, completed, node.depth+1, quart, node)
  end
  successor_list
end

def goal_state(node = nil)
  true
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

def shortest_path(max_per_quarter, max_depth, concentration, quarter)
  $quarter_hash = map_by_quarter(concentration)

  list_nodes = [Node.new([],[],-1, next_quarter[quarter], nil)]
  node = nil
  loop do
    node = list_nodes.last
    if node.depth == max_depth
      if goal_state(node)
        return get_path(node)
      else
        list_nodes.pop
      end
    else
      list_nodes.pop
      list_nodes += successor(node, max_per_quarter)
    end
  end
end