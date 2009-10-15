module RPH
  module Navigation
    # handles adding items 
    # to a specific menu
    class Menu < Base
      def initialize(name, options = {})
        @name = name
        (MENUS[@name] = ActiveSupport::OrderedHash.new).merge!(
          :action_menu => options[:action_menu], :if => options[:if])
      end
      
      def item(key, options = {}, &block)
        key = normalize(key)
        
        MENUS[@name].merge!(key => options)
        
        # if a block is given to this method, it is
        # assumed that there will be nested navigation,
        # so yield a NestedMenu instance back to the block
        yield NestedMenu.new(@name, key) if block_given?
      end
    end
  end
end