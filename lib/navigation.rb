require "navigation/error"
require "navigation/base"
require "navigation/navigator"
require "navigation/nested_menu"
require "navigation/menu"
require "navigation/builder"

module Navigation
  MENUS, SUBMENU = ActiveSupport::OrderedHash.new, :nested_navigation
  
  module ControllerMethods
    def current_section(section = nil)        
      self._current_section = section if section
      self._current_section
    end
  end
  
  module Helpers
    # renders the navigation identified by
    # the passed in name/key
    #
    # Ex:
    #  <%= navigation :primary %>
    #
    def navigation(key, options = {})
      options.merge!(:view => self)
      navigator = Navigator.new(key, options)
      if navigator.allowed?
        content_tag(:ul, navigator.links.join("\n").html_safe, options.merge!(:class => navigator.css_class))
      end
    end
  end
end

ActionController::Base.class_eval do
  extend Navigation::ControllerMethods
  class_attribute :_current_section
end

ActionView::Base.class_eval do
  include Navigation::Helpers
end