class Node
   attr_accessor :name, :nclass, :id, :parent, :children, :text
   
   def initialize(name)
       @name = name
       @nclass = nil
       @id = nil
       @parent = nil
       @text = ""
       @children = []
   end 
end


class Parser
    attr_accessor :input_file, :file_array, :tree, :nodehash, :nodenumber
    
   def initialize
      @input_file = read_file('test.html') 
      @file_array = string_transfer(@input_file)
      @tree = tree_make(@file_array)
      @subtree = []
      @nodenumber = 0
   end
   
   def read_file(file_in)
       file = File.open(file_in, 'r')
       content = file.read
       file.close
       content = content.gsub(/\s+/, " ")
   end
   
   def string_transfer(string)
       array = []
       tag_mode = /<.*?>/
       while string.match(tag_mode) != nil do
           tag = string.match(tag_mode).to_s
           prematch = string.match(tag_mode).pre_match
           postmatch = string.match(tag_mode).post_match
           array << prematch unless prematch == " " || prematch.empty?
           array << tag
           string = postmatch
       end
       array[1..-1]
   end
   
   def tree_make(array)
      node = Node.new("head")
      0.upto(array.length - 1) do |index|
          if array[index].match(/<\w+.*>/)
              newnode = nodemake(array[index])
              newnode.parent = node
              node.children << newnode
              node = newnode
          elsif array[index].match(/<\/.*>/)
              node = node.parent
          else
              node.text += array[index]
          end
      end
      @tree = node
   end
   
   def nodemake(tag)
      newnode = Node.new(nil)
      unless tag.match(/<(\w+)/).nil?
          node_name = tag.match(/<(\w+)/).captures.first
      end
      unless tag.match(/class\ ?=\ ?[\'"]+(.*?)[\'"]/).nil?
          node_class = tag.match(/class\ ?=\ ?[\'"]+(.*?)[\'"]/).captures.first
      end
      unless tag.match(/id\ ?=\ ?([\'"]+.*?[\'"])/).nil?
          node_id = tag.match(/id\ ?=\ ?[\'"]+(.*?)[\'"]/).captures.first
      end
      newnode.name = node_name
      newnode.nclass = node_class.split(" ") unless node_class.nil?
      newnode.id = node_id
      return newnode
   end
   
   def parser_overview
      print_tree(@tree, 1) 
      puts "there's #{@nodenumber} nodes"
      @subtree.each do |sentence|
          puts sentence
      end
   end
   
   def print_tree(node, depth)
      print "     "*depth
      print "node name: "
      puts node.name
      print "     "*(depth)
      print "node class: "
      print node.nclass
      puts ""
      print "     "*(depth)
      print "node text: "
      print "     "
      puts node.text
      num = node.children.length
      deep = (["  "]*depth).join
      @subtree << deep + "node #{node.name} has #{num} subtrees"
      node.children.each do |child|
          print_tree(child, depth+1)
      end
      print "     "*depth
      puts "#{node.name} node end"
      @nodenumber += 1
   end
   
   
end

#pa = Parser.new
#pa.parser_overview