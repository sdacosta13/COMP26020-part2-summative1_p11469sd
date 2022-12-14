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
import Control.Applicative(empty)
import Text.ParserCombinators.Parsec.Language
import qualified Text.ParserCombinators.Parsec.Token as Token
import Control.Monad
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr
import Data.Maybe
{-
parseExp :: String -> Maybe Exp
parseExp str = do
  result <- parse parseExpression "" str
  if(result == ParseError)
    then return Nothing
    else return result
-}
parseExp :: String -> Maybe Exp
parseExp str = do
  let str2 = removeInitialWhiteSpace str
  case parse parseExpression "" str2 of
    Left x -> Nothing
    Right x -> Just x


parseCom :: String -> Maybe Com
parseCom s = do
  let str2 = removeInitialWhiteSpace s
  case parse program "" str2 of
    Left x -> Nothing
    Right x -> Just x

languageDef =
  emptyDef { Token.identStart = letter <|> char '_'
           , Token.identLetter = letter <|> alphaNum <|> char '_'
           , Token.reservedNames = ["if",
                                    "else",
                                    "while",
                                    "do"
                                    ]
           , Token.reservedOpNames = ["+", "-", "/", "*", "==", "<", "<=", "&&", "||", "="]
           }
lexer      = Token.makeTokenParser languageDef
identifier = Token.identifier lexer
reserved   = Token.reserved lexer
reservedOp = Token.reservedOp lexer
parens     = Token.parens lexer
integer    = Token.integer lexer
semi       = Token.semi lexer
whitespace = Token.whiteSpace lexer
symbol = Token.symbol lexer


parseExpression :: Parser Exp
parseExpression = buildExpressionParser ops expression

ops = [
  [Prefix (reservedOp "-" >> return (Uminus))],
  [Infix (reservedOp "*" >> return (Binop Times)) AssocLeft, Infix (reservedOp "/" >> return (Binop Div)) AssocLeft],
  [Infix (reservedOp "+" >> return (Binop Plus )) AssocLeft, Infix (reservedOp "-" >> return (Binop Minus)) AssocLeft],
  [Infix (reservedOp "==" >> return (Binop Equal )) AssocLeft, Infix (reservedOp "<" >> return (Binop Less)) AssocLeft, Infix (reservedOp "<=" >> return (Binop LessEq)) AssocLeft],
  [Infix (reservedOp "&&" >> return (Binop And )) AssocLeft],
  [Infix (reservedOp "||" >> return (Binop Or )) AssocLeft]
  ]
{-
binopParser = do
  operand1 <- parseExpression
  operation <- reservedOp
  operand2 <- parseExpression
  return $ Binop operation operand1 operand2
-}
expression = parens parseExpression <|> liftM Var identifier <|> liftM Const integer

removeInitialWhiteSpace :: String -> String
removeInitialWhiteSpace (s:xs) | s == ' ' = removeInitialWhiteSpace xs
removeInitialWhiteSpace (s:xs) | s == '\n' = removeInitialWhiteSpace xs
removeInitialWhiteSpace (s:xs) | s == '\t' = removeInitialWhiteSpace xs
removeInitialWhiteSpace x = x

program :: Parser Com
program = ifParser <|> whileParser <|> assignParser <|> seqParser

assignParser :: Parser Com
assignParser = do
  variable <- identifier
  reservedOp "="
  expression <- parseExpression
  return $ Assign variable expression

whileParser :: Parser Com
whileParser = do
  reserved "while"
  expression <- parseExpression
  reserved "do"
  component <- program
  return $ While expression component

ifParser :: Parser Com
ifParser = do
  reserved "if"
  expression <- parseExpression
  reserved "then"
  component1 <- program
  reserved "else"
  component2 <- program
  return $ If expression component1 component2

seqParser :: Parser Com
seqParser = do
  symbol "{"
  list <- (sepBy program semi)
  symbol "}"
  if (length list == 0)
    then return (Seq [])
    else return (Seq list)






--
