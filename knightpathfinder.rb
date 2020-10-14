require_relative 'polytreenode'

class KnightPathFinder

    MOVES = [[-2,1],[-2,-1],[-1,2],[-1,-2],[1,2],[1,-2],[2,1],[2,-1]]

    def self.valid_pos(pos)
        i, j = pos
        i.between?(0,8) && j.between?(0,8)
    end

    def self.valid_moves(pos)
        i, j = pos
        arr = []
        MOVES.each do |moves|
            x, y = moves
            pot_move = [i+x,j+y]
            arr << pot_move if KnightPathFinder.valid_pos(pot_move)
        end
        arr
    end
    
    def initialize(position)
        @root_node = PolyTreeNode.new(position)
        @considered_positions = []
        @considered_positions << @root_node.value
        @current_node = @root_node
        build_move_tree
    end

    def inspect
        { 'root_node' => @root_node }.inspect
    end

    def build_move_tree
        move_tree = []
        move_tree << @root_node
        queue = []
        queue << @root_node
        until queue.empty?
            curr_node = queue.shift
            new_move_positions(curr_node.value).each do |pos| 
                new_node = PolyTreeNode.new(pos)
                new_node.parent = curr_node
                queue << new_node
                move_tree << new_node
            end
        end
        move_tree 
    end

    def new_move_positions(pos)
        arr = []
        KnightPathFinder.valid_moves(pos).each do |move|
            arr << move unless @considered_positions.include?(move)
        end
        arr.map { |move| @considered_positions << move}
        arr
    end


    def find_path(pos) 
        return trace_path_back if @current_node.value == pos
        @current_node.children.each do |child|
            @current_node = child
            search_result = find_path(pos)
            return search_result unless search_result == nil
        end
        nil
    end

    def trace_path_back
        node = @current_node
        arr = [node.value]
        until node.parent == nil
            arr.unshift(node.parent.value)
            node = node.parent
        end
        @current_node = @root_node
        arr
    end


end