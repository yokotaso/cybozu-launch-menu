require 'mocha/api'
require 'cybozu/launch/menu/service/SaganoPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'
require 'nokogiri'
require 'open-uri'
require 'kconv'

describe SaganoPageAnalyzeService do
  before(:each) do
    @document = Nokogiri::HTML.parse(open("spec/stub/sagano.html").read.toutf8, nil, 'UTF-8')
  end

  after(:each) do
    @document = nil
  end

  describe "when success to analyze document" do
    before(:each) do
      # collect parameter for testing
      @expected = ::PrintValueCollector.new()
      @actual   = ::PrintValueCollector.new() 
      expectedMainMenuList = ::ItemList.new()
      expectedMainMenuList.add(::Item.new("アジフライ")).add(::Item.new("具沢山金平ごぼう"))
      @expectedMainMenu = ::Category.mainMenu(expectedMainMenuList)

      expectedSubMenuList = ::ItemList.new()
      expectedSubMenuList.add(::Item.new("イカの味醂醤油焼き")).add(::Item.new("肉焼売"))\
                         .add(::Item.new("ラーパーツァイ（白菜の辛味甘酢漬け）"))\
                         .add(::Item.new("スパゲティサラダ")).add(::Item.new("しば漬け"))
      @expectedSubMenu = ::Category.subMenu(expectedSubMenuList)
      @service = SaganoPageAnalyzeService.new(@document)
    end

    after(:each) do
      @expected = nil
      @actual = nil
      @expectedMainMenu = nil
      @expectedSubMenu = nil
    end

    it "returns Category object of mainMenu" do
      actualMainMenu = @service.getMainMenu()
      actualMainMenu.should be_an_instance_of ::Category
      
      @expectedMainMenu.print @expected #collect string to print
      actualMainMenu.print @actual      #collect string to print 
      @actual.hasSameString(@expected).should be_true
    end

    it "returns Category object of subMenu" do
      actualSubMenu = @service.getSubMenu()
      actualSubMenu.should be_an_instance_of ::Category
      
      @expectedSubMenu.print @expected #collect string to print
      actualSubMenu.print @actual      #collect string to print 
      @actual.hasSameString(@expected).should be_true
    end
  end

  describe "when fail to analyze document, as a result of analyze" do
    it "should raise error when document is nil" do
      service = SaganoPageAnalyzeService.new(nil)
      expect {
       service.getMainMenu 
      }.to raise_error(MenuNotFoundException)

      expect {
       service.getSubMenu 
      }.to raise_error(MenuNotFoundException)
    end

    it "should raise error when parent element of menu is not found" do
      @document.css("div.inner").remove
      service = SaganoPageAnalyzeService.new(@document)
      expect {
        service.getMainMenu
      }.to raise_error(MenuNotFoundException)

      expect {
        service.getSubMenu
      }.to raise_error(MenuNotFoundException)
    end

    it "should raise error when main menu element is not found" do
      @document.css("div.inner").css("p").remove
      service = SaganoPageAnalyzeService.new(@document)
      expect {
        service.getMainMenu
      }.to raise_error(MenuNotFoundException)
    end

    it "should raise error when sub menu element is not found" do
      @document.css("div.inner").css("li").remove
      service = SaganoPageAnalyzeService.new(@document)
      expect {
        service.getSubMenu
      }.to raise_error(MenuNotFoundException)
    end
  end
end
