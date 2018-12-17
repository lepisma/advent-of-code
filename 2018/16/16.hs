#!/usr/bin/env stack
{- stack
    --install-ghc
    runghc
-}

import Text.ParserCombinators.ReadP
import Data.Char
import Data.Bits
import qualified Data.Set as Set
import qualified Data.Map as M


data OpCode = Addr
            | Addi | Mulr | Muli | Banr | Bani | Borr | Bori
            | Setr | Seti | Gtir | Gtri | Gtrr | Eqir | Eqri
            | Eqrr deriving (Show, Eq, Enum, Ord)

type Args = (Int, Int, Int)

-- Map of opNumber to possible opcodes
type OpMap = M.Map Int (Set.Set OpCode)

-- The instruction coming from the input
data Instruction = Instruction { opNumber :: Int
                               , args :: Args
                               } deriving (Show, Eq)

type Register = [Int]

data Sample = Sample { before :: Register
                     , after :: Register
                     , instruction :: Instruction
                     } deriving (Show)

parseInt :: ReadP Int
parseInt = read <$> many1 (satisfy isDigit)

parseInstruction :: ReadP Instruction
parseInstruction = do
  op <- parseInt
  _ <- char ' '
  a <- parseInt
  _ <- char ' '
  b <- parseInt
  _ <- char ' '
  c <- parseInt
  return Instruction {opNumber=op, args=(a, b, c)}

parseRegister :: ReadP Register
parseRegister = between (char '[') (char ']') (sepBy1 parseInt (string ", "))

parseSample :: ReadP Sample
parseSample = do
  _ <- string "Before:"
  _ <- skipSpaces
  bef <- parseRegister
  _ <- skipSpaces
  ins <- parseInstruction
  _ <- skipSpaces
  _ <- string "After:"
  _ <- skipSpaces
  aft <- parseRegister
  return Sample {before=bef, after=aft, instruction=ins}

parseManySample :: ReadP [Sample]
parseManySample = sepBy1 parseSample skipSpaces

parseProgram :: ReadP [Instruction]
parseProgram = sepBy1 parseInstruction skipSpaces

parseInput :: ReadP ([Sample], [Instruction])
parseInput = do
  samples <- parseManySample
  _ <- skipSpaces
  program <- parseProgram
  return (samples, program)

-- Operations
updateReg :: Int -> Int -> Register -> Register
updateReg idx val reg = take idx reg ++ (val:drop (idx + 1) reg)

cUpdateReg :: Int -> Bool -> Register -> Register
cUpdateReg idx True reg = updateReg idx 1 reg
cUpdateReg idx False reg = updateReg idx 0 reg

applyOp :: OpCode -> Args -> Register -> Register
applyOp Addr (a, b, c) reg = updateReg c (reg !! a + reg !! b) reg
applyOp Addi (a, b, c) reg = updateReg c (reg !! a + b) reg
applyOp Mulr (a, b, c) reg = updateReg c (reg !! a * reg !! b) reg
applyOp Muli (a, b, c) reg = updateReg c (reg !! a * b) reg
applyOp Banr (a, b, c) reg = updateReg c ((.&.) (reg !! a) (reg !! b)) reg
applyOp Bani (a, b, c) reg = updateReg c ((.&.) (reg !! a) b) reg
applyOp Borr (a, b, c) reg = updateReg c ((.|.) (reg !! a) (reg !! b)) reg
applyOp Bori (a, b, c) reg = updateReg c ((.|.) (reg !! a) b) reg
applyOp Setr (a, _, c) reg = updateReg c (reg !! a) reg
applyOp Seti (a, _, c) reg = updateReg c a reg
applyOp Gtir (a, b, c) reg = cUpdateReg c (a > reg !! b) reg
applyOp Gtri (a, b, c) reg = cUpdateReg c ((reg !! a) > b) reg
applyOp Gtrr (a, b, c) reg = cUpdateReg c ((reg !! a) > (reg !! b)) reg
applyOp Eqir (a, b, c) reg = cUpdateReg c (a == reg !! b) reg
applyOp Eqri (a, b, c) reg = cUpdateReg c ((reg !! a) == b) reg
applyOp Eqrr (a, b, c) reg = cUpdateReg c ((reg !! a) == (reg !! b)) reg

possibleOpCodes :: Sample -> [OpCode]
possibleOpCodes Sample{before=breg, after=areg, instruction=Instruction{args=a}} =
  filter (\op -> applyOp op a breg == areg) (enumFrom Addr)

sampleOpMap :: Sample -> OpMap -> OpMap
sampleOpMap sample@Sample{instruction=Instruction{opNumber=opN}} = M.insertWith Set.intersection opN opCodes
  where
    opCodes = Set.fromList $ possibleOpCodes sample

findOpMap :: [Sample] -> OpMap
findOpMap samples = disambiguateOpMap Set.empty M.empty (foldl (flip sampleOpMap) M.empty samples)
  where
    disambiguateOpMap seen accuMap opMap =
      if opMap == M.empty then accuMap
      else disambiguateOpMap newSeen (M.unionWith Set.union accuMap resolved) trimmed
      where
        (resolved, ambiguous) = M.partition (\codes -> length codes == 1) opMap
        newSeen = foldr Set.union seen (M.elems resolved)
        trimmed = M.map (`Set.difference` newSeen) ambiguous

partOne :: [Sample] -> Int
partOne samples = length $ filter (\s -> length (possibleOpCodes s) >= 3) samples

partTwo :: OpMap -> [Instruction] -> Register
partTwo opmap ins =
  partTwo' opmap ins [0, 0, 0, 0]
  where
    partTwo' _ [] reg = reg
    partTwo' opmap' (i@Instruction{opNumber=n}:is) reg =
      case M.lookup n opmap' of
        Just ops -> partTwo' opmap' is (applyOp (Set.findMin ops) (args i) reg)
        Nothing -> error "Heck!"

main :: IO ()
main = do
  text <- readFile "input.txt"
  case readP_to_S parseInput text of
    [] -> print "Parsing heck!"
    parse -> let (samples, program) = fst (last parse) in print ((partOne samples), partTwo (findOpMap samples) program)
