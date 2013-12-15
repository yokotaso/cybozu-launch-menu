require 'mocha/api'
require 'cybozu/launch/menu/factory/MenuFactory.rb'
require 'cybozu/launch/menu/service/SaganoPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/TamagoyaPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'

describe MenuFactory do
  before(:each) do
    @menuFactory = MenuFactory.new()
    @saganoPageAnalyzeService = SaganoPageAnalyzeService.new(nil)
    @tamagoyaPageAnalyzeService = TamagoyaPageAnalyzeService.new(nil,Time.now)
  end
  
  after(:each) do
    @menuFactory = nil
    @saganoPageAnalyzeService = nil
    @tamagoyaPageAnalyzeService = nil
  end
  describe "when success to make menu" do
    it "should return Menu Object when success to get menu" do
      @saganoPageAnalyzeService.stubs(:getMainMenu).returns(::Category.mainMenu(nil))
      @saganoPageAnalyzeService.stubs(:getSubMenu).returns(::Category.subMenu(nil))
      saganoMenu = @menuFactory.sagano(@saganoPageAnalyzeService)
      saganoMenu.should be_instance_of ::Menu

      @tamagoyaPageAnalyzeService.stubs(:getMainMenu).returns(::Category.mainMenu(nil))
      @tamagoyaPageAnalyzeService.stubs(:getSubMenu).returns(::Category.subMenu(nil))
      @tamagoyaPageAnalyzeService.stubs(:getNutorition).returns(::Category.nutorition(::ItemList.new()))
      tamagoyaMenu = @menuFactory.tamagoya(@tamagoyaPageAnalyzeService)
      tamagoyaMenu.should be_instance_of ::Menu
    end

    def getStubMainMenu 
      expectedItemList = ::ItemList.new()
      expectedItemList.add(::Item.new("stub main menu"))
      return ::Category.mainMenu(expectedItemList)
    end

    def getNotPrintable
      return ::NotPrintable.new()
    end

    def getPrintValueCollector
      return ::PrintValueCollector.new()
    end

    it "should return Menu Object of sagano nevertheless getMainMenu don't raise Error" do
      expectedPrintValueCollector = getPrintValueCollector 
      actualPrintValueCollector   = getPrintValueCollector 
      @saganoPageAnalyzeService.stubs(:getMainMenu).returns(getStubMainMenu)
      @saganoPageAnalyzeService.stubs(:getSubMenu).raises(MenuNotFoundException)
      expectedSaganoMenu = ::Menu.sagano()
      expectedSaganoMenu.add(getStubMainMenu).add(getNotPrintable)
      actualSaganoMenu = @menuFactory.sagano(@saganoPageAnalyzeService)
      expectedSaganoMenu.print expectedPrintValueCollector
      actualSaganoMenu.print actualPrintValueCollector
      actualPrintValueCollector.hasSameString(expectedPrintValueCollector).should be_true
    end

    it "should return Menu Object of tamagoya nevertheless getMainMenu don't raise Error" do
      expectedPrintValueCollector = getPrintValueCollector 
      actualPrintValueCollector   = getPrintValueCollector 
      @tamagoyaPageAnalyzeService.stubs(:getMainMenu).returns(getStubMainMenu)
      @tamagoyaPageAnalyzeService.stubs(:getSubMenu).raises(MenuNotFoundException)
      @tamagoyaPageAnalyzeService.stubs(:getNutorition).raises(MenuNotFoundException)

      expectedTamagoyaMenu = ::Menu.tamagoya()
      expectedTamagoyaMenu.add(getStubMainMenu).add(getNotPrintable).add(getNotPrintable)

      actualTamagoyaMenu = @menuFactory.tamagoya(@tamagoyaPageAnalyzeService)

      expectedTamagoyaMenu.print expectedPrintValueCollector
      actualTamagoyaMenu.print actualPrintValueCollector
      actualPrintValueCollector.hasSameString(expectedPrintValueCollector).should be_true
    end
  end

  describe "when fail to make menu" do
    it "should raise MenuNotFoundException when fail to get main menu" do
      @saganoPageAnalyzeService.stubs(:getMainMenu).raises(MenuNotFoundException)
      @tamagoyaPageAnalyzeService.stubs(:getMainMenu).raises(MenuNotFoundException)

      expect {
        @menuFactory.sagano(@saganoPageAnalyzeService)
      }.to raise_error(MenuNotFoundException)

      expect {
        @menuFactory.tamagoya(@tamagoyaPageAnalyzeService)
      }.to raise_error(MenuNotFoundException)
    end
  end
end
