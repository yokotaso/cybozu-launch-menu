require 'cybozu/launch/menu/composits/MenuComposits.rb'
require 'cybozu/launch/menu/exception/MenuNotFoundException.rb'
class SaganoPageAnalyzeService

  FAILED_PARSE_HTML = "HTMLの解析に失敗しています(%message%)"
  def initialize(document)
    @document = document
  end

  def getMainMenu()
    return getListOfMenu('p')
  end

  def getSubMenu()
    return getListOfMenu('li')
  end
  
  private
  def getListOfMenu(message)
    menuDocument = validate(message)
    return menuDocument.select { |menu| ! (menu.text.strip.empty?) }\
                       .map    { |menu| ::Item.new(menu.text.strip) }
  end
  private
  def validate(elementName)
    if @document == nil then
      raiseError("@document == null")
    end

    parentElement = @document.css('div.inner')
    if parentElement == nil then
      raiseError("div.inner")
    end

    menuDocument = parentElement.css(elementName)
    if menuDocument == nil then
      raiseError(elementName)
    end

    return menuDocument 
  end

  def raiseError(message)
    raise MenuNotFoundException.new(FAILED_PARSE_HTML.sub(/%message%/, message)) 
  end
end

class TamagoyaPageAnalyzeService
  def initizlie(document)
    @document = document
  end

  def getMainmenu()

  end

  def getSubMenu()

  end

  def getNutorition()

  end

  def getMemo()

  end

end
