using Chess
using Chess.Book
using Memoize

struct trans_table_value
    best_move::Move
    best_eval::Float64
    maxplayer::Bool
    time::Int64
    depth::Int
    function trans_table_value(best_move::Move, best_eval::Float64, maxplayer::Bool, depth::Int)
        new(best_move, best_eval, maxplayer, time_ns(), depth)
    end
end

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
mutable struct BetterMiniMaxPlayer
    elo::Float32 
    depth::Integer

    function BetterMiniMaxPlayer(elo, depth::Integer)
        new(elo, depth)
    end
end

mutable struct TimerMiniMaxPlayer
    elo::Float32 
    startdepth::Integer
    processtime::Union{Integer,Float64}
    trans_table::Dict
    max_depth_seen::Int
    max_size::Int

    function TimerMiniMaxPlayer(elo, startdepth::Integer, processtime::Union{Integer,Float64})
        new(elo, startdepth, processtime, Dict(), -1, 5000)
    end
end
Base.show(io::IO, player::TimerMiniMaxPlayer) = println("$(typeof(player)) elo: $(player.elo) processtime: $(player.processtime) max_depth_seen $(player.max_depth_seen)")

mutable struct HumanPlayer
    elo::Float32 

    function HumanPlayer(elo)
        new(elo)
    end

end

@memoize function eval_board(player::BetterMiniMaxPlayer, board::Board)

    forcolor = WHITE # flipcolor(sidetomove(board))
    eval::Float64 = 0

    eval += countpieces(board, forcolor) * 100
    eval += ischeckmate(board) ? 1000 : 0
    eval += isterminal(board) ? -100 : 0
    # eval += development_rating(board, forcolor) * 100
    # eval += rand(-1:1)
    
    return eval
end

# @memoize function eval_board(player::Union{MiniMaxPlayer,TimerMiniMaxPlayer}, board::Board)
function eval_board(player::Union{MiniMaxPlayer,TimerMiniMaxPlayer}, board::Board)
    # NOTE: from WHITE's perspective


    # https://romstad.github.io/Chess.jl/stable/api/#Chess.movecount
    # Add movecount

    forcolor = flipcolor(sidetomove(board))
    eval::Float64 = 0

    eval += countpieces(board, forcolor) * 10000
    if ischeckmate(board)
        if forcolor == BLACK
            # white is checkmated
            eval -= 2^20
        else
            eval += 2^20
        end
    end
    eval += ischeckmate(board) ? 2^20 : 0

    if forcolor == BLACK
        eval += isterminal(board) && !ischeckmate(board) ? -2^16 : 0
    else
        eval += isterminal(board) && !ischeckmate(board) ? 2^16 : 0
    end

    eval += basic_pstable(board, WHITE) 
    eval -= basic_pstable(board, BLACK) 
    
    # making sure this is always from whites perspective
    if forcolor == BLACK
        eval += movecount(board) * 100
    else
        eval -= movecount(board) * 100
    end

    # punish for white double pawns
    eval -= double_pawns(board, WHITE) * 5000
    # benefit for doubling the other players pawns
    eval += double_pawns(board, BLACK) * 5000
    
    return eval
end

#  Make moves

function makemove(player::TimerMiniMaxPlayer, board::Board)
    
    starttime = time()
    depth = player.startdepth
    
    # move::Move = Move(Square(FILE_D, RANK_5), Square(FILE_D, RANK_5))
    eval::Float64 = 0
    found_move = false

    
    # Openings
    move = pickbookmove(board, "my-book.obk")
    
    if move === nothing

        while time() - starttime < player.processtime


            # not using the generic because I don't know julia
            # https://discourse.julialang.org/t/break-function-on-time-limit/7376/7
            if !found_move
                t = @async minimax(player, board, depth)
            else
                t = @async minimax(player, board, depth, move)
            end

            while time() - starttime < player.processtime
                sleep(0.1)
                # println("waiting... $(time() - starttime)")
                if istaskdone(t)

                    # println("depth $depth")
                    move, eval = fetch(t)
                    found_move = true
                    break
                end
            end
            
            sleep(0.1)
        depth += 1

        if depth > player.max_depth_seen
            player.max_depth_seen = depth
        end
        # println("$move $(fen(board))")
        end
    end
    # end
    if !found_move
        mlist = moves(board)
        move = choice(mlist)
    end

    try
        board = domove(board, move)
    catch err
        println(board)
        println(move)
        throw(err)
    end

    return board
    end



function makemove(player::RandomPlayer, board::Board)
    mlist = []
    mlist = moves(board)
    # m = choice(mlist)
  
    println(m)
    board = domove(board, m)
    return board
end

function makemove(player, board::Board)
    move, eval = minimax(player, board, player.depth)
    try
        board = domove(board, move)
    catch err
        println(board)
        println(move)
        throw(err)
    end
    return board
    end

function makemove(player::HumanPlayer, board::Board)
    error = true

    move = Nothing
    while error
        try
            if sidetomove(board) == WHITE
                print("??? > ")
            else
                print("??? > ")
            end
            move = readline()
            board = domove(board, move)
            error = false
        catch e
            if isa(e, InterruptException)
                throw(e)
            end

            print("??? ")
        end
    end

    return board
end