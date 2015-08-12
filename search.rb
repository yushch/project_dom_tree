require_relative 'parser'

class Search
   attr_accessor :tree ,:about, :stack, :found, :parser
   
   def initialize
       @parser = Parser.new
       @tree = parser.tree
       @about = []
       @found = 0
       @stack = [] << @tree
   end 
   
   def relate_search
       puts "input the words you want to search"
       word = gets.chomp
       puts "you input is #{word}"
       through_check(@tree, word, 0)
       puts "there's no relation at all" if @about.length == 0
       puts @about
   end
   
   def through_check(node, word, depth)
       @about << "node #{node.name} depth = #{depth} has the same name #{node.name}" if node.name == word
       @about << "node #{node.name} depth = #{depth} has the same id #{node.id}" if node.id == word
       unless node.nclass == nil 
            @about << "node #{node.name} depth = #{depth} has the same class #{node.nclass}" if node.nclass.include?(word)
       end
       @about << "node #{node.name} depth = #{depth} has the same text #{node.text}" if node.text == word
       if node.children.length != 0
          node.children.each do |child| 
            through_check(child, word, (depth+1))
          end
       end
   end
   
   def child_ancestor_sort
       puts "children or ancestor?"
       puts "1:children 2:ancestor"
       choice1 = gets.chomp.to_i
       puts "which type do you want to sort"
       puts "1:name 2:class 3:id 4:text"
       choice2 = gets.chomp.to_i
       puts "input relative information"
       word = gets.chomp
       relative_search(choice1, choice2, word)

   end
   
   def relative_search(num1, num2, word)
       case(num2) 
        when(1)
           namecheck(num1, num2, word)
        when(2)
           classcheck(num1, num2, word)
        when(3)
           idcheck(num1, num2, word)
        when(4)
           textcheck(num1, num2, word)
       end
   end
   
   def textcheck(num1, num2, word)
       return "not found" if @stack[0] == nil && @found == 0
       return "search end" if @stack[0] == nil && @found == 1
        if @stack[0].text != nil
            if (@stack[0]).text.match(word)
                parser.print_tree(@stack[0], 0) if num1 == 1
                print_node(@stack[0].parent) if num1 == 2
                @found = 1
            end
        end
        if @stack[0].children.length != 0
            @stack[0].children.each do |child|
            @stack << child
            end
        end
        @stack.shift
        textcheck(num1, num2, word)
   end
   
   def idcheck(num1, num2, word)
       return "not found" if @stack[0] == nil && @found == 0
       return "search end" if @stack[0] == nil && @found == 1
        if @stack[0].id != nil
            if (@stack[0]).id == word
                parser.print_tree(@stack[0], 0) if num1 == 1
                print_node(@stack[0].parent) if num1 == 2
                @found = 1
            end
        end
        if @stack[0].children.length != 0
            @stack[0].children.each do |child|
            @stack << child
            end
        end
        @stack.shift
        idcheck(num1, num2, word)
   end
   
   def namecheck(num1, num2, word)
        return "not found" if @stack[0] == nil && @found == 0
        return "search end" if @stack[0] == nil && @found == 1
        if @stack[0].name != nil
            if (@stack[0]).name == word
                parser.print_tree(@stack[0], 0) if num1 == 1
                print_node(@stack[0].parent) if num1 == 2
                @found = 1
            end
        end
        if @stack[0].children.length != 0
            @stack[0].children.each do |child|
            @stack << child
            end
        end
        @stack.shift
        namecheck(num1, num2, word)
   end
   
   def classcheck(num1, num2, word)
        return "not found" if @stack[0] == nil && @found == 0
        return "search end" if @stack[0] == nil && @found == 1
        if @stack[0].nclass != nil
            if (@stack[0]).nclass.include?(word)
                @parser.print_tree(@stack[0], 0) if num1 == 1
                print_node(@stack[0].parent) if num1 == 2
                @found = 1
            end
        end
        if @stack[0].children.length != 0
            @stack[0].children.each do |child|
            @stack << child
            end
        end
        @stack.shift
        classcheck(num1, num2, word)
   end
end

    def print_node(node)
    puts "----------FIND A PARENT NODE------"
        puts "The parent node name is #{node.name}"
        puts "The parent node class is #{node.nclass}"
        puts "The parent node id is #{node.id}"
        puts "The parent node text is: #{node.text}"
    end

s = Search.new
puts s.child_ancestor_sort

