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
import PComb
import Control.Monad(liftM,ap,liftM2,guard)
import Control.Applicative( empty, (<|>), Alternative )
import Data.Char(isDigit,isLetter,isSpace)


parseNumber :: String -> Maybe(Exp, String)
parseNumber x = do
  (number, remainder) <- parse number x
  return ((Const number), remainder)

parseVar :: String -> Maybe(Exp, String)
parseVar x = do
  (var, remainder) <- parse ident x
  return ((Var var), remainder)

parseBinop :: String -> Maybe(Exp, String)
parseBinop s = do
  (num1, rem1) <- parse number s 
  (op1, rem2) <- parse item rem1
  if((stringToBin [op1]) /= Nothing)
    then do
      (num2, rem3) <- parse number rem2
      return ((Binop (stringToBinM [op1]) (Const num1) (Const num2)), rem3)
    else do
      (op2, rem3) <- parse item rem2
      if(stringToBin ([op1]++[op2]) /= Nothing)
        then do
          (num2, rem4) <- parse number rem3
          return ((Binop (stringToBinM ([op1]++[op2])) (Const num1) (Const num2)),rem4)
        else do
          empty



stringToBin :: String -> Maybe Binop
stringToBin "==" = Just(Equal)
stringToBin "+" = Just(Plus)
stringToBin "-" = Just(Minus)
stringToBin "*" = Just(Times)
stringToBin "/" = Just(Div)
stringToBin "<" = Just(Less)
stringToBin "<=" = Just(LessEq)
stringToBin "&&" = Just(And)
stringToBin "||" = Just(Or)
stringToBin x = Nothing

stringToBinM :: String -> Binop
stringToBinM "==" = Equal
stringToBinM "+" = Plus
stringToBinM "-" = Minus
stringToBinM "*" = Times
stringToBinM "/" = Div
stringToBinM "<" = Less
stringToBinM "<=" = LessEq
stringToBinM "&&" = And
stringToBinM "||" = Or


parseExp :: String -> Maybe Exp
parseExp x = do
  ex <- parseNumber x <|> parseVar x
  return (fst ex)


parseCom :: String -> Maybe Com
parseCom s = Nothing



ts = "34"
