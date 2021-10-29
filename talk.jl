

using Chess
# Porting this file to julia
# https://github.com/Patil-Onkar/build-your-own-chess-bot/blob/main/communication.py

include("players.jl")

function talk()


    b = startboard()
    g = Game(b)

    player = TimerMiniMaxPlayer(400, 1, 14)

    (errorRead, errorWrite) = redirect_stderr()
    while true
        msg = readline();

        print(">>> ")
        print(msg)
        print("\n")
        b = command(b, msg, player);


    end
    close(outWrite)

    talk()
end

function command(board, msg, player)
    if msg == "quit"
        exit(86)
    end

    if msg == "uci"
        println("Author Justin Quaintance")
        println("uciok")
        return board
    end

    if msg == "isready"
        println("readyok")
        return board
    end

    if msg == "ucinewgame"
        return board
    end

    if "position startpos moves" in msg

    end

    if "position fen" in msg
        parts = split(msg, " ")
        fen = join(parts[2:length(parts)], " ")
        board = fromfen(fen)
        return board
    end

    if startswith(msg, "go")
        board = makemove(player, board)
        move = lastmove(board)
        print("bestmove ")
        println(tostring(move))
        return board

    end

end

