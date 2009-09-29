module RPH
  module Navigation
    class Navigator < Base
      attr_reader :name, :template
      
      def initialize(name, options)
        # must have menu definitions at this point
        raise NoMenuDefinitions, NoMenuDefinitions.message if MENUS.blank?
        # since multiple menus are supported, must have the name of the desired menu
        raise BlankMenuIdentifier, BlankMenuIdentifier.message if name.blank?
        # menu name/key must exist in the current menu definitions
        raise InvalidMenuIdentifier, InvalidMenuIdentifier.message unless valid?(name)
        
        # need a reference of the template/view
        # for building out the HTML
        @template = options.delete(:template)
        
        # initialization
        @name, @options = normalize(name), options
        
        # support building separate menus for actions,
        # without forcing it to be nested
        @action_level = MENUS[@name].delete(:action_level)
      end
      
      # the css class of the
      # parent <ul> element
      def css_class
        @options[:class] || 'navigation'
      end
      
      # returns the list items, all
      # properly nested (if needed)
      def links
        construct_html(self.items)
      end

    protected
      # convenience method
      def items
        MENUS[@name]
      end
      
      # checks to make sure the menu
      # name/key actually exists
      def valid?(key)
        MENUS.keys.map(&:to_sym).include?(key.to_sym)
      end
      
      # builds the HTML from the MENUS hash
      # (does a recursive call for nested menus)
      def construct_html(menu, nested = false)
        return if menu.blank?
        
        links = menu.inject([]) do |items, (item, opts)|
          text, path, attrs = self.disect(item, opts)
          subnav = construct_html(menu[item][SUBMENU], true).to_s
          attrs.merge!(:class => [attrs[:class], self.current_css(item, nested)].compact.join(' '))
          items << self.template.content_tag(:li, self.template.link_to(text, path) + subnav, attrs)
        end
        
        nested ? self.template.content_tag(:ul, links, :class => 'sub-navigation') : links
      end
      
      # determines if the menu item matches the current section
      # (considers both levels: controller and action)
      def current_css(item, nested = false)
        name = nested || @action_level ? self.template.action_name : self.template.controller_name
        'current' if normalize(name) == normalize(item)
      end
      
      # pulls out the goodies for use 
      # in the HTML construction
      def disect(item, opts)
        opts = HashWithIndifferentAccess.new(opts).symbolize_keys!

        path = self.template.send(opts.delete(:path) || "#{item.to_s.underscore}_path" || :root_path)
        text = opts.delete(:text) || item.to_s.titleize
        attrs = opts.except(SUBMENU)
        
        [text, path, attrs]
      end
    end
  end
end