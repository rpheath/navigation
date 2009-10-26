require File.join(File.dirname(__FILE__), 'test_helper')

Nav = Class.new(RPH::Navigation::Navigator)

class NavigationTest < ActiveSupport::TestCase
  def setup
    @view = ActionView::Base.new
    @basic = Nav.new(:basic, { :view => @view })
    @menu_with_proc = Nav.new(:menu_with_proc, { :view => @view })
    @custom_menu = Nav.new(:basic, { :view => @view, :class => "navigator" })
    @menu_with_submenu = Nav.new(:menu_with_submenu, { :view => @view })
  end
  
  context "default behavior" do
    test "should be basic navigation" do
      assert_equal @basic.name, "basic"
    end
  
    test "should have access to the view" do
      assert_equal @basic.view, @view
    end
  
    test "should have a 'navigation' css class" do
      assert_equal @basic.css_class, "navigation"
    end
  
    test "should be 'allowed' if no Proc is specified" do
      assert @basic.allowed?
    end
    
    test "menu items should be wrapped in an OrderedHash" do
      assert @basic.send(:items).is_a?(ActiveSupport::OrderedHash)
    end
    
    test "should have appropriate items (and in order)" do
      items = ActiveSupport::OrderedHash.new
      %w(home features events).each do |menu_item|
        items[menu_item] = {}
      end
      
      assert_equal @basic.send(:items), items
    end
  end
  
  context "custom menu options" do
    test "should have a custom CSS class" do
      assert_equal @custom_menu.css_class, "navigator"
    end
  end
  
  context "menu validation" do
    test "should be a valid menu" do
      assert @basic.send(:valid?, :basic)
    end
    
    test "should not be a valid menu" do
      assert !@basic.send(:valid?, :invalid_menu)
    end
  end
  
  context "menu with Proc dependency" do
    test "should be a valid menu" do
      assert @menu_with_proc.send(:valid?, :menu_with_proc)
    end
    
    test "should show the menu" do
      @view.instance_eval do
        def show_menu?
          true
        end
      end
      
      assert @menu_with_proc.allowed?
    end
    
    test "should NOT show the menu" do
      @view.instance_eval do
        def show_menu?
          false
        end
      end
      
      assert !@menu_with_proc.allowed?
    end
  end
  
  context "disecting menu items" do
    test "should return an array with 3 items" do
      result = @basic.send(:disect, 'home', {})
      assert result.is_a?(Array)
      assert_equal 3, result.size
    end
    
    test "should return a disected menu item" do
      result = @basic.send(:disect, 'home', {})
      assert_equal ["Home", "/home", {}], result
    end
    
    test "should return a disected menu item with custom path and options" do
      result = @basic.send(:disect, 'home', 
        { :path => "custom_home_path", :class => 'custom', :text => "Custom Home" })
      assert_equal ["Custom Home", "/path/to/home", { "class" => "custom" }], result
    end
    
    test "should return a disected menu item disregarding SUBMENU and :if options" do
      result = @basic.send(:disect, 'home', 
        { RPH::Navigation::SUBMENU => "whatever", :if => Proc.new {} })
      assert_equal ["Home", "/home", {}], result
    end
  end
  
  context "constructing the HTML" do
    test "should return the proper HTML links" do
      @view.controller = HomeController.new
      assert_equal @basic.links, [
        "<li class=\"current\"><a href=\"/home\">Home</a></li>",
        "<li class=\"\"><a href=\"/features\">Features</a></li>",
        "<li class=\"\"><a href=\"/events\">Events</a></li>"
      ]
    end
    
    test "should be current tab on the features link" do
      @view.controller = FeaturesController.new
      assert_equal @basic.links[1], "<li class=\"current\"><a href=\"/features\">Features</a></li>"
    end
    
    test "should return a nested submenu under the Home link" do
      @view.controller = HomeController.new
      assert_equal @menu_with_submenu.links, [
        "<li class=\"current\"><a href=\"/home\">Home</a><ul class=\"sub-navigation\"><li class=\"current\"><a href=\"/\">Index</a></li></ul></li>",
        "<li class=\"\"><a href=\"/features\">Features</a></li>"
      ]
    end
  end
end