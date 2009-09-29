require 'navigation'

ActionView::Base.class_eval do
  include RPH::Navigation::Helpers
end