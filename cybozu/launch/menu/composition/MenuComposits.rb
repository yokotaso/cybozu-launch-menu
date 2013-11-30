class Menu
  def initialize(menuName)
    @menuName = menuName
  end

  def print(printService)
    printService.printIndentLevel2 @menuName
  end
end
# Null Object
class NotPrintable
  def print(printService)
    return
  end
end

class MainMenu
  def initialize(menu)
    @menu = menu
  end

  def print(printService)
    printServie.print "■MAIN MENU"
    menu.print printService
  end
end

class SubMenu
  def initialize()
    @menuList = []
  end
  
  def addMenu(menu)
    @menuList << menu
    self
  end

  def print(printService)
    if @menuList.empty? then
      return
    end
    printService.printIndentLevel1  "■SUB  MENU"
    @menuList.each do |menu|
     menu.print printService 
    end
  end
end

class Nutorition
  CALORIE_OF_RICE = "ライス 340kcal"
  def initialize(nutorition) 
    @nutorition = nutorition
  end

  def print(printService)
    printService.printIndentLevel1 "■NUTORITION"
    printService.printIndentLevel2 CALORIE_OF_RICE
    printService.printIndentLevel2 @nutorition
  end
end

