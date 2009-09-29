%w(error base navigator nested_menu menu builder).each do |f|
  require File.join(File.dirname(__FILE__), 'navigation', f)
end

module RPH
  module Navigation
    MENUS, SUBMENU = ActiveSupport::OrderedHash.new, :nested_navigation
    
    module Helpers
      # renders the navigation identified by
      # the passed in name/key
      #
      # Ex:
      #  <%= navigation :primary %>
      #
      def navigation(key, options = {})
        options.merge!(:template => self)
        navigator = Navigator.new(key, options)
        content_tag(:ul, navigator.links, options.merge!(:class => navigator.css_class))
      end
    end
  end
end