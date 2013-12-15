require 'mocha/api'
require 'cybozu/launch/menu/service/SaganoPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'
require 'nokogiri'
require 'open-uri'
require 'kconv'

describe SaganoPageAnalyzeService do
  before(:each) do
    @document = Nokogiri::HTML.parse(open("spec/stub/sagano.html").read.toutf8, nil, 'UTF-8')
    @expectedSetsOfMainMenu = [ ::Item.new("アジフライ"), ::Item.new("具沢山金平ごぼう") ]
    @expectedSetsOfSubMenu = [::Item.new("イカの味醂醤油焼き"), \
                              ::Item.new("肉焼売"),
                              ::Item.new("ラーパーツァイ（白菜の辛味甘酢漬け）"),\
                              ::Item.new("スパゲティサラダ"),\
                              ::Item.new("しば漬け")]
  end

  after(:each) do
    @document = nil
  end

  describe "when success to analyze document" do
    it "returns Array of Item" do
      service = SaganoPageAnalyzeService.new(@document)
      mainMenu = service.getMainMenu()
      mainMenu.should be_an_instance_of ::Array
      mainMenu.each do |menu, indx|
        menu.should be_an_instance_of ::Item
      end

      mainMenu.each_with_index do |menu, index|
        menu.should == @expectedSetsOfMainMenu[index]
      end

      subMenu = service.getSubMenu()
      subMenu.should be_an_instance_of ::Array
    end
  end

  describe "when fail to analyze document, as a result of analyze, user can't find main menu" do
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
    end

    it "should raise error when main menu element is not found" do
      @document.css("div.inner").css("p").remove
      service = SaganoPageAnalyzeService.new(@document)
      expect {
        service.getMainMenu
      }.to raise_error(MenuNotFoundException)
    end
  end
end
