# https://juliabyexample.helpmanual.io/#Packages-and-Including-of-Files
# https://riptutorial.com/julia-lang
using Chess
# https://romstad.github.io/Chess.jl/dev/
# https://docs.julialang.org/en/v1/manual/types/#Composite-Types-1
println("Hello!")

# struct BasicPlayer

# end
struct HumanPlayer
    # player::BasicPlayer

end

function makemove(player::HumanPlayer, board::Board)
    error = true

    move = Nothing
    while error
        try
            move = readline()
            board = domove(board, move)
            error=false

        catch 
            print("❌ ")
        end
    end

    return board
end

function gameover(b::Board)
    return isstalemate(b) || ischeckmate(b)

end
function print_board(b::Board)
    board_string = string(b)

    board_string = replace(board_string,"r" => "♜")

    board_string = replace(board_string, "n"=> "♞")
    board_string = replace(board_string, "b"=> "♝")
    board_string = replace(board_string, "q"=> "♛")
    board_string = replace(board_string, "k"=> "♚")
    board_string = replace(board_string, "p"=> "♟")

    board_string = replace(board_string, "R"=> "♖")
    board_string = replace(board_string, "N"=> "♘")
    board_string = replace(board_string, "B"=> "♗")
    board_string = replace(board_string, "Q"=> "♕")
    board_string = replace(board_string, "K"=> "♔")
    board_string = replace(board_string, "P"=> "♙")

    board_string = replace(board_string, "-"=> "□")

    board_list = split(board_string, "\n")

    letter_row = "   a  b  c  d  e  f  g  h"
    new_board_list = []

    push!(new_board_list, letter_row)

    i = 8
    for row in board_list[2:length(board_list)]
        new_row = string(i, " ",row, " ", i)

        push!(new_board_list, new_row)

        i -= 1
    end

    push!(new_board_list, letter_row)
    board_string = join(new_board_list, "\n")
    
    println(board_string)
end
function game_loop()

    b = startboard()

    player = HumanPlayer()
    while !gameover(b)
        run(`clear`)
        print_board(b)

        b = makemove(player, b)
    end


end

game_loop()