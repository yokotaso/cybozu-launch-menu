require 'mocha/api'
require 'cybozu/launch/menu/service/TamagoyaPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'
require 'nokogiri'
require 'open-uri'
require 'kconv'

describe TamagoyaPageAnalyzeService do
  before(:each) do
    @document = Nokogiri::HTML.parse(open("spec/stub/tamagoya.html").read.toutf8, nil, 'UTF-8')
    time = Time.now
    time.stubs(:day).returns(18)
    @service = TamagoyaPageAnalyzeService.new(@document, time)

  end

  after(:each) do
    @document = nil
  end
  describe "when success to analyze document" do
    before(:each) do
      @expectedDataCollector = ::PrintValueCollector.new()
      @actualDataCollector = ::PrintValueCollector.new()
    end

    after(:each) do
      @service = nil
      @expectedMainMenu = nil
      @expectedDataCollector = nil
      @actualDataCollector = nil
    end

    it "returns contents of main menu" do
      mainMenuItemList = ItemList.new()
      mainMenuItemList.add(Item.new("イタリア産ホエー豚豚肉はちみつ生姜焼"))
      expectedMainMenu =  Category.mainMenu(mainMenuItemList)

      actualMainMenu = @service.getMainMenu
      actualMainMenu.should be_an_instance_of ::Category
      expectedMainMenu.print @expectedDataCollector
      actualMainMenu.print @actualDataCollector
      @actualDataCollector.hasSameString(@expectedDataCollector).should be_true  
    end

    it "returns contents of sub menu" do
      subMenuItemList = ItemList.new()
      subMenuItemList.add(Item.new("ほっけ塩焼"))\
                     .add(Item.new("葉わさび椎茸"))\
                     .add(Item.new("厚切りハムの天ぷら"))\
                     .add(Item.new("油揚と小松菜の煮びたし"))\
                     .add(Item.new("ドレッシング添え千切キャベツ"))
      expectedSubMenu = Category.subMenu(subMenuItemList)

      actualSubMenu = @service.getSubMenu
      actualSubMenu.should be_an_instance_of ::Category
      expectedSubMenu.print @expectedDataCollector
      actualSubMenu.print @actualDataCollector
      @actualDataCollector.hasSameString(@expectedDataCollector).should be_true
    end

    it "returns contents of nutorition" do
      nutoritionItemList = ItemList.new()
      nutoritionItemList.add(Item.new("おかずのカロリー412kcal／塩分4.0g"))
      expectedNutorition = Category.nutorition(nutoritionItemList)                  
      actualNutorition = @service.getNutorition

      expectedNutorition.print @expectedDataCollector
      actualNutorition.print @actualDataCollector
      @actualDataCollector.hasSameString(@expectedDataCollector).should be_true
    end
  end

  describe "when fail to analyze document" do
    it "should raise error when document is nil" do
      service = TamagoyaPageAnalyzeService.new(nil, Time.now)

      expect {
        service.getMainMenu
      }.to raise_error(MenuNotFoundException)

      expect {
        service.getSubMenu
      }.to raise_error(MenuNotFoundException)
    end

    it "should raise error when element of date can't be found" do
      @document.css("p.menutitle_date").remove

      expect {
        @service.getMainMenu
      }.to raise_error(MenuNotFoundException) 

      expect {
        @service.getSubMenu
      }.to raise_error(MenuNotFoundException)
    end

    it "should raise error when element of menu list can't be found" do
      @document.css("div.menu_list").remove

      expect {
        @service.getMainMenu
      }.to raise_error(MenuNotFoundException) 

      expect {
        @service.getSubMenu
      }.to raise_error(MenuNotFoundException)

    end
 end
end
