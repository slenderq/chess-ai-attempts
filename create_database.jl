
using Chess
using Chess.Book

bk = createbook("638_annotated_games.pgn",
                "Deeply_Annotated_Games.pgn",
                "Linares_GM_Games.pgn",
                "spassky_1805.pgn")
writebooktofile(bk, "my-book.obk")