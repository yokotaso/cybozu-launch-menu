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
end
