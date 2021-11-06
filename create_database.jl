
using Chess
using Chess.Book

bk = createbook(
            "pgns/justin-games.pgn",
            "pgns/bot-games.pgn")
                # "pgns/638_annotated_games.pgn",
                # "pgns/Deeply_Annotated_Games.pgn",
                # "pgns/Linares_GM_Games.pgn",
                # "pgns/spassky_1805.pgn")

println("Writing Book....")
writebooktofile(bk, "personal.obk")