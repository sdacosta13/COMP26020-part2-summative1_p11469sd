{-
  Implement a pretty-printer for expressions and commands.
  Also refer to the syntax description in Readme.md!

  Here are the rules. As they are in English text, they might be ambiguous, so
  refer to the given test-sets for disambiguation!
  Aspects not specified by the rules can be implemented as you like (As long as you can parse your own output in the second part of this exercise).

  Expressions:
    As a general rule, pretty-printing shall not drop any information in the AST.
    In particular, the association of binary operators shall still be visible, i.e.
    do print Plus a (Plus b c) as "a+(b+c)" (and NOT as "a+b+c")

    * Only print parenthesis if they are required. In particular:

      Don't print parenthesis if given by operator priority, e.g.
        a*b+c instead of (a*b)+c

      Don't print parenthesis if given by operator associativity. All operators associate to the left!
      E.g., print:
        a-b-c instead of (a-b)-c
        a+b+c instead of (a+b)+c

      Unary minus: regard the unary minus rules in Readme.md, and be careful to not confuse the ASTs
        for "Uminus (Const x)" and "Const (-x)", e.g.

        Uminus (Const 42) -> "-(42)"
        Const (-x) -> -42


  Commands:
  * Separate commands in sequential composition by ;, use { and } as delimiters

    * insert line breaks
        after: do, then, else, command in sequential composition
      * Exception: do not insert line-breaks between {,} and then,else,do
      * Exception: do not insert line break between else and if

    * increase level of indentation inside if and while. Use 2 spaces per level of indentation.

    * Delimit all Seq-blocks with {}, even if nested

    E.g.

    {}   (for Seq [])

    {
      {}
    }

    {
      x = 1
    }

    {
      x = 1;
      y = 2
    }

    while c>0 do {
      x=x*2;
      c=c-1
    }

    if b then
      x=1
    else {
      x=x*3;
      y=1
    }

    if b then {
      x=1
    } else if c then {
      x=2;
      b=1
    } else {
      x=3
    }



-}
module Pretty (prettyExp, prettyCom) where
import While

{- Add your import declarations here! -}
import PrettyHelp
{-
prettyExp :: Exp -> String
prettyExp e = ""   -- replace this line by your solution


prettyCom :: Com -> String

prettyCom c = ""   -- replace this line by your solution
-}


--prettyExp needs parenthesis on the left to be complete
--(epr-4) operators associate to the left, so omit parenthesis in the "(a+b)+c" - case, but still print them for "a+(b+c)"

exp1 = Binop (Plus) (Var "X") (Const 2)
exp2 = Uminus exp1
exp3 = Const 42
exp4 = Binop Times (Binop Plus (Var "a") (Binop Plus (Var "b") (Var "d"))) (Var "c")
exp5 = Binop Times (Binop Plus (Var "a") (Var "b")) (Var "c")

prettyExp :: Exp -> String
prettyExp e = pr 0 False e

pr :: Integer -> Bool-> Exp -> String
-- side == left is false side == right is true
pr upperPrec side (Binop op exp1 exp2) | (upperPrec > pGet op) = "(" ++ pr (pGet op) False exp1 ++ binToString op ++ pr (pGet op) True exp2 ++ ")"
                                       | (upperPrec == pGet op) && side = "(" ++ pr (pGet op) False exp1 ++ binToString op ++ pr (pGet op) True exp2 ++ ")"
                                       | (upperPrec == pGet op) = pr (pGet op) False exp1 ++ binToString op ++ pr (pGet op) True exp2
                                       | (upperPrec < pGet op) = pr (pGet op) False exp1 ++ binToString op ++ pr (pGet op) True exp2 --ommit parenthesis

pr upperPrec side (Uminus (Const c)) = "-(" ++ show c ++ ")"
pr upperPrec side (Uminus (Var v)) = "-"++v
pr upperPrec side (Uminus x) = "-(" ++ pr 0 False x  ++ ")"
{-
pr upperPrec side (Uminus (Uminus x)) = "-(-(" ++ pr upperPrec False x ++ "))"

pr upperPrec side (Uminus (Const c)) | (upperPrec == 10) = "(-(" ++ show c ++ "))"
                                     | otherwise = "-(" ++ show c ++ ")"

pr upperPrec side (Uminus u) | (upperPrec == 10) = "-(" ++ pr 10 side u ++ ")"
                             | otherwise = "-" ++ pr 10 side u
-}
pr upperPrec side (Var v) = v
pr upperPrec side (Const c) = show c



test_simple_com_pairs = [
  ("{}",Seq []), --- Error Maybe?
  ("{ }",Seq []),
  ("x=1",Assign "x" (Const 1)),
  ("if b then x=1 else x=2",If (Var "b") (Assign "x" (Const 1)) (Assign "x" (Const 2))),
  ("{ x=1; y=2 }",Seq [Assign "x" (Const 1),Assign "y" (Const 2)]),
  ("{ x=1 }",Seq [Assign "x" (Const 1)]),
  ("while a do {a=a-1; b=b+b}",While (Var "a") (Seq [Assign "a" (Binop Minus (Var "a") (Const 1)),Assign "b" (Binop Plus (Var "b") (Var "b"))]))
  ]
exp11 = While (Var "a") (Seq [Assign "a" (Binop Minus (Var "a") (Const 1)),Assign "b" (Binop Plus (Var "b") (Var "b"))])
exp12 = Seq [Assign "x" (Const 1)]
exp13 = Seq [Assign "x" (Const 1),Assign "y" (Const 2)]
exp14 = If (Var "b") (Assign "x" (Const 1)) (Assign "x" (Const 2))

prettyCom :: Com -> String

prettyCom (Seq []) = "{}"

prettyCom (Assign name ex) = name ++ "=" ++ prettyExp ex

prettyCom (Seq cmds) = "{" ++ prettySeq cmds ++ "}"

prettyCom (If ex cmd1 cmd2) = "if " ++ prettyExp ex ++ " then " ++ prettyCom cmd1 ++ " else " ++ prettyCom cmd2
prettyCom (While ex cmd) = "while " ++ prettyExp ex ++ " do " ++ prettyCom cmd




prettySeq :: [Com] -> String
prettySeq [] = ""
prettySeq (cmd:cmds) | cmds /= [] = prettyCom cmd ++ "; "++ prettySeq cmds
                     | otherwise = prettyCom cmd











--
