require 'cybozu/launch/menu/interface/SaganoMenu.rb'
require 'cybozu/launch/menu/composits/MenuComposits.rb'
class SaganoMenuFactory

  def initialize(pageAnalyzeService)
    @pageAnalyzeService = pageAnalyzeService
  end
  
  def makeMainMenu()
    mainMenu = ::MenuItemFactory.mainMenu() 
    @pageAnalyzeService.getMainMenu().each { |menu| mainMenu.add(menu) }
    return mainMenu 
  end

  def makeSubMenu()
    begin
      subMenu = ::MenuItemFactory.subMenu()
      @pageAnalyzeService.getSubMenu().each{ |menu| subMenu.add(menu) }
      return subMenu
    rescue MenuNotFoundException 
      return ::NotPrintable.new()
    end
  end
end
