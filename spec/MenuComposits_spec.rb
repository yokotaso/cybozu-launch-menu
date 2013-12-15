require "mocha/api"
require "cybozu/launch/menu/composits/MenuComposits.rb"
require "cybozu/launch/menu/service/PrintService.rb"
describe "Composits of menu items" do
  NAME = "name of item"
  before(:each) { @printService = PrintService.new() }

  after(:each)  { @printService = nil }

  describe Item do
    it "should iquire PrintService to print name" do
      item = Item.new(NAME)
      @printService.expects(:printIndentLevel2).once().with(NAME)
      item.print @printService
    end
  end
  
  describe NotPrintable do
    it "should never iquire PrintService" do
      @printService.expects(:printIndentLevel1).never()
      @printService.expects(:printIndentLevel2).never()

      notPrintable = NotPrintable.new()
      notPrintable.print @printService
    end
  end

  describe ItemList do
    describe "when there are no items in ItemList" do
      it "should raise MenuNotFoundException" do
        itemList = ItemList.new()
        proc {
          itemList.print @printService
        }.should raise_error( MenuNotFoundException )
      end
    end

    describe "when there are some of items in ItemList" do
      it "should iquire PrintService to print title, menu name" do
        itemList = ItemList.new()
        itemList.expects(:print).once().with(@printService)
        item = Item.new(NAME)
        itemList.add(item)
        itemList.print @printService
      end
    end
  end

  describe Category do
    describe "factory mehtod main menu" do
      it "should print category name, item list, end of line" do
        itemList = ItemList.new()
        itemList.expects(:print).once().with(@printService)
        category = Category.mainMenu(itemList)
        @printService.expects(:printIndentLevel1).with(Category::MAIN_MENU)
        @printService.expects(:printEndOfLine).once()
        category.print @printService
      end
    end
  end
end
