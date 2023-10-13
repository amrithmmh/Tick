# Functional Programming 1 - 1DL330
# Individual Assignment: An Artificial Intelligence for Ultimate Tic-Tac-Toe

Introduction
------------

Your task for this assignment is to implement an AI player for the game
"Ultimate Tic-Tac-Toe" in Haskell.

This is an individual assignment. It is acceptable to discuss abstract solution
methods with others, and to get inspiration from the Internet or other sources,
provided

- you give proper credit (via an explicit comment in your sources) whenever you
  use someone else's ideas, and

- you have constructed your submission yourself. It is not acceptable to share
  or copy source code.

See the course's [Ethics Rules](https://uppsala.instructure.com/courses/86377/pages/ethics-rules)
for further guidelines.

Game Rules
----------

Ultimate tic-tac-toe is a board game for two players. We will call the players
X and O.

The game is played on nine individual tic-tac-toe boards arranged in a 3-by-3
grid. Each field of a small board is either empty, marked X, or marked O.

We will number the small boards from 1 to 9, from top left to bottom right:

![The small boards are numbered from 1 to 9.](images/board.svg)

Moreover, on each small board, we will number the fields from 1 to 9, again
from top left to bottom right:

![The fields on each board are numbered from 1 to 9.](images/fields.svg)

Initially, all 81 fields are empty. Players take alternate turns. X moves first.

A move consists of choosing a small board b (1 ≤ b ≤ 9) and an empty field f
(1 ≤ f ≤ 9) on that board. The field is marked with the name of the current
player. Once three fields in a (horizontal, vertical or diagonal) row on a small
board have been marked with the same name, the board is marked as won by that
player (just like in regular tic-tac-toe).

On all moves but the first, the current player must play on the small board
indicated by the relative location of the field that the opponent chose for
their previous move. For instance, if player X chose to mark field 3 (on some
small board), on the following move player O must play (on some empty field) on
board 3.

As an exception from this rule, if a player would have to play on a small board
that is marked as won or that does not have any empty fields, that player must
choose any other board (that is not marked as won and that has an empty field)
instead.

The game ends when either player has won three small boards in a (horizontal,
vertical or diagonal) row. This player wins the game of ultimate tic-tac-toe.
Altenatively, the game ends when there are no legal moves remaining (i.e., all
small boards have been filled or marked as won); in this case, the game is a
draw.

See <https://en.wikipedia.org/wiki/Ultimate_tic-tac-toe> for diagrams and
further explanations.

Your Task
---------

Your task is to write a single file called `UltimateTicTacToeAI.hs` that
declares a module `UltimateTicTacToeAI`.

Your module `UltimateTicTacToeAI` must import the `UltimateTicTacToe` module.
This exports types `Player` and `Move` (with their constructors) that have been
defined as follows:

```haskell
{- The two players: X and O.
 -}
data Player = X | O

{- Game moves.
   Move b f represents a move on board b, field f.
   INVARIANT: 1 ≤ b ≤ 9 and 1 ≤ f ≤ 9.
 -}
data Move = Move Int Int
```

Do not define these types yourself!

Your module `UltimateTicTacToeAI` must export the following types, values, and
functions:

```haskell
type State  -- the internal state of your AI
author :: String
nickname :: String
initial :: UltimateTicTacToe.Player -> State
think :: State -> Maybe UltimateTicTacToe.Move -> Double -> (UltimateTicTacToe.Move, State)
```

These are specified as follows:

- `State` encodes the internal state of your AI, i.e., any information that your
  AI wants to keep track of between different invocations of `think`. (This
  information will likely include a representation of the board and current
  player.) Your module may define `State` any way you see fit.

- `author` is your (first and last) name.

- `nickname` is an arbitrary string (of at most 20 ASCII characters) chosen by
  you to identify your AI. It will be used to report the
  [evaluation](#evaluation) results pseudonymously.

- `initial` takes an argument that indicates whether your AI will be playing X
  or O, and returns the initial state of your AI.

- `think` takes three arguments: the current state of your AI, your opponent's
  last move, and the time remaining for your AI (in seconds) to play the rest of
  the game.

  The `move` argument will be `Nothing` when your AI is playing X and making the
  first move of the game.

  `think` returns a pair `(m,s)`, where `m` is the move that your AI wants to
  take, and `s` is your AI's internal state after taking this move. (`s` will be
  passed to the *next* invocation of your AI's think function, along with your
  opponent's response to `m`.)

Near the top of your file must be a comment containing a brief (about 100-500
words) description of your implementation. All functions must be specified
according to our [Coding Convention](https://uppsala.instructure.com/courses/86377/pages/coding-convention).

Your file must compile with GHC, and pass the [automated test](#testing) on
GitHub.

Your implementation must not perform any kind of input or output (e.g., via the
console, file system or network) or any other side effects. Your implementation
must not raise any exceptions.

Your implementation must not spawn additional threads or processes.

Your implementation may use any types and values provided by the Prelude, or by
other Haskell packages that are available in the test environment, with the
exception of [unsafe](https://wiki.haskell.org/Unsafe_functions) functions. Your
implementation must not require the installation of additional packages.

Testing
-------

For your convenience, we provide an automated testing framework. When you push
to your GitHub repository, your AI plays *one* game against a computer
player—called `RandomAI`—that makes pseudo-random moves. Whether your AI plays
as player X or O during this test is determined (pseudo-)randomly.

You are encouraged to develop your own test harness if you want to test your AI
more thoroughly.

Submission
----------

Please submit your file `UltimateTicTacToeAI.hs` simply by pushing to your
GitHub repository. (In case of technical problems—and only then!—email your
solution to <tjark.weber@it.uu.se>.) The submission deadline is **Friday,
2023-10-20 at 18:00**. (Late submissions are accepted in accordance with the
completion deadlines that have been announced on Studium.)

Evaluation
----------

Your AI will compete against a very simple computer player (`RandomAI`) that
chooses its moves (pseudo-)randomly. Each AI will play 20 games: 10 as player X
and 10 as player O.

For each game, your AI will receive a score of +1 if it won the game, 0 if the
game was a draw, and -1 if it lost the game. Your AI's total score is defined as
the sum of its game scores.

Your AI will be given 5 minutes per game. The time it takes to call your AI's
`initial` function is counted against this limit. If your AI returns an invalid
move or runs out of time, it will receive a score of -1 for that game. All games
will be played on reasonably recent hardware.

If your AI causes stability issues due to excessive memory requirements during a
game, we may treat this similar to a timeout. (We do not expect memory usage to
be an issue in practice, and will not actively monitor it unless problems
arise.)

Grading
-------

Grading for this assignment will be according to the [grading rubric](https://uppsala.instructure.com/courses/86377/assignments/210002)
that is published on Studium:

If your implementation conforms to the requirements stated [above](#your-task),
passes the [automated test](#testing) <i>and</i> follows the [Coding Convention](https://uppsala.instructure.com/courses/86377/pages/coding-convention),
your assignment grade will be (at least) 3.

If your implementation additionally is functionally correct and returns no
invalid move during <i>any</i> of the evaluation games, your assignment grade
will be (at least) 4.

If your implementation additionally achieves a total evaluation score of 18 or
more, your assignment grade will be 5.

With this grading scheme, you can *decide for yourself* whether you merely want
to implement the rules of the game, or whether you want to implement a
(moderately) strong AI—and hence, which grade you want to aim for.

Tournament
----------

We will conduct a tournament between all AIs that were submitted by the
deadline. Every student AI will play against every other student AI, once as
player X and once as player O. The tournament rules (e.g., timing, scoring) are
as detailed for the [evaluation](#evaluation).

We will report the tournament results on Studium, using your AI's nickname to
identify it. These results may bestow bragging rights, but they will not affect
the grading.

Hints
-----

**For grades 3 and 4:**

To attain a grade of 4, it is sufficient to return *any* valid move. This merely
requires you to implement the rules of the game. It can be done without game
tree search (and without an evaluation function for game positions).

Your implementation of `think` may ignore the argument that indicates the
remaining time.

The board can be represented in many different ways. An 81-tuple of fields is
one (but probably not the most convenient) possible solution. Consider using
lists or [sequences](https://hackage.haskell.org/package/containers-0.6.5.1/docs/Data-Sequence.html)
instead.

For grade 3, it is sufficient to play a single game correctly. For grade 4, test
your code thoroughly before you submit.

**For grade 5:**

Two key components in a strong AI for Ultimate Tic-Tac-Toe are (i) the search
algorithm, and (ii) the evaluation function.

Do not try to reinvent the wheel. Instead, research existing techniques. A good
starting point is <https://boardgames.stackexchange.com/questions/49291/strategy-for-ultimate-tic-tac-toe>.
Remember to give credit when you use someone else's ideas.

Test your code thoroughly before you submit. Buggy code may easily be worse than
no code.

If you are aiming for a very strong AI, make sure it doesn't run out of time.
The evaluation hardware may be slower (or faster) than the testing hardware.

Do not go overboard. We understand that one could spend a lifetime perfecting an
AI for Ultimate Tic-Tac-Toe, while you only have a few days.
