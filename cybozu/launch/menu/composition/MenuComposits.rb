module MenuItemFactory 
  module Title
    MAIN_MENU  = "■Main Menu"
    SUB_MENU   = "■Sub Menu"
    NUTORITION = "■Nutorition"
  end

  CALORIE_OF_RICE = "ライス 340kcal"
  # factory method for nutotirion 
  def self.nutorition(nutorition)
    itemList = ItemList.new(Title::NUTORITION)
    itemList.add(Item.new(CALORIE_OF_RICE))
    itemList.add(Item.new(nutorition))
    itemList
  end
  
  # factory method for main menu
  def self.mainMenu(menuName)
    itemList = ItemList.new(Title::MAIN_MENU)
    itemList.add(Item.new(menuName)) 
  end
  
  # factory method for sub menu
  def self.subMenu()
    itemList = ItemList.new(Title::SUB_MENU)
    itemList
  end
end

# Class for Node 
class Item
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

# Class for Composit structure
class ItemList 
  def initialize(title)
    @title = title
    @itemList = []
  end
  
  def add(item)
    @itemList << item 
    self
  end

  def print(printService)
    if @itemList.empty? then
      return
    end

    printService.printIndentLevel1  @title
    @itemList.each { |item| item.print printService }
    printService.printEndOfLine
  end
end


