{- This is a rather crude implementation of Tic-tac-toe, including an
   AI that plays perfectly.
 -}

import Data.Maybe(isJust,isNothing)
import Control.Arrow(first)

{- The two players.
   X for player X, O for player O.
 -}
data Player = X | O deriving (Eq,Show)

{- opponent p
   RETURNS: p's opponent
 -}
opponent :: Player -> Player
opponent X = O
opponent O = X

type Field = Maybe Player

{- The game board.
   Board f1 ... f9 represents a board with the 9 fields f1 ... f9,
   like so:
   f1 f2 f3
   f4 f5 f6
   f7 f8 f9
 -}
data Board = Board Field Field Field
                   Field Field Field
                   Field Field Field

{- A game position.
   Position p b represents a position with board b, and player p to
   move.
 -}
data Position = Position Player Board

{- playerOf pos
   RETURNS: the player that is to move in position pos
 -}
playerOf :: Position -> Player
playerOf (Position p _) = p

type Value = Maybe Player

{- valueOf pos
   A crude evaluation function for game positions.
   RETURNS: Just p if player p has won, and Nothing otherwise
 -}
valueOf :: Position -> Value
valueOf (Position p (Board f1 f2 f3
                           f4 f5 f6
                           f7 f8 f9)) =
  let
    {- samePlayer f g h
       RETURNS: True if (and only if) fields f, g, h all belong to the
                same player
     -}
    samePlayer :: Field -> Field -> Field -> Bool
    samePlayer (Just p) (Just q) (Just r) = (p==q) && (q==r)
    samePlayer _ _ _ = False
  in
    if -- rows
       samePlayer f1 f2 f3 || samePlayer f4 f5 f6 || samePlayer f7 f8 f9 ||
       -- columns
       samePlayer f1 f4 f7 || samePlayer f2 f5 f8 || samePlayer f3 f6 f9 ||
       -- diagonals
       samePlayer f1 f5 f9 || samePlayer f3 f5 f7
      then -- the opponent made the winning move
           Just (opponent p)
      else Nothing

{- A game move.
   One represents a move to field 1, etc.
 -}
data Move = One | Two | Three | Four | Five | Six | Seven | Eight | Nine
  deriving (Show)

{- movesOf pos
   RETURNS: a list of all moves that are possible in the given
            position pos
 -}
movesOf :: Position -> [Move]
movesOf (pos @ (Position _ (Board f1 f2 f3
                                  f4 f5 f6
                                  f7 f8 f9))) =
  if isJust (valueOf pos)
    then []
    else (if isNothing f1 then [One] else []) ++
         (if isNothing f2 then [Two] else []) ++
         (if isNothing f3 then [Three] else []) ++
         (if isNothing f4 then [Four] else []) ++
         (if isNothing f5 then [Five] else []) ++
         (if isNothing f6 then [Six] else []) ++
         (if isNothing f7 then [Seven] else []) ++
         (if isNothing f8 then [Eight] else []) ++
         (if isNothing f9 then [Nine] else [])

{- makeMove pos m
   RETURNS: the position after making move m in position pos
 -}
makeMove :: Position -> Move -> Position
makeMove (Position p (Board f1 f2 f3
                            f4 f5 f6
                            f7 f8 f9)) move =
  Position (opponent p)
    (case move of
       One   -> Board (Just p) f2 f3 f4 f5 f6 f7 f8 f9
       Two   -> Board f1 (Just p) f3 f4 f5 f6 f7 f8 f9
       Three -> Board f1 f2 (Just p) f4 f5 f6 f7 f8 f9
       Four  -> Board f1 f2 f3 (Just p) f5 f6 f7 f8 f9
       Five  -> Board f1 f2 f3 f4 (Just p) f6 f7 f8 f9
       Six   -> Board f1 f2 f3 f4 f5 (Just p) f7 f8 f9
       Seven -> Board f1 f2 f3 f4 f5 f6 (Just p) f8 f9
       Eight -> Board f1 f2 f3 f4 f5 f6 f7 (Just p) f9
       Nine  -> Board f1 f2 f3 f4 f5 f6 f7 f8 (Just p))

{- compareValue x y
   Compares two values (of game positions).
   RETURNS: LT/EQ/GT based on the following order:
            Just O < Nothing < Just X
 -}
compareValue :: Value -> Value -> Ordering
compareValue x y | x==y = EQ
                 | x==Just O || y==Just X = LT
                 | otherwise = GT

{- minimax pos

   A crude version of the minimax algorithm, extended to return the
   best move (if there is one) as well as the position's value. This
   version expands the entire game tree.

   RETURNS: (Just the best move in position pos (or Nothing if there
     is no move), the value of position pos)
 -}

-- VARIANT: the height of the (fully expanded) game tree with root pos
--          (assuming that the game is finite, which is of course true
--          for tic-tac-toe)

minimax :: Position -> (Maybe Move, Value)
minimax position =
  let
    {- extremum cmp xs
       PRE: xs must be non-empty
       RETURNS: (m, v), where v is the largest (if cmp==GT) or
                smallest (if cmp==LT) game value in xs, and m is the
                corresponding move
     -}
    extremum :: Ordering -> [(Move,Value)] -> (Move, Value)
    extremum cmp =
      foldl1 (\(m1,v1) (m2,v2) ->
        if compareValue v1 v2 == cmp
          then (m1,v1)
          else (m2,v2))
    max = extremum GT
    min = extremum LT
    moves = movesOf position
  in
    if null moves
      then (Nothing, valueOf position)
      else
        let
          positions = map (makeMove position) moves
          values = map snd (map minimax positions)
        in
          first Just $
            (if playerOf position == X then max else min)
              (zip moves values)


--  ASCII output

{- showField f
   RETURNS: a string representation of the field f
 -}
showField :: Field -> String
showField Nothing = " "
showField (Just p) = show p

instance Show Board where
  show (Board f1 f2 f3 f4 f5 f6 f7 f8 f9) =
    showField f1 ++ "|" ++ showField f2 ++ "|" ++ showField f3 ++ "\n" ++
    "-----\n" ++
    showField f4 ++ "|" ++ showField f5 ++ "|" ++ showField f6 ++ "\n" ++
    "-----\n" ++
    showField f7 ++ "|" ++ showField f8 ++ "|" ++ showField f9

instance Show Position where
  show (Position p b) =
    show b ++ "\n" ++
    "Player to move: " ++ show p


{- ticTacToe pos
   RETURNS: IO ()
   SIDE EFFECTS: The minimax AI plays against itself, starting from
                 position pos. Prints all positions of the game with
                 their value and best move.
 -}
ticTacToe :: Position -> IO ()
ticTacToe position = do
  putStrLn "======================"
  print position
  if null (movesOf position)
    then case valueOf position of
      Nothing -> putStrLn "The game is a draw."
      Just p  -> putStrLn ("The winner is: " ++ show p)
    else
      let
        (Just move, value) = minimax position
      in
        do
          putStrLn ("Best move: " ++ show move)
          putStrLn ("Predicted winner: " ++ (case value of Nothing -> "draw" ; Just p -> show p))
          ticTacToe (makeMove position move)

{- The initial game position. -}
initialPosition = Position X (Board Nothing Nothing Nothing
                                    Nothing Nothing Nothing
                                    Nothing Nothing Nothing)

{- main
   SIDE EFFECTS: The minimax AI plays against itself, starting from
                 the initial game position. Prints all positions of
                 the game with their value and best move.
 -}
main :: IO ()
main = ticTacToe initialPosition
