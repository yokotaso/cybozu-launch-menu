class TamagoyaMenu
  TITLE = "・たまごや"
  def initialize(mainMenu, subMenu, nutorition, memo)
    @mainMenu = mainMenu
    @subMenu  = subMenu
    @nutorition = nutorition
    @memo = memo
  end

  def print(printService)
    printService.printTopLevel TITLE
    [ @mainMenu, @subMenu, @nutorition, @memo ].each do |item| 
      item.print printService 
    end
  end
end
