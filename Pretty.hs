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


prettyExp :: Exp -> String
prettyExp e = ""   -- replace this line by your solution


prettyCom :: Com -> String

prettyCom c = ""   -- replace this line by your solution
