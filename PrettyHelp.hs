module PrettyHelp where
import While
binToString :: Binop -> String
binToString Plus = "+"
binToString Minus = "-"
binToString Times = "*"
binToString Div = "/"
binToString Equal = "=="
binToString Less = "<"
binToString LessEq = "<="
binToString And = "&&"
binToString Or = "||"
