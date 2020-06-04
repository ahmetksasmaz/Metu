module Tester where

import Hw2

-- Ahmet Kürşad Şaşmaz --
-- Metu Haskell Homework 2 Tester --

-- Test isNumber --

testisNumber :: [(String,Bool)] -> [String]
testisNumber s = [ let x = isNumber (fst k) in if x == (snd k)
                            then "Sample "++show(i)++" is true."
                            else "Sample "++show(i)++" is false. \n"++"-->Your answer is : \n   "++(show x)++"\n-->True answer is : \n   "++(show (snd k))
                            | (k,i) <- zip s [(1::Int)..]]

-- Test eagerEvaluation --

testeagerEvaluation :: [(AST,ASTResult)] -> [String]
testeagerEvaluation s = [ let x = eagerEvaluation (fst k) in if (show x) == (show (snd k))
                            then "Sample "++show(i)++" is true."
                            else "Sample "++show(i)++" is false. \n"++"-->Your answer is : \n   "++(show x)++"\n-->True answer is : \n   "++(show (snd k))
                            | (k,i) <- zip s [(1::Int)..]]

-- Test normalEvaluation --

testnormalEvaluation :: [(AST,ASTResult)] -> [String]
testnormalEvaluation s = [ let x = normalEvaluation (fst k) in if (show x) == (show (snd k))
                            then "Sample "++show(i)++" is true."
                            else "Sample "++show(i)++" is false. \n"++"-->Your answer is : \n   "++(show x)++"\n-->True answer is : \n   "++(show (snd k))
                            | (k,i) <- zip s [(1::Int)..]]

-- Main test function

test =  let x = testisNumber [
								("",False),
								("123",True),
								("abc",False),
								("123a456",False),
								("-123",True),
								("123-",False),
								("123.4",False)
								];
		    y = testeagerEvaluation [
		    							--eager vs normal--
		    							((ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "4") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST))) , ASTJust ("14","num",2)),
		    							((ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "2") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "4") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST)))) , ASTJust ("8","num",2)),
		    							((ASTNode (ASTLetDatum "x") ((ASTNode (ASTSimpleDatum "negate") (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "1") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "2") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTSimpleDatum "len") (ASTNode (ASTSimpleDatum "cat") (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "CE") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "NG") EmptyAST EmptyAST) EmptyAST)) EmptyAST)) EmptyAST)) (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST)))) , ASTJust ("288","num",7)),
		    							-- errorHandling --
		    							((ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "") EmptyAST EmptyAST) EmptyAST) , ASTError "the value '' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) , ASTJust ("123","num",0)),
		    							((ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "abc") EmptyAST EmptyAST) EmptyAST) , ASTError "the value 'abc' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123a456") EmptyAST EmptyAST) EmptyAST) , ASTError "the value '123a456' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "abc") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST)) , ASTError "the value 'abc' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123a456") EmptyAST EmptyAST) EmptyAST)) , ASTError "the value '123a456' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "456") EmptyAST EmptyAST) EmptyAST)) , ASTError "plus operation is not defined between str and num!"),
		    							((ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "456") EmptyAST EmptyAST) EmptyAST)) , ASTError "plus operation is not defined between num and str!"),
		    							((ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "456") EmptyAST EmptyAST) EmptyAST)) , ASTError "plus operation is not defined between str and str!"),
		    							((ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "456") EmptyAST EmptyAST) EmptyAST)) , ASTJust ("579","num",1)),
		    							((ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "CENG242") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "test") EmptyAST EmptyAST) EmptyAST)) , ASTError "the value 'CENG242' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "456") EmptyAST EmptyAST) EmptyAST)) , ASTError "times operation is not defined between num and str!"),
		    							((ASTNode (ASTSimpleDatum "cat") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "456") EmptyAST EmptyAST) EmptyAST)) , ASTError "cat operation is not defined between num and str!"),
		    							((ASTNode (ASTSimpleDatum "len") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) EmptyAST) , ASTError "len operation is not defined on num!"),
		    							((ASTNode (ASTSimpleDatum "len") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123x") EmptyAST EmptyAST) EmptyAST) EmptyAST) , ASTError "the value '123x' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "len") (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "123x") EmptyAST EmptyAST) EmptyAST) EmptyAST) , ASTJust ("4","num",1)),
		    							((ASTNode (ASTSimpleDatum "negate") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST) EmptyAST) , ASTJust ("-123","num",1)),
		    							((ASTNode (ASTSimpleDatum "negate") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123x") EmptyAST EmptyAST) EmptyAST) EmptyAST) , ASTError "the value '123x' is not a number!"),
		    							((ASTNode (ASTSimpleDatum "negate") (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "123x") EmptyAST EmptyAST) EmptyAST) EmptyAST) , ASTError "negate operation is not defined on str!"),
		    							((ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "4") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "5") EmptyAST EmptyAST) EmptyAST)) , ASTJust ("12","num",2))
		    							];
		    z = testnormalEvaluation [
		    							--eager vs normal--
		    							((ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "4") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST))) , ASTJust ("14","num",3)),
		    							((ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "2") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "4") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST)))) , ASTJust ("8","num",1)),
		    							((ASTNode (ASTLetDatum "x") ((ASTNode (ASTSimpleDatum "negate") (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "1") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "2") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTSimpleDatum "len") (ASTNode (ASTSimpleDatum "cat") (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "CE") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "NG") EmptyAST EmptyAST) EmptyAST)) EmptyAST)) EmptyAST)) (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST)))) , ASTJust ("288","num",17))
		    							]
        in do
            putStrLn "---Testing isNumber---"
            mapM_ putStrLn x
            putStrLn "---Testing eagerEvaluation---"
            mapM_ putStrLn y
            putStrLn "---Testing normalEvaluation---"
            mapM_ putStrLn z