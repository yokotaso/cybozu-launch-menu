require 'nokogiri'
require 'open-uri'
require 'kconv'

class Client
  SAGANO_URL="http://www.bento-sagano.jp/menu/higawari/index.html"
  TAMAGOYA_URL="http://www.tamagoya.co.jp/menu.html"
  
  def initialize(url)
    @url = url
  end
  def self.sagano()
    return Client.new(self::SAGANO_URL)
  end

  def self.tamagoya()
    return Client.new(self::TAMAGOYA_URL)
  end

  def getDocument()
    return Nokogiri::HTML.parse(open(@url).read.toutf8, nil, 'UTF-8')
  end
end
