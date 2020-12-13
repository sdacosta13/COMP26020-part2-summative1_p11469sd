{-
  Provide functions
    parseExp :: String -> Maybe Exp
    parseCom :: String -> Maybe Com


  to parse expressions and commands.
  You can use whatever parser technology you wish, however, we recommend using
  the simple parser combinators from the lecture (which is distributed in PComb.hs with this assignment),
  or the more advanced parsec framework.

  See Readme.md for the syntax of the language.
-}

module Parse (parseExp,parseCom) where
import While

{- Add your import declarations here -}


parseExp :: String -> Maybe Exp
parseExp s = Nothing   -- replace this line by your solution

parseCom :: String -> Maybe Com
parseCom s = Nothing   -- replace this line by your solution




