require 'cybozu/launch/menu/composits/MenuComposits.rb'
class MenuFactory

  def sagano(saganoPageAnalyzeService)
    menu = ::Menu.sagano()
    mainMenus = saganoPageAnalyzeService.getMainMenu
    mainMenuList = appendToItemList(mainMenus)
    begin
      subMenus = saganoPageAnalyzeService.getSubMenu
      subMenuList = appendToItemList(subMenus)
    rescue MenuNotFoundException
      subMenuList = ::NotPrintable.new()
    end
    menu.add(::Category.mainMenu(mainMenuList)).add(::Category.subMenu(subMenuList))
  end

  def tamagoya(tamagoyaPageAnalyzeService)
    menu = ::Menu.tamagoya()
    mainMenus = tamagoyaPageAnalyzeService.getMainMenu
    mainMenuList = appendToItemList(mainMenus)
    begin
      subMenus = tamagoyaPageAnalyzeService.getSubMenu
      subMenuList = appendToItemList(subMenus)
    rescue MenuNotFoundException
      subMenuList = ::NotPrintable.new()
    end

    begin
      nutorition = tamagoyaPageAnalyzeService.getNutorition
      nutoritionList = appendToItemList(nutorition)
    rescue MenuNotFoundException
      nutoritionList = ::NotPrintable.new()
    end
    menu.add(::Category.mainMenu(mainMenuList))\
        .add(::Category.subMenu(subMenuList))\
        .add(::Category.nutorition(nutoritionList))
  end
  private 
  def appendToItemList(menus)
      menus.reduce(::ItemList.new()) { |itemList, item| itemList.add(item) }
  end
end
