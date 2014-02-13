import Gemstring
import System.Environment

main = do args <- getArgs
          putStr (show $ appearance_day (args !! 0) (args !! 1))
          putStr "\nENV: Haskell\n"
          putStr "POINT:\n\n"
