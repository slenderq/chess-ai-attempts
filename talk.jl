

using Chess
# Porting this file to julia
# https://github.com/Patil-Onkar/build-your-own-chess-bot/blob/main/communication.py

include("players.jl")
include("utils.jl")

function talk()


    b = startboard()
    g = Game(b)

    player = TimerMiniMaxPlayer(400, 1, 14)

    # (errorRead, errorWrite) = redirect_stderr()
    open("log.txt", "w") do f
        while true
            msg = readline()

            print(">>> ")

            print(msg)
            # logging
            write(f, msg)
            write(f, "\n")

            print("\n")
            b = command(b, msg, player)

            # go movetime 

        end
    end
    # close(outWrite)

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

    if msg == "print"
        crayon_print(board)

    end

    if msg == "isready"
        println("readyok")
        return board
    end

    if msg == "ucinewgame"
        return board
    end


    if startswith(msg, "position startpos")
        board = startboard()

        if msg == "position startpos"
            return board
        end

        move_string = replace(msg, "position startpos moves " => "")
        move_list = split(move_string, " ")
        for move in move_list
            move_str = string(move)
            m = movefromstring(move_str)
            board = domove(board, m)
        end
        return board
    end

    if startswith(msg,"position fen") 
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

    return board
end

if abspath(PROGRAM_FILE) == @__FILE__
    talk()
end