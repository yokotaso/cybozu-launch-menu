require 'mocha/api'
require 'cybozu/launch/menu/service/PageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'
require 'nokogiri'
require 'open-uri'
require 'kconv'

describe SaganoPageAnalyzeService do
  before(:each) do
    @document = Nokogiri::HTML.parse(open("spec/stub/sagano.html").read.toutf8, nil, 'UTF-8')
    @printService = PrintService.new()
  end
  after(:each) do
    @document = nil
    @PrintService = nil
  end

  describe "when success to analyze document" do
    it "cloud create main menu" do
      service = SaganoPageAnalyzeService.new(@document)
      menus = service.getMainMenu()
      @printService.expects(:printIndentLevel2).with("アジフライ")
      @printService.expects(:printIndentLevel2).with("具沢山金平ごぼう")
      menus.each{ |menu| menu.print @printService }
    end

    it "cloud create sub menu" do
      service = SaganoPageAnalyzeService.new(@document)
      menus = service.getSubMenu()
      [ "イカの味醂醤油焼き", "肉焼売", "ラーパーツァイ（白菜の辛味甘酢漬け）", \
        "スパゲティサラダ", "しば漬け" ].each do |menu|
          @printService.expects(:printIndentLevel2).with(menu)
      end 
      menus.each{ |menu| menu.print @printService }
    end
  end

  describe "when fail to analyze document" do
    it "should raise error when document is null" do
      service = SaganoPageAnalyzeService.new(nil)
      expect {
       service.getMainMenu 
      }.to raise_error(MenuNotFoundException)
    end

    it "should raise error when parent element of menu is not found" do
      @document.css("div.inner").remove()
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
