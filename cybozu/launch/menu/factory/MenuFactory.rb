require 'cybozu/launch/menu/composits/MenuComposits.rb'
class MenuFactory

  def sagano(saganoPageAnalyzeService)
    menu = ::Menu.sagano()
    mainMenu = saganoPageAnalyzeService.getMainMenu
    begin
      subMenu = saganoPageAnalyzeService.getSubMenu
    rescue MenuNotFoundException
      subMenu = ::NotPrintable.new()
    end
    menu.add(mainMenu).add(subMenu)
  end

  def tamagoya(tamagoyaPageAnalyzeService)
    menu = ::Menu.tamagoya()
    mainMenu = tamagoyaPageAnalyzeService.getMainMenu
    begin
      subMenu = tamagoyaPageAnalyzeService.getSubMenu
    rescue MenuNotFoundException
      subMenu = ::NotPrintable.new()
    end

    begin
      nutorition = tamagoyaPageAnalyzeService.getNutorition
    rescue MenuNotFoundException
      nutorition = ::NotPrintable.new()
    end
    menu.add(mainMenu).add(subMenu).add(nutorition)
  end
end
