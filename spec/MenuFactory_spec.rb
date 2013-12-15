require 'mocha/api'
require 'cybozu/launch/menu/factory/MenuFactory.rb'
require 'cybozu/launch/menu/service/SaganoPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'

describe MenuFactory do
  before(:each) do
    @saganoPageAnalyzeService = SaganoPageAnalyzeService.new(nil)
    @printService = PrintService.new()
    @sampleOfItem = ::Item.new("Menu")
  end
  
  after(:each) do
    @saganoPageAnalyzeService = nil
    @printService = nil 
    @sampleOfItem = nil 
  end

  describe "when MenuFactory success to make Menu" do
    it "should inquire SaganoPageAnalyzeService to get menu" do
      @saganoPageAnalyzeService.stubs(:getMainMenu).returns([@sampleOfItem])
      @saganoPageAnalyzeService.stubs(:getSubMenu).returns([@sampleOfItem])
      factory = MenuFactory.new()
      mainMenu = factory.sagano(@saganoPageAnalyzeService)
      mainMenu.should be_an_instance_of ::Menu
    end

    it "should inquire SaganoPageAnlyzeService to get sub menu" do
      @saganoPageAnalyzeService.stubs(:getMainMenu).returns([@sampleOfItem])
      @saganoPageAnalyzeService.stubs(:getSubMenu).returns([@sampleOfItem])
      factory = MenuFactory.new()
      subMenu = factory.sagano(@saganoPageAnalyzeService)
      subMenu.should be_an_instance_of ::Menu
    end
  end

  describe "when MenuFactory failed to make Menu" do
    it "should raise MenuNotFoundError to get main menu" do
      @saganoPageAnalyzeService.stubs(:getMainMenu).raises(MenuNotFoundException)
      factory = MenuFactory.new()
      proc {
        factory.sagano(@saganoPageAnalyzeService)
      }.should raise_error(MenuNotFoundException)
    end
  end
end
