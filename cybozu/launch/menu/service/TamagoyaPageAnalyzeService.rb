require 'cybozu/launch/menu/composits/MenuComposits.rb'
require 'cybozu/launch/menu/exception/MenuNotFoundException.rb'

class TamagoyaPageAnalyzeService
  FAILED_PARSE_HTML = "HTMLの解析に失敗しています(%message%)"
  def initialize(document, time)
    @document = document
    @today = time.day
  end

  def getMainMenu()
    return ::Category.mainMenu(getMenuElementOf("li.menu_maindish"))
  end

  def getSubMenu()
    return ::Category.subMenu(getMenuElementOf("li.menu_arrow"))
  end

  def getNutorition()
    return ::Category.nutorition(getMenuElementOf("p.menu_calorie"))
  end

  def getMemo()
    return ::NotPrintable.new()
  end
  private 
  def getMenuElementOf(elementName)
    menuElement = getMenuElementOfToday 
    menuElement.css(elementName).select { |menu| !(menu.text.strip.empty?) }\
                                .inject(::ItemList.new()) { |itemList, menu| itemList.add(::Item.new(menu.text.strip)) }
  end

  private
  def getIndexOfToday()
    if @document == nil then
      raiseError("@document == nil")
    end
    listOfDate = @document.css("p.menutitle_date")
    if listOfDate.empty? then
      raiseError("p.menutitle_date")
    end

    listOfDate.each_with_index do |eachDate, index|
      if eachDate.text.match(/#{@today}/)
        return index
      end
    end
    raiseError("Date:(#{@today}) can't be found.")
  end
  
  private
  def getMenuElementOfToday()
    indexOfToday = getIndexOfToday
    menuListOfWeek = @document.css("div.menu_list")
    if menuListOfWeek.empty? then
      raiseError("div.menu_list can't be found")
    end
    
    menuListOfToday = menuListOfWeek[indexOfToday]
    if menuListOfToday == nil then
      raiseError("div.menu_list[#{indexOfToday}] can't be found. (day:#{indexOfToday})")
    end
    return menuListOfToday
  end

  def raiseError(message)
    raise MenuNotFoundException.new(FAILED_PARSE_HTML.sub(/%message%/, message)) 
  end
end
