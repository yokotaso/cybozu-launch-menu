require "mocha/api"
require "cybozu/launch/menu/composition/MenuComposits.rb"
require "cybozu/launch/menu/service/PrintService.rb"
describe "Composits of menu items" do
  NAME = "name of item"
  before(:all) { 
    @printService = PrintService.new() 
    def @printService.expectNeverInquired
      self.expects(:printIndentLevel1).never()\
          .expects(:printIndentLevel2).never()
    end
  }

  after(:all)  { @printService = nil }

  describe Item do
    it "should iquire PrintService to print name" do
      item = Item.new(NAME)
      @printService.expects(:printIndentLevel2).once().with(NAME)
      item.print @printService
    end
  end
  
  describe NotPrintable do
    it "should never iquire PrintService" do
      @printService.expectNeverInquired()
      notPrintable = NotPrintable.new()
      notPrintable.print @printService
    end
  end

  describe ItemList do
    describe "when there are no items in ItemList" do
      it "should never iquire PrintService" do
        @printService.expectNeverInquired()
        itemList = ItemList.new(NAME)
        itemList.print @printService
      end
    end

    describe "when there are some of items in ItemList" do
      it "should iquire PrintService to print title, menu name" do
        menuName = "Menu"
        itemList = ItemList.new(NAME)
        @printService.expects(:printIndentLevel1).once().with(NAME)
        @printService.expects(:printIndentLevel2).once().with(menuName)
        @printService.expects(:printEndOfLine).once()
        item = Item.new(menuName)
        itemList.add(item)
        itemList.print @printService
      end
    end
  end

  describe "factory methods" do
    menuName = "name of menu"
    describe "mainMenu" do
      it "should return ItemList of Main Menu" do
        menu = MenuItemFactory.mainMenu(menuName)
        @printService.expects(:printIndentLevel1).once().with(MenuItemFactory::Title::MAIN_MENU)
        @printService.expects(:printIndentLevel2).once().with(menuName)
        @printService.expects(:printEndOfLine).once()
        menu.print @printService
      end
    end

    describe "subMenu" do
      it "should return ItemList of Sub Menu" do
        menu = MenuItemFactory.subMenu()
        menu.add(Item.new("1")).add(Item.new("2"))
        @printService.expects(:printIndentLevel1).once().with(MenuItemFactory::Title::SUB_MENU)
        @printService.expects(:printIndentLevel2).twice()
        @printService.expects(:printEndOfLine).once()
        menu.print @printService
      end
    end

    describe "nutorition" do
      it "should returm ItemList of Nutorition" do
        calories = "XXX kcal"
        nutorition = MenuItemFactory.nutorition(calories)
        @printService.expects(:printIndentLevel1).once().with(MenuItemFactory::Title::NUTORITION)
        @printService.expects(:printIndentLevel2).twice()
        @printService.expects(:printEndOfLine).once()
        nutorition.print @printService
      end
    end
  end
end
