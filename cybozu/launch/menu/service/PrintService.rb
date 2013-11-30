# データ出力責務を担う
# 関数によってインデントレベルが変わる
# printTopLevel => トップレベル
# printIndentLevel1 => インデントレベル1
# printIndentLevel2 => インデントレベル2
class PrintService
  
  def printTopLevel(string)
    puts string
  end
  
  def printIndentLevel1(string)
    puts " " , string
  end

  def printIndentLevel2(string)
    puts "  ", string
  end
end
