# データ出力責務を担う
# 関数によってインデントレベルが変わる
# printTopLevel => トップレベル
# printIndentLevel1 => インデントレベル1
# printIndentLevel2 => インデントレベル2
class PrintService
  
  def printTopLevel(string)
    print string , "\n"
  end
  
  def printIndentLevel1(string)
    print " " , string , "\n"
  end

  def printIndentLevel2(string)
    print "  ", string , "\n"
  end

  def printEndOfLine()
    print "\n"
  end
end
