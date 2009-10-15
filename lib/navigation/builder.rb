module RPH
  module Navigation
    # responsible for the initial menu building/configuration
    #
    # Ex (config/initializers/navigation.rb):
    #   RPH::Navigation::Builder.config do |navigation|
    #     navigation.define :primary do |menu|
    #       ...
    #     end
    #   end
    #
    class Builder < Base
      def self.config
        # gives a Builder instance to the block
        yield self.new
      end
      
      # accepts a name/key, and yields 
      # a Menu instance to the block
      def define(*args)
        name, options = args.first, args.extract_options!
        
        raise InvalidMenuDefinition, InvalidMenuDefinition.message if name.blank?
        yield Menu.new(normalize(name), options)
      end
    end
  end
end