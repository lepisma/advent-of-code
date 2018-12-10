#!/usr/bin/env stack
{- stack
    --install-ghc runghc
    --package regex-compat
-}

import qualified Data.Sequence as S
import qualified Data.Map.Strict as M
import Text.Regex
import Text.Read
import Data.Maybe

type Score = M.Map Int Int
type Marbles = S.Seq Int

insertIndex :: Int -> Marbles -> Int
insertIndex cIdx marbles =
  let iIdx = cIdx + 2
      len = S.length marbles in
    if iIdx > len
    then iIdx `mod` len
    else iIdx

removeIndex :: Int -> Marbles -> Int
removeIndex cIdx marbles =
  let len = S.length marbles in
    (cIdx - 7 + len) `mod` len

loop :: Int -> Int -> Score -> Score
loop maxMarbles nPlayers =
  loop' 2 (S.fromList [0, 1]) 0
  where
    loop' :: Int -> Marbles -> Int -> Score -> Score
    loop' it marbles cIdx scores
      | it == maxMarbles + 1 = scores
      | it `mod` 23 == 0 =
          let rIdx = removeIndex cIdx marbles
              !rVal = marbles `S.index` rIdx
              newScores = M.adjust (rVal + it +) (it `mod` nPlayers) scores in
            loop' (it + 1) (S.deleteAt rIdx marbles) rIdx newScores
      | otherwise =
        let iIdx = insertIndex cIdx marbles in
          loop' (it + 1) (S.insertAt iIdx it marbles) iIdx scores

main :: IO ()
main = do
  text <- readFile "input.txt"
  case matchRegex (mkRegex "([0-9]+) players; last marble is worth ([0-9]+) points") text of
    Just nums ->
      let [nPlayers, maxMarbles] = mapMaybe (readMaybe::String -> Maybe Int) nums
          scores = M.fromList $ zip (take nPlayers [0..]) (repeat 0) in do
        print $ maximum $ M.elems (loop maxMarbles nPlayers scores)
        print $ maximum $ M.elems (loop (100 * maxMarbles) nPlayers scores)
    _ -> print "Error in reading input"
