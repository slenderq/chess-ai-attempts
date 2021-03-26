# https://juliabyexample.helpmanual.io/#Packages-and-Including-of-Files

using Chess
# https://romstad.github.io/Chess.jl/dev/
println("Hello!")

# struct BasicPlayer

# end
# struct HumanPlayer
    # player::BasicPlayer

# end

function print_board(g)
    board_string = string(board(g))

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

    g = Game()
    print_board(g)


end

game_loop()