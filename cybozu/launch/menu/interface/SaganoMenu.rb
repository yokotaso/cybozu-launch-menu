class SaganoMenu
  TITLE = "・嵯峨野"
  def initialize(mainMenu, subMenu)
    @mainMenu = mainMenu
    @subMenu = subMenu
  end

  def print(printService)
   [@mainMenu, @subMenu].each { |menu| menu.print printService } 
  end
end
