module RPH
  module Navigation
    # handles adding nested menu items
    # to a parent menu item
    class NestedMenu < Base
      def initialize(menu, parent)
        @menu, @parent = menu, parent
        
        # the entire nested menu is stored as a nested ordered hash
        # since we want multiple items in the same hash, only initialize once
        MENUS[@menu][@parent][SUBMENU] = ActiveSupport::OrderedHash.new unless MENUS[@menu][@parent].has_key?(SUBMENU)
      end
      
      def item(key, options = {})
        # only support one level of nesting (the action-level)
        raise InvalkeyBlock, InvalkeyBlock.message if block_given?
        MENUS[@menu][@parent][SUBMENU].merge!(normalize(key) => options)
      end
    end
  end
end