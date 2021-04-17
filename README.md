# Chess AI attempts
## What is this?
This is a Alpha-Beta chess engine that I built in julia.

Using [this](https://romstad.github.io/Chess.jl/dev/) chess board
 library I created a simple chess engine

Currently the engine can look 8 moves deep and beats me often.

## How to Run


- Install packages
    ```
    # requires julia >= 1.6
    julia install.jl
    ```
- Build Opening Book
    ```
    julia create_database.jl
    ```
- Play the AI
    ```
    julia main.jl --play
    ```
- Run tests 
    ```
    julia tests.jl
    ```
- Run tournament
    ```
    julia main.jl --tournament
    ```

## Why?
Seemed like an interesting project as I was getting more interested in chess.

I was also interested in leaning more julia,
so this project was a way to explore the language.

## Project Structure
```
├── README.md
├── create_database.jl # Create Opening Database
├── games # Record of past games played
│   ├── game-1.61809640822917e9.txt
│   ├── game-1.618204917349792e9.pgn
│   ├── game-1.61826017230973e9.pgn
│   ├── game-1.618353692533573e9.pgn
│   ├── game-1.618450741813242e9.pgn
│   └── game-queen-blunder.pgn
├── install.jl # package installs
├── main.jl # game loop and cli interface
├── old_python # old python port of the project
│   ├── main.py
│   ├── players.py
│   └── tests.py
├── pgns # opening book pgns
│   ├── 638_annotated_games.pgn
│   ├── Deeply_Annotated_Games.pgn
│   ├── Linares_GM_Games.pgn
│   ├── kasparov_1798.pgn
│   └── spassky_1805.pgn
├── players.jl # AI and Human Players
├── tables.jl # Useful Tables
├── tests.jl # Unit tests
└── utils.jl # Algorithms
```

## Future Improvements
* Actually use [Zobrist Hashing](https://www.chessprogramming.org/Zobrist_Hashing) in the hash table 

* Improve opening performance by making the algorithm attack the center

* Fix checkmating blunders in the tests

## Resources
List of links that I used to  make this.
- https://www.chessprogramming.org/Main_Page
- https://lichess.org/team/lichess-elite-database
-  https://juliadocs.github.io/Julia-Cheat-Sheet/
-  https://docs.julialang.org/en/v1/manual/types/#Composite-Types-1
- https://riptutorial.com/julia-lang
- https://juliabyexample.helpmanual.io/#Packages-and-Including-of-Files
- https://romstad.github.io/Chess.jl/dev/
https://lichess.org/editor
-  https://int8.io/chess-position-evaluation-with-convolutional-neural-networks-in-julia/
- https://chesstempo.com/pgn-viewer/