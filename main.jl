# https://juliabyexample.helpmanual.io/#Packages-and-Including-of-Files
# https://riptutorial.com/julia-lang
using Chess
# https://romstad.github.io/Chess.jl/dev/
# https://docs.julialang.org/en/v1/manual/types/#Composite-Types-1

mutable struct RandomPlayer

    elo::Float32
    function RandomPlayer(elo)
        new(elo)
    end
end
mutable struct MiniMaxPlayer
    elo::Float32 
    depth::Integer

    function MiniMaxPlayer(elo, depth::Integer)
        new(elo, depth)
    end

end

mutable struct HumanPlayer
    elo::Float32 

    function HumanPlayer(elo)
        new(elo)
    end

end

function choice(iterable)

    n = length(iterable)

    idx = rand(1:n)

    m = iterable[idx]

    return m

end

function flip(p::PieceColor)
    if p == WHITE
        return BLACK
    else
        return WHITE
    end
end

function makemove(player::RandomPlayer, board::Board)
    mlist = []
    mlist = moves(board)
    m = choice(mlist)
  
    # println(m)

    board = domove(board, m)
    return board
    

end

function minimax(player, board::Board, search_depth::Integer)
    return minimax(player, board, search_depth, true, -Inf, Inf)
end

function minimax(player, board::Board, search_depth::Integer, maxplayer::Bool, alpha::Float64, beta::Float64)
    
    # Random move
    # m = choice(mlist)
    # Arbitry move
    best_move::Move = Move(Square(FILE_D, RANK_5), Square(FILE_D, RANK_5))
    best_eval::Float64 = Inf


    if maxplayer
        best_eval = best_eval * -1
    end

    mlist = moves(board)

    for move in mlist

        # Create a board with the new move 
        p_board = domove(board, move)
        if search_depth == 0 || !isterminal(board)
            eval = eval_board(player, p_board)
            # print(" $move:$eval ")
        else
            old_move, eval = minimax(player, p_board, search_depth-1, !maxplayer, alpha, beta)
            
            # println()
        end
    

        if maxplayer
            if best_eval < eval
                best_eval = eval
                best_move = move
            end

            if eval > beta
                return best_move, best_eval
            end

            if eval > alpha
                alpha = eval
            end

        else
            if best_eval > eval
                best_eval = eval
                best_move = move
            end

            if eval < alpha
                return best_move, best_eval
            end

            if eval < beta
                beta = eval
            end

        end
    end
    return best_move, best_eval

end

function countpieces(board::Board, forcolor::PieceColor)

    # https://en.wikipedia.org/wiki/Chess_piece_relative_value
    # TODO: This could actually be more complex
    board_fen = fen(board)

    white::Float64 = 0
    black::Float64 = 0

    # Only care about the pieces
    board_string = split(board_fen," ")[1]
    # color = chess.WHITE
    white += count(i->(i=='P'), board_string) * 1
    white += count(i->(i=='N'), board_string) * 3
    white += count(i->(i=='B'), board_string) * 3
    white += count(i->(i=='R'), board_string) * 5
    white += count(i->(i=='Q'), board_string) * 9

    # color = chess.BLACK
    black += count(i->(i=='p'), board_string) * 1
    black += count(i->(i=='n'), board_string) * 3
    black += count(i->(i=='b'), board_string) * 3
    black += count(i->(i=='r'), board_string) * 5
    black += count(i->(i=='q'), board_string) * 9

    if forcolor == BLACK
        differential = black - white
    else  # chess.WHITE
        differential = white - black
    end


    return differential

end


function development_rating(board::Board, forcolor::PieceColor)


    rating = 0


    for square in pieces(board, forcolor)
        
        if forcolor == WHITE
            if (rank(square) != RANK_1 && rank(square) != RANK_2) && pieceon(board, square) != KING
                rating = rating + 1
            end
        else
            if (rank(square) != RANK_7 && rank(square) != RANK_8) && pieceon(board, square) != KING
                rating = rating + 1
            end

        end
    
    end
    # file(square)

    return rating
end

function eval_board(player::MiniMaxPlayer, board::Board)

    forcolor = flip(sidetomove(board))

    eval::Float64 = 0
    # Basic capturing
    eval += countpieces(board, forcolor) * 100

    eval += ischeckmate(board) ? 1000 : 0

    eval += isterminal(board) ? -100 : 0

    eval += development_rating(board, forcolor) * 10

    eval += rand(-1:1)
    
    return eval
end

function makemove(player::MiniMaxPlayer, board::Board)
    move, eval = minimax(player, board, player.depth)

    board = domove(board, move)

    return board
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
function game_loop(white, black, printing::Bool)

    b = startboard()

    while !isterminal(b)
        if printing
            run(`clear`)
            print_board(b)
        end
        if sidetomove(b) == WHITE
            b = makemove(white, b)
        elseif sidetomove(b) == BLACK
            b = makemove(black, b)
        end
    end
    return b


end

function basic_game()
    white = HumanPlayer(400)
    black = MiniMaxPlayer(400, 1)

    game_loop(white, black, true)
end

tournament(games_in_match) = tournament(games_in_match, true)

function tournament(games_in_match, board_printing::Bool)

    allplayers = [MiniMaxPlayer(400, 16), MiniMaxPlayer(400, 32), MiniMaxPlayer(400, 2), RandomPlayer(100)]
    # [RandomPlayer(400), RandomPlayer(600), RandomPlayer(200), RandomPlayer(100)]
    

    if length(allplayers) % 2 == 1
        throw(InvalidStateException("must have even players"))
    end

    braket_history = []
    current_braket = allplayers
    while length(current_braket) > 1
        matches = []
        
        i = 1
        while i < length(current_braket)
            push!(matches,[current_braket[i], current_braket[i + 1]])
            i += 2
        end
        # for i in 1:(length(current_braket) - 1)

            # if i % 2 == 0
            # end
        # end

        next_braket = []
        println("Matches $matches")
        for match in matches
            score = [0.0, 0.0]
            
            println(" Match: $match  ")
            for game_number in 1:games_in_match

                if choice([true, false])
                    white = match[1]
                    black = match[2]
                else
                    white = match[2]
                    black = match[1]
                end

                println("   Game: $white $black ")
                b = game_loop(white, black, board_printing)

                draw = false
                if ischeckmate(b)
                    winner_color = flip(sidetomove(b))

                    if winner_color == WHITE
                        winner = white
                    else
                        winner = black
                    end
                    player_id = findfirst(isequal(winner), match)
                    score[player_id] += 1
                    # println("$winner wins game")
                else
                    score[1] += 0.5
                    score[2] += 0.5
                    # println("Draw Game")
                end

                


            end

            if score[1] == score[2] 
                if match[1].elo > match[2].elo
                    winner_id = 1
                elseif match[1].elo < match[2].elo
                    winner_id = 2
                else
                    # just let 1 one win
                    winner_id = 1
                end
            else
                # Someone one the match, find them
                max = findmax(score)
                max_value = max[1]
                winner_id = findfirst(isequal(max_value), score)
            end

            match_winner = match[winner_id]
            println(" $match_winner wins match - $score")
            if winner_id == 1
                match_loser = match[2]
            else
                match_loser = match[1]
            end

            temp_elo = match[1].elo
            match[1].elo += (
                match[1].elo + (400 * (score[1] - score[2]))
            ) / games_in_match
            match[2].elo += (temp_elo +
                             (400 * (score[2] - score[1]))) / games_in_match

            push!(next_braket, match_winner)

        push!(braket_history, matches)
        current_braket = next_braket

        end

    # println(braket_history)
    end

    tournament_winner = current_braket[1]
    println("$tournament_winner wins the tournament")
    println(allplayers)
end

function main()

    tournament(13, false)
    # basic_game()
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end