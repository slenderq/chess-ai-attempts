

using Chess
# Porting this file to julia
# https://github.com/Patil-Onkar/build-your-own-chess-bot/blob/main/communication.py

function talk()

    b = startboard()
    g = Game(b)

    (errorRead, errorWrite) = redirect_stderr()
    while true
        msg = readline();

        print(">>> ")
        print(msg)
        print("\n")
        command(board, msg);


    end
    close(outWrite)

    talk()
end

function command(board, msg)
    if msg == "quit"
        exit(86)
    end

    if msg == "uci"
        println("Author Justin Quaintance")
        println("uciok")
        return
    end

    if msg == "isready"
        println("readyok")
        return
    end

    if msg == "ucinewgame"
        return 
    end

end

