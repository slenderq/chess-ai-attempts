
using Chess
using Memoize

include("tables.jl")


time_from_now(seconds) = round(Int, 10^9 * seconds + time_ns())

function print_board(b::Board)
    board_string = string(b)

    fen_string = split(board_string, "\n")[1]

    board_string = replace(board_string, "r" => "♜")
    board_string = replace(board_string, "n" => "♞")
    board_string = replace(board_string, "b" => "♝")
    board_string = replace(board_string, "q" => "♛")
    board_string = replace(board_string, "k" => "♚")
    board_string = replace(board_string, "p" => "♟")

    board_string = replace(board_string, "R" => "♖")
    board_string = replace(board_string, "N" => "♘")
    board_string = replace(board_string, "B" => "♗")
    board_string = replace(board_string, "Q" => "♕")
    board_string = replace(board_string, "K" => "♔")
    board_string = replace(board_string, "P" => "♙")

    board_string = replace(board_string, "-" => "□")

    board_list = split(board_string, "\n")
    letter_row = "   a  b  c  d  e  f  g  h"
    new_board_list = []

    push!(new_board_list, letter_row)

    i = 8
    for row in board_list[2:length(board_list)]
        new_row = string(i, " ", row, " ", i)

        push!(new_board_list, new_row)

        i -= 1
    end

    push!(new_board_list, letter_row)
    board_string = join(new_board_list, "\n")
    
    println(board_string)
    println(fen_string)
end

function choice(iterable)

    n = length(iterable)

    idx = rand(1:n)

    m = iterable[idx]

    return m

end

function flipcolor(p::PieceColor)
    if p == WHITE
        return BLACK
    else
        return WHITE
    end
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

    return rating
end

function countpieces(board::Board, forcolor::PieceColor)

    # https://en.wikipedia.org/wiki/Chess_piece_relative_value
    # TODO: This could actually be more complex
    board_fen = fen(board)

    white::Float64 = 0
    black::Float64 = 0

    # Only care about the pieces
    board_string = split(board_fen, " ")[1]
    # color = chess.WHITE
    white += count(i -> (i == 'P'), board_string) * 1
    white += count(i -> (i == 'N'), board_string) * 3
    white += count(i -> (i == 'B'), board_string) * 3
    white += count(i -> (i == 'R'), board_string) * 5
    white += count(i -> (i == 'Q'), board_string) * 9

    # color = chess.BLACK
    black += count(i -> (i == 'p'), board_string) * 1
    black += count(i -> (i == 'n'), board_string) * 3
    black += count(i -> (i == 'b'), board_string) * 3
    black += count(i -> (i == 'r'), board_string) * 5
    black += count(i -> (i == 'q'), board_string) * 9

    # if forcolor == BLACK
        # differential = black - white
    # else  # chess.WHITE
        # differential = white - black
    # end

    # always from whites perspective
    differential = white - black
    return differential

end
function check_trans_entry(board::Board, player, search_depth::Int)
    return check_trans_entry(board::Board, player, search_depth::Int, false)
end
function check_trans_entry(board::Board, player, search_depth::Int, debug::Bool)
    # If we are using a player with a trans_table
    if hasproperty(player, :trans_table)

        # board, player
        # only compress the board if there 
        # compressed_board = compress(board)
        compressed_board = fen(board)
        # Check we have a entry in the trans_table
        if haskey(player.trans_table, compressed_board)
            # We have evaluated this position before!
            past_run = player.trans_table[compressed_board]
        
            # TODO: only use this if needed
            if past_run.depth >= search_depth
                if debug
                    print("💰")
                end

                return past_run.best_move, past_run.best_eval
            elseif debug
                print("$(past_run.depth) < $(search_depth)")
                
            end
        end
    end

    return ()


end

function save_trans_entry(board::Board, player, best_move::Move, best_eval::Float64, maxplayer::Bool, search_depth::Int)
    # Cache this run
    if hasproperty(player, :trans_table)
        if search_depth >= 0
            # compressed_board = compress(board)
            compressed_board = fen(board)
            player.trans_table[compressed_board] = trans_table_value(best_move, best_eval, maxplayer, search_depth)
        end
    end
end

function minimax(player, board::Board, search_depth::Integer)
    if sidetomove(board) == WHITE
        return minimax(player, board, search_depth, true, -Inf, Inf, missing, 0)
    else
        return minimax(player, board, search_depth, false, -Inf, Inf, missing, 0)
    end
end

function minimax(player, board::Board, search_depth::Integer, last_best::Union{Missing, Move})
    if sidetomove(board) == WHITE
        return minimax(player, board, search_depth, true, -Inf, Inf, last_best, 0)
    else
        return minimax(player, board, search_depth, false, -Inf, Inf, last_best, 0)
    end
end

function minimax(player, board::Board, search_depth::Integer, maxplayer::Bool, alpha::Float64, beta::Float64, ply::Int)
    return minimax(player, board::Board, search_depth::Integer, maxplayer::Bool, alpha::Float64, beta::Float64, missing, ply)
end

function minimax(player, board::Board, search_depth::Integer, maxplayer::Bool, alpha::Float64, beta::Float64, last_best::Union{Missing, Move}, ply::Int)

    # In case this needs to be interupped
    # make sure that there is a change for another function to run.
    if rand(1:100) == 1 
        sleep(0.0000000000000000000000000000000001)
    end

    table_rst = check_trans_entry(board, player, search_depth)
    if table_rst != ()
        return table_rst
    end

    # Arbitry move
    best_move::Move = Move(Square(FILE_D, RANK_5), Square(FILE_D, RANK_5))
    best_eval::Float64 = Inf

    if maxplayer
        best_eval = best_eval * -1
    end

    mlist = Array(moves(board))

    # Use the best move first
    if !(last_best === missing)
        # Priotize the move that we last found
        idx = findfirst(m -> m == last_best, mlist)
        if idx != nothing
            temp = mlist[1]
            mlist[1] = mlist[idx]
            mlist[idx] = temp
        end
    end

    for move in mlist
        # Create a board with the new move 
        p_board = domove(board, move)
        if search_depth == 0 || isterminal(p_board)
            eval = eval_board(player, p_board)
            # Delay Penalty
            # bonus for quick checkmates
            if ischeckmate(p_board)
                eval = eval / (ply +1)
            end
        else
            old_move, eval = minimax(player, p_board, search_depth - 1, !maxplayer, alpha, beta, ply+1)
        end
    
        if maxplayer
            if eval > best_eval
                best_eval = eval
                best_move = move
            end

            if eval > alpha
                alpha = eval
            end

            if eval > beta
                return best_move, best_eval
            end
        else
            if  eval <  best_eval
                best_eval = eval
                best_move = move
            end

            if eval < beta
                beta = eval
            end

            if eval < alpha
                return best_move, best_eval
            end
        end
    end

    save_trans_entry(board, player, best_move, best_eval, maxplayer, search_depth)
    
    return best_move, best_eval
end

function is_endgame(board::Board) 
    white = 0
    black = 0

    board_fen = fen(board)
    board_string = split(board_fen, " ")[1]

    white += count(i -> (i == 'Q'), board_string) 
    black += count(i -> (i == 'q'), board_string) 

    if white == 0 && black == 0
        return true
    elseif white == 1 && black == 1
        return false
    end

    white = 0
    black = 0

    black += count(i -> (i == 'n'), board_string) 
    black += count(i -> (i == 'b'), board_string) 
    black += count(i -> (i == 'r'), board_string)
    white += count(i -> (i == 'N'), board_string) 
    white += count(i -> (i == 'B'), board_string) 
    white += count(i -> (i == 'R'), board_string)

    if black <= 1 && white <= 1 
        return true
    end
    return false
end

function basic_pstable(b::Board, forcolor::PieceColor)
    # https://www.chessprogramming.org/PeSTO%27s_Evaluation_Function
    
    if forcolor == BLACK
        board = flip(b)
    else
        board = b
    end
    
    table = []
    table_eval::Integer = 0
    for square in pieces(board, forcolor)
        rank_item = rank(square)
        file_item = file(square)

        piece_type = ptype(pieceon(board, square))
        table = nothing
        if is_endgame(board)
            table = piece_type == PAWN ? eg_pawn_table : table
            table = piece_type == KNIGHT ? eg_knight_table : table
            table = piece_type == BISHOP ? eg_bishop_table : table
            table = piece_type == ROOK ? eg_rook_table : table
            table = piece_type == QUEEN ? eg_queen_table : table
            table = piece_type == KING ? eg_king_table : table
        else
            table = piece_type == PAWN ? mg_pawn_table : table
            table = piece_type == KNIGHT ? mg_knight_table : table
            table = piece_type == BISHOP ? mg_bishop_table : table
            table = piece_type == ROOK ? mg_rook_table : table
            table = piece_type == QUEEN ? mg_queen_table : table
            table = piece_type == KING ? mg_king_table : table
        end

        table_eval = table[ranktonum(rank_item), filetonum(file_item)]
    end
    return table_eval
end

function double_pawns(board::Board, forcolor::PieceColor)
    # https://romstad.github.io/Chess.jl/dev/api/#Chess.pieceon
    total_pawns = 0
    total_double = 0
    files = [SS_FILE_A, SS_FILE_B, SS_FILE_C, SS_FILE_D, SS_FILE_E, SS_FILE_F, SS_FILE_H]
    for file in files
        # -1 because its fine to have a single pawn
        double_pawns = 0 
        for square in file
            piece = pieceon(board, square)
            if  ptype(piece) == PAWN && pcolor(piece) == forcolor
                total_pawns += 1
                double_pawns += 1
            end
        end
        if double_pawns > 1
            total_double += (double_pawns - 1)
        end
    end
    return total_double
end
    