require 'navigation'

ActionController::Base.class_eval do
  extend RPH::Navigation::ControllerMethods
  class_inheritable_accessor :_current_section
end

ActionView::Base.class_eval do
  include RPH::Navigation::Helpers
end