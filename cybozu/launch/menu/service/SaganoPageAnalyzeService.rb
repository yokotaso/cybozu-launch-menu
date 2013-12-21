require 'cybozu/launch/menu/composits/MenuComposits.rb'
require 'cybozu/launch/menu/exception/MenuNotFoundException.rb'
class SaganoPageAnalyzeService

  FAILED_PARSE_HTML = "嵯峨野のHTMLの解析に失敗しています(%message%)"
  def initialize(document)
    @document = document
  end

  def getMainMenu()
    return ::Category.mainMenu(getListOfMenu('p'))
  end

  def getSubMenu()
    return ::Category.subMenu(getListOfMenu('li'))
  end
  
  private
  def getListOfMenu(message)
    menuDocument = parse(message)
    return menuDocument.select { |menu| ! (menu.text.strip.empty?) }\
                       .inject(::ItemList.new()) { |itemList, menu| itemList.add(::Item.new(menu.text.strip)) }
  end
  private
  def parse(elementName)
    if @document == nil then
      raiseError("@document == null")
    end

    parentElement = @document.css('div.inner')
    if parentElement.empty? then
      raiseError("div.inner")
    end

    menuDocument = parentElement.css(elementName)
    if menuDocument.empty? then
      raiseError(elementName)
    end

    return menuDocument 
  end

  def raiseError(message)
    raise MenuNotFoundException.new(FAILED_PARSE_HTML.sub(/%message%/, message)) 
  end
end


