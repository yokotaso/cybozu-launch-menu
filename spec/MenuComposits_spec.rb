require "mocha/api"
require "cybozu/launch/menu/composition/MenuComposits.rb"
require "cybozu/launch/menu/service/PrintService.rb"
describe Menu do
  describe "when printout menu"
    before do
      @menuName = "Some Menu"
      @menu = Menu.new(@menuName) 
      @printService = PrintService.new()
    end

    it "should iquire PrintService to print manu name" do
      @printService.expects(:printIndentLevel2).once().with(@menuName)
      @menu.print @printService
    end

    after do
      @menu = nil
      @meNuName = nil 
      @printService = nil
    end
end

describe NotPrintable do
  before do
    @notPrintable = NotPrintable.new()
    @printService = PrintService.new()
  end

  it "should never iquire PrintService" do
    @printService.expects(:printIndentLevel1).never()\
                 .expects(:printIndentLevel2).never()

    @notPrintable.print @printService
  end
end

describe MainMenu do
  before do
    @meinMenu = MainMenu.new(Menu.new("MainMenu"))
    @printService = PrintService.new()
  end

  it "should inquire PrintService to print title, name of main menu" do
    @printService.expects(:printIndentLevel1).once()
    @printService.expects(:printIndentLevel2).once()
  end
end

describe SubMenu do
  before(:all) do
    @subMenu = SubMenu.new()
    @printService = PrintService.new()
  end

  describe "when sub menu is empty" do
    it "should never iquire PrintService" do
      @printService.expects(:printIndentLevel1).never()
      @printService.expects(:printIndentLevel2).never()
      @subMenu.print @printService
    end
  end
 
  describe "when there are some of sub menu" do
    it "should iquire PrintService to print title, name of sub menus" do
      @subMenu.addMenu(Menu.new("subMenu1"))\
              .addMenu(Menu.new("subMenu2"))
      @printService.expects(:printIndentLevel1).once()
      @printService.expects(:printIndentLevel2).twice()
      @subMenu.print @printService
    end
  end

  after(:all) do
    @subMenu = nil
    @printService = nil
  end
end

describe Nutorition do
  before do
    @nutorition = Nutorition.new("elements of nutorition")
    @printService = PrintService.new() 
  end

  it "should inquire PrintService to print title,calorie of rice, nutorition of dishes" do
    @printService.expects(:printIndentLevel1).once()
    @printService.expects(:printIndentLevel2).twice()
    @nutorition.print @printService
  end
end
