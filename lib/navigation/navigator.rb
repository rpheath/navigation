module RPH
  module Navigation
    class Navigator < Base
      attr_reader :name, :view
      
      def initialize(name, options)
        # must have menu definitions at this point
        raise NoMenuDefinitions, NoMenuDefinitions.message if MENUS.blank?
        # since multiple menus are supported, must have the name of the desired menu
        raise BlankMenuIdentifier, BlankMenuIdentifier.message if name.blank?
        # menu name/key must exist in the current menu definitions
        raise InvalidMenuIdentifier, InvalidMenuIdentifier.message unless valid?(name)
        
        # need a reference of the view/view
        # for building out the HTML
        @view = options.delete(:view)
        
        # initialization
        @name, @options = normalize(name), options
        
        # support building separate menus for actions,
        # without forcing it to be nested
        @action_menu = MENUS[@name][:action_menu]
        
        # menus can be shown/hidden based on
        # conditions by passing a Proc object
        #  Ex: 
        #   navigation.define :primary, :if => Proc.new { |c| c.logged_in? } do |menu|
        #     ...
        #   end
        @proc = MENUS[@name][:if]
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
      
      def allowed?
        execute_proc @proc
      end

    protected
      # calls a proc and hands it 
      # the view/template instance
      def execute_proc(proc)
        return true unless proc.is_a?(Proc)
        proc.call(self.view)
      end
      
      # convenience method
      def items
        MENUS[@name].except(:action_menu, :if)
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
          next(items) unless execute_proc(opts[:if])
          
          text, path, attrs = self.disect(item, opts)
          subnav = construct_html(menu[item][SUBMENU], true).to_s
          attrs.merge!(:class => [attrs[:class], self.current_css(item, nested)].compact.join(' '))
          items << self.view.content_tag(:li, self.view.link_to(text, path) + subnav, attrs)
        end
        
        nested ? self.view.content_tag(:ul, links, :class => 'sub-navigation') : links
      end
      
      # determines if the menu item matches the current section
      # (considers both levels: controller and action)
      def current_css(item, nested = false)
        name = if (nested || @action_menu)
          self.view.action_name 
        else
          (controller_override = self.view.controller.class.current_section).blank? ? 
            self.view.controller_name : controller_override
        end
        
        'current' if normalize(name) == normalize(item)
      end
      
      # pulls out the goodies for use 
      # in the HTML construction
      def disect(item, opts)
        opts = HashWithIndifferentAccess.new(opts).symbolize_keys!

        path = self.view.send(opts.delete(:path) || "#{item.to_s.underscore}_path" || :root_path)
        text = opts.delete(:text) || item.to_s.titleize
        text = execute_proc(text) if text.is_a?(Proc)
        attrs = opts.except(SUBMENU, :if)
        
        [text, path, attrs]
      end
    end
  end
end