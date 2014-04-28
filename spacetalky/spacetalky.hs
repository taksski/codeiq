import Data.Char
import System.Environment

-- ランレングス圧縮された文字列のデコード
repeatChar :: Char -> Int -> [Char]
repeatChar _ 0 = []
repeatChar c n = [c] ++ (repeatChar c (n-1))

decode :: [Char] -> [Char]
decode [] = []
decode (_:[]) = "X"
decode (c:(l:[])) = repeatChar c len
  where
    len = (ord l) - (ord 'a') + 1
decode (c:(l:r@(rh:_)))
  | (c == rh && l /= 'z') || (rest == "X")  = "X"
  | otherwise                   = repeatChar c len ++ rest
  where
    rest = decode r
    len = (ord l) - (ord 'a') + 1
    
decodeLine :: [[Char]] -> [[Char]]
decodeLine [] = []
decodeLine (lh:lr) = [(decode lh) ++ ":" ++ lh] ++ (decodeLine lr)

main = do args <- getArgs
          file <- readFile (args !! 0)
          putStr $ unlines $ decodeLine $ words file
--          putStr "Env: Haskell+Ruby\nPOINT:\n\n"