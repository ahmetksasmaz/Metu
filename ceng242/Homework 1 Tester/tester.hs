module Tester where

import Hw1

-- Ahmet Kürşad Şaşmaz --
-- Metu Haskell Homework 1 Tester --

-- First Version Information --
-- Begin : 12.03.2019 --
-- End : 12.03.2019 --

-- Function of test writeExpression --

testwriteExpression :: [((AST, Mapping),String)] -> [String]
testwriteExpression s = [ let x = (writeExpression (fst (fst k) , snd (fst k))) in if x == (snd k)
                            then "Sample "++show(i)++" is true."
                            else "Sample "++show(i)++" is false. \n"++"-->Your answer is : \n   "++x++"\n-->True answer is : \n   "++(snd k)
                            | (k,i) <- zip s [(1::Int)..]]

-- Function of test evaluateAST --

testevaluateAST :: [((AST, Mapping),(AST, String))] -> [String]
testevaluateAST s = [ let x = (evaluateAST (fst (fst k) , snd (fst k))) in if (show(fst x),(snd x)) == (show(fst (snd k)),(snd (snd k)))
                        then "Sample "++show(i)++" is true."
                        else "Sample "++show(i)++" is false. \n"++"-->Your answer is : \n   "++show((show(fst x),(snd x)))++"\n-->True answer is : \n   "++show(show(fst (snd k)),(snd (snd k)))
                        | (k,i) <- zip s [(1::Int)..]]

-- Main test function

test =  let x = testwriteExpression [(((ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST), []),"3"),
                        (((ASTNode "x" EmptyAST EmptyAST), [("x", "num", "17")]),"let x=17 in x"),
                        (((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), []),"(3+5)"),
                        (((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST) EmptyAST)), []),"(3+(-5))"),
                        (((ASTNode "times" (ASTNode "num" (ASTNode "7" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), []),"(7*5)"),
                        (((ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)), []),"(\"CENG\"++\"242\")"),
                        (((ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST), []),"(length (\"CENG\"++\"242\"))"),
                        (((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "2" EmptyAST EmptyAST) EmptyAST) EmptyAST)), [("x", "num", "9")]),"let x=9 in (x+(-2))"),
                        (((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "y" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9"), ("y", "num", "19")]),"let x=9;y=19 in (x+(-y))"),
                        (((ASTNode "times" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "x" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9")]),"let x=9 in (x*(-x))"),
                        (((ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "department" EmptyAST EmptyAST) (ASTNode "course_code" EmptyAST EmptyAST)) EmptyAST) EmptyAST), [("department", "str", "CENG"), ("course_code", "str", "242")]),"let department=\"CENG\";course_code=\"242\" in (-(length (department++course_code)))"),
                        (((ASTNode "times" (ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST) (ASTNode "plus" (ASTNode "num" (ASTNode "8" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "14" EmptyAST EmptyAST) EmptyAST))), []),"((-(length (\"CENG\"++\"242\")))*(8+14))"),
                        (((ASTNode "times" (ASTNode "times" (ASTNode "len" (ASTNode "a" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "13" EmptyAST EmptyAST) EmptyAST))  (ASTNode "plus" (ASTNode "plus" (ASTNode "b" EmptyAST EmptyAST) (ASTNode "c" EmptyAST EmptyAST)) (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST ))) , [("a", "str", "Lewis"), ("b", "num", "7"), ("c", "num", "3")] ),"let a=\"Lewis\";b=7;c=3 in (((length a)*13)*((b+c)+9))"),
                        (((ASTNode "plus" (ASTNode "times" (ASTNode "len" (ASTNode "a" EmptyAST EmptyAST) EmptyAST) (ASTNode "c" EmptyAST EmptyAST))  (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "tree" EmptyAST EmptyAST) EmptyAST) (ASTNode "d" EmptyAST EmptyAST)) EmptyAST )         ), [("a", "str", "lucky"), ("c", "num", "15"), ("d", "str", "band")]),"let a=\"lucky\";c=15;d=\"band\" in (((length a)*c)+(length (\"tree\"++d)))"),
                        (((ASTNode "cat" (ASTNode "cat" (ASTNode "a" EmptyAST EmptyAST) (ASTNode "str" (ASTNode " thing" EmptyAST EmptyAST) EmptyAST)) (ASTNode "cat" (ASTNode "b" EmptyAST EmptyAST) (ASTNode "c" EmptyAST EmptyAST)  )), [("a", "str", "old"), ("b", "str", " ba"), ("c", "str", "ck")] ),"let a=\"old\";b=\" ba\";c=\"ck\" in ((a++\" thing\")++(b++c))"),
                        (((ASTNode "plus" (ASTNode "plus" (ASTNode "a" EmptyAST EmptyAST) (ASTNode "a" EmptyAST EmptyAST)) (ASTNode "a" EmptyAST EmptyAST)), [("a", "num", "3")]),"let a=3 in ((a+a)+a)")
                        ];
            y = testevaluateAST [(((ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST), []),(ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST,"3")),
                    (((ASTNode "x" EmptyAST EmptyAST), [("x", "num", "17")]),(ASTNode "num" (ASTNode "17" EmptyAST EmptyAST) EmptyAST,"17")),
                    (((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), []),(ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST),"8")),
                    (((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST) EmptyAST)), []),(ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST) EmptyAST),"-2")),
                    (((ASTNode "times" (ASTNode "num" (ASTNode "7" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), []),(ASTNode "times" (ASTNode "num" (ASTNode "7" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST),"35")),
                    (((ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)), []),(ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST),"CENG242")),
                    (((ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST), []),(ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST,"7")),
                    (((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "2" EmptyAST EmptyAST) EmptyAST) EmptyAST)), [("x", "num", "9")]),(ASTNode "plus" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "2" EmptyAST EmptyAST) EmptyAST) EmptyAST),"7")),
                    (((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "y" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9"), ("y", "num", "19")]),(ASTNode "plus" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "19" EmptyAST EmptyAST) EmptyAST) EmptyAST),"-10")),
                    (((ASTNode "times" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "x" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9")]),(ASTNode "times" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) EmptyAST),"-81")),
                    (((ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "department" EmptyAST EmptyAST) (ASTNode "course_code" EmptyAST EmptyAST)) EmptyAST) EmptyAST), [("department", "str", "CENG"), ("course_code", "str", "242")]),(ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST,"-7")),
                    (((ASTNode "times" (ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST) (ASTNode "plus" (ASTNode "num" (ASTNode "8" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "14" EmptyAST EmptyAST) EmptyAST))), []),(ASTNode "times" (ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST) (ASTNode "plus" (ASTNode "num" (ASTNode "8" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "14" EmptyAST EmptyAST) EmptyAST)),"-154")),
                    (((ASTNode "times" (ASTNode "times" (ASTNode "len" (ASTNode "a" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "13" EmptyAST EmptyAST) EmptyAST))  (ASTNode "plus" (ASTNode "plus" (ASTNode "b" EmptyAST EmptyAST) (ASTNode "c" EmptyAST EmptyAST)) (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST ))) , [("a", "str", "Lewis"), ("b", "num", "7"), ("c", "num", "3")] ),(ASTNode "times" (ASTNode "times" (ASTNode "len" (ASTNode "str" (ASTNode "Lewis" EmptyAST EmptyAST) EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "13" EmptyAST EmptyAST) EmptyAST)) (ASTNode "plus" (ASTNode "plus" (ASTNode "num" (ASTNode "7" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST)) (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST)),"1235")),
                    (((ASTNode "plus" (ASTNode "times" (ASTNode "len" (ASTNode "a" EmptyAST EmptyAST) EmptyAST) (ASTNode "c" EmptyAST EmptyAST))  (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "tree" EmptyAST EmptyAST) EmptyAST) (ASTNode "d" EmptyAST EmptyAST)) EmptyAST )         ), [("a", "str", "lucky"), ("c", "num", "15"), ("d", "str", "band")]),(ASTNode "plus" (ASTNode "times" (ASTNode "len" (ASTNode "str" (ASTNode "lucky" EmptyAST EmptyAST) EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "15" EmptyAST EmptyAST) EmptyAST)) (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "tree" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "band" EmptyAST EmptyAST) EmptyAST)) EmptyAST),"83")),
                    (((ASTNode "cat" (ASTNode "cat" (ASTNode "a" EmptyAST EmptyAST) (ASTNode "str" (ASTNode " thing" EmptyAST EmptyAST) EmptyAST)) (ASTNode "cat" (ASTNode "b" EmptyAST EmptyAST) (ASTNode "c" EmptyAST EmptyAST)  )), [("a", "str", "old"), ("b", "str", " ba"), ("c", "str", "ck")] ),(ASTNode "cat" (ASTNode "cat" (ASTNode "str" (ASTNode "old" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode " thing" EmptyAST EmptyAST) EmptyAST)) (ASTNode "cat" (ASTNode "str" (ASTNode " ba" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "ck" EmptyAST EmptyAST) EmptyAST)),"old thing back")),
                    (((ASTNode "plus" (ASTNode "plus" (ASTNode "a" EmptyAST EmptyAST) (ASTNode "a" EmptyAST EmptyAST)) (ASTNode "a" EmptyAST EmptyAST)), [("a", "num", "3")]),(ASTNode "plus" (ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST)) (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST),"9"))
                    ]
        in do
            putStrLn "---Testing Write Expression---"
            mapM_ putStrLn x
            putStrLn "---Testing Evaluate AST---"
            mapM_ putStrLn y
