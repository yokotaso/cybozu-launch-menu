require "mocha/api"
require "cybozu/launch/menu/interface/TamagoyaMenu.rb"
require "cybozu/launch/menu/composition/MenuComposits.rb"
require "cybozu/launch/menu/service/PrintService.rb"

describe TamagoyaMenu do
  before(:all) { @printService = PrintService.new() }
  after(:all)  { @printService = nil }

  it "should print out main menu, sub menu, nutorition, memo" do
    @printService.expects(:printTopLevel).once().with(TamagoyaMenu::TITLE)

    mainMenu = MenuItemFactory.mainMenu("MainMenuName")
    mainMenu.expects(:print).once().with(@printService)

    subMenu  = MenuItemFactory.subMenu().add(Item.new("SubMenuName"))
    subMenu.expects(:print).once().with(@printService)

    nutorition = MenuItemFactory.nutorition("some of nutorition")
    nutorition.expects(:print).once().with(@printService)

    memo = NotPrintable.new()
    memo.expects(:print).once().with(@printService)

    tamagoya = TamagoyaMenu.new(mainMenu, subMenu, nutorition, memo)
    tamagoya.print @printService
  end
end

