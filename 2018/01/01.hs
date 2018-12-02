#!/usr/bin/env stack
{- stack
    --install-ghc
    runghc
-}

import Text.Read
import Data.Maybe
import Data.Set

strToNum :: String -> Maybe Int
strToNum ('+':ss) = readMaybe ss
strToNum s = readMaybe s

p1 :: [Int] -> Int
p1 = sum

p2 :: [Int] -> Set Int -> Int -> Int
p2 [] _ _ = -1 -- Some error case, unreachable though
p2 (x:xs) set freq =
  if member newFreq set then newFreq
  else p2 xs (insert newFreq set) newFreq
  where
    newFreq = x + freq

main :: IO ()
main = do
  text <- readFile "input.txt"
  let nums = mapMaybe strToNum $ lines text
  print $ p1 nums
  print $ p2 (cycle nums) empty 0
