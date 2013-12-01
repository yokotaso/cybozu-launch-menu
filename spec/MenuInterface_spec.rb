require "mocha/api"
require "cybozu/launch/menu/interface/TamagoyaMenu.rb"
require "cybozu/launch/menu/interface/SaganoMenu.rb"
require "cybozu/launch/menu/composits/MenuComposits.rb"
require "cybozu/launch/menu/service/PrintService.rb"

describe "MenuInterface" do
  before(:each) { 
    @printService = PrintService.new() 
    def @printService.expectTopLevelPrintOf(title)
      self.expects(:printTopLevel).once().with(title)
    end
    @mainMenu = MenuItemFactory.mainMenu().add(Item.new("mainMenu"))
    @mainMenu.expects(:print).once().with(@printService)
    @subMenu  = MenuItemFactory.subMenu().add(Item.new("SubMenuName"))
    @subMenu.expects(:print).once().with(@printService)
  }

  after(:each)  { @printService = nil }

  describe SaganoMenu do
    it "should print out title, main menu, sub menu" do
      @printService.expectTopLevelPrintOf(SaganoMenu::TITLE) 
      sagano = SaganoMenu.new(@mainMenu, @subMenu)
      sagano.print @printService
    end
  end

  describe TamagoyaMenu do
    it "should print out title, main menu, sub menu, nutorition, memo" do
      nutorition = MenuItemFactory.nutorition("some of nutorition")
      nutorition.expects(:print).once().with(@printService)

      memo = NotPrintable.new()
      memo.expects(:print).once().with(@printService)
     
      @printService.expectTopLevelPrintOf(TamagoyaMenu::TITLE)
      tamagoya = TamagoyaMenu.new(@mainMenu, @subMenu, nutorition, memo)
      tamagoya.print @printService
    end
  end

end

