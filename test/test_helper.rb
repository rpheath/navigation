require 'rubygems'
require 'test/unit'
require 'action_view'
require 'active_support'
require 'active_support/test_case'
require 'context'
require File.join(File.dirname(__FILE__), '..', 'lib', 'navigation')

class HomeController
  def controller_name
    'home'
  end
  
  def action_name
    'index'
  end
end

class FeaturesController
  def controller_name
    'features'
  end
end

class ActionView::Base
  def root_path
    '/'
  end
  
  def home_path
    '/home'
  end
  
  def custom_home_path
    '/path/to/home'
  end
  
  def features_path
    '/features'
  end
  
  def events_path
    '/events'
  end
  
  def show_menu?
    true
  end
end

RPH::Navigation::Builder.config do |navigation|
  navigation.define :basic do |menu|
    menu.item :home
    menu.item :features
    menu.item :events
  end
end

RPH::Navigation::Builder.config do |navigation|
  navigation.define :menu_with_proc, :if => Proc.new { |view| view.show_menu? } do |menu|
    menu.item :home
  end
end

RPH::Navigation::Builder.config do |navigation|
  navigation.define :menu_with_submenu do |menu|
    menu.item :home do |sub|
      sub.item :index, :path => :root_path
    end
    menu.item :features
  end
end