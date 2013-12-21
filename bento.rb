#!/usr/bin/ruby
require 'rubygems'
require 'cybozu/launch/menu/service/SaganoPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/TamagoyaPageAnalyzeService.rb'
require 'cybozu/launch/menu/service/PrintService.rb'
require 'cybozu/launch/menu/service/Client.rb'
require 'cybozu/launch/menu/factory/MenuFactory.rb'
require 'nokogiri'
require 'open-uri'
require 'kconv'

printer = PrintService.new()
saganoClient = Client.sagano()
tamagoClient = Client.tamagoya()
menuFactory = MenuFactory.new()
day = Time.now
printer.printTopLevel "Content-type: text/plain;"
printer.printTopLevel "charset=utf-8"
printer.printEndOfLine
printer.printTopLevel day.strftime("[ %Y/ %m/ %d ]") 
# Sagano
begin
  saganoDocument = saganoClient.getDocument
rescue OpenURI::HTTPError => e
  printer.printTopLevel "HTTPError(sagano) #{e.message}" 
end
begin
  saganoPageAnalyzer = SaganoPageAnalyzeService.new(saganoDocument)
  saganoMenu = menuFactory.sagano(saganoPageAnalyzer)
  saganoMenu.print printer
rescue MenuNotFoundException => e
  printer.printTopLevel "嵯峨野のメニュー取得に失敗しました"
  printer.printIndentLevel1 e.message
end

# Tamagoya
begin
  tamagoyaDocument = tamagoClient.getDocument
rescue OpenURI::HTTPError => e
  printer.printTopLevel "HTTPError(tamagoya) #{e.message}" 
end
begin
  tamagoyaPageAnalyzer = TamagoyaPageAnalyzeService.new(tamagoyaDocument, Time.now)
  tamagoyaMenu = menuFactory.tamagoya(tamagoyaPageAnalyzer)
  tamagoyaMenu.print printer
rescue MenuNotFoundException => e
  printer.printTopLevel "たまごやのメニュー取得に失敗しました"
  printer.printIndentLevel1 e.message
end

