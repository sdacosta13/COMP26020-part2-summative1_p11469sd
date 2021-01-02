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

-- second binop is the inner operation

pGet :: Binop -> Integer

pGet Times = 4
pGet Div = 4
pGet Plus = 3
pGet Minus = 3
pGet Equal = 2
pGet Less = 2
pGet LessEq = 2
pGet And = 1
pGet Or = 0
