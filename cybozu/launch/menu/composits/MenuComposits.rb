require "cybozu/launch/menu/exception/MenuNotFoundException.rb"
# Class for Node 
class Item
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def print(printService)
    printService.printIndentLevel2 @name
  end
  def ==(otherItem)
    self.class == otherItem.class && self.name == otherItem.name
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
  def initialize()
    @itemList = []
  end
  
  def add(item)
    @itemList << item 
    self
  end

  public
  def print(printService)
    if @itemList.empty? then
      raise MenuNotFoundException.new("空のItemListを出力しようとしています") 
    end

    @itemList.each { |item| item.print printService }
  end

end

class Category
  MAIN_MENU  = "■Main Menu"
  SUB_MENU   = "■Sub Menu"
  NUTORITION = "■Nutorition"
  CALORIE_OF_RICE = "ライス 340kcal"
  def self.mainMenu(itemList)
    return Category.new(self::MAIN_MENU, itemList)
  end

  def self.subMenu(itemList)
    return Category.new(self::SUB_MENU, itemList)
  end

  def self.nutorition(itemList)
    itemList.add(Item.new(self::CALORIE_OF_RICE))
    return Category.new(self::NUTORITION, itemList)
  end
  
  private
  def initialize(categoryName, itemList)
    @categoryName = categoryName
    @itemList = itemList
  end

  public
  def print(printService)
    printService.printIndentLevel1 @categoryName
    @itemList.print printService
    printService.printEndOfLine
  end
end

class Menu
  SAGANO = "■嵯峨野"
  TAMAGOYA = "■たまごや"

  def self.sagano()
    return self.new(self::SAGANO)
  end

  def self.tamagoya()
    return self.new(self::TAMAGOYA)
  end

  private
  def initialize(shopName)
    @shopName = shopName
    @categories = []
  end
  public
  def add(category) 
    @categories << category
    self
  end

  def print(printService)
    printService.printTopLevel @shopName
    @categories.each{ |category| category.print printService }
  end
end
