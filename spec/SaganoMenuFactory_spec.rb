require 'mocha/api'
require 'cybozu/launch/menu/factory/MenuFactory.rb'
require 'cybozu/launch/menu/service/PageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'

describe SaganoMenuFactory do
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

  describe "when SaganoMenuFactory success to make Menu" do
    it "should inquire SaganoPageAnalyzeService to get main menu" do
      @sampleOfItem.expects(:print).once().with(@printService)
      @printService.expects(:printIndentLevel1).once().with(::MenuItemFactory::Title::MAIN_MENU)
      @printService.expects(:printEndOfLine).once()
      @saganoPageAnalyzeService.stubs(:getMainMenu).returns([@sampleOfItem])

      factory = SaganoMenuFactory.new(@saganoPageAnalyzeService)
      mainMenu = factory.makeMainMenu()
      mainMenu.should be_an_instance_of ::ItemList

      mainMenu.print @printService
    end

    it "should inquire SaganoPageAnlyzeService to get sub menu" do
      @sampleOfItem.expects(:print).once().with(@printService)
      @printService.expects(:printIndentLevel1).once().with(::MenuItemFactory::Title::SUB_MENU)
      @printService.expects(:printEndOfLine).once()
      @saganoPageAnalyzeService.stubs(:getSubMenu).returns([@sampleOfItem])

      factory = SaganoMenuFactory.new(@saganoPageAnalyzeService)
      subMenu = factory.makeSubMenu()
      subMenu.should be_an_instance_of ::ItemList
      subMenu.print @printService
    end
  end

  describe "when SaganoMenuFactory failed to make Menu" do
    it "should raise MenuNotFoundError to get main menu" do
      @saganoPageAnalyzeService.stubs(:getMainMenu).raises(MenuNotFoundException)
      factory = SaganoMenuFactory.new(@saganoPageAnalyzeService)
      proc {
        factory.makeMainMenu()
      }.should raise_error(MenuNotFoundException)
    end

    it "should return NotPrintable Object to get sub menu" do
      @saganoPageAnalyzeService.stubs(:getSubMenu).raises(MenuNotFoundException)
      factory = SaganoMenuFactory.new(@saganoPageAnalyzeService)
      subMenu = factory.makeSubMenu()
      subMenu.should be_an_instance_of NotPrintable
    end
  end
end
