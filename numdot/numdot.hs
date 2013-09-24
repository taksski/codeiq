{-
  文字列のリストを"."で結合した文字列を返す
  ["1", "2", "3"] -> "1.2.3"
-}
concatWithDot :: [String] -> String

concatWithDot [] = ""
concatWithDot [s] = s
concatWithDot (s:rs) = s ++ "." ++ (concatWithDot rs)

{-
  ["1", "2"] "3" -> [["13", "2"], ["1", "23"], ["1", "2", "3"]]
-}
extend :: [String] -> String -> [[String]]

extend [] s = [[s]]
extend [s1] s = [[s1++s], [s1,s]]
extend (s1:rs) s = ((s1++s):rs):(map (s1:) (extend rs s))

{-
  [["12"], ["1", "2"]] "3" -> [["123"], ["12", "3"], ["13", "2"], ["1", "23"], ["1", "2", "3"]]
-}
compose :: [[String]] -> String -> [[String]]

compose [] s = []
compose (ls:lrs) s = (extend ls s) ++ (compose lrs s)

{-
  文字列リストを1行ごとに出力
-}
putStrList :: [String] -> IO()

putStrList [] = putStr ""
putStrList (s:rs) = do { putStrLn s ; putStrList rs }

{-
  "1","2","3","4","5"についての解を表示
-}
main = do {
  putStrList
    (map concatWithDot
      (compose
        (compose
          (compose
            (compose
              (compose [[]] "1") "2") "3") "4") "5"));
  putStrLn "ENV: Haskell";
  putStrLn "POINT:"
}
