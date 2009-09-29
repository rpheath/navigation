module RPH
  module Navigation
    # generic error superclass for convenient message setting
    class Error < RuntimeError
      def self.message(msg = nil)
        msg.nil? ? @message : self.message = msg
      end
      
      def self.message=(msg)
        @message = msg
      end
    end
    
    # raised if the navigation() helper is called without any defined menus
    class NoMenuDefinitions < Error
      message "There are no menus defined (menus should be defined in config/initializers/navigation.rb)"
    end
    
    # raised if a menu definition is attempted, but the menu name/key is blank
    class InvalidMenuDefinition < Error
      message "You must pass a name when defining a navigation menu"
    end
    
    # raised if the navigation() helper is called, but the menu name/key is blank
    class BlankMenuIdentifier < Error
      message "You must pass an identifier (the name used when defining the navigation) to the navigation() helper"
    end
    
    # raised if the navigation() helper is called, but the menu name/key doesn't exist
    class InvalidMenuIdentifier < Error
      message "There is no menu defined for that identifier"
    end
    
    # raised if a block is passed to a nested menu item when being defined
    class InvalidBlock < Error
      message "You cannot pass a block to a nested menu item"
    end
  end
end