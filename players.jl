using Chess
using Memoize
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

    function TimerMiniMaxPlayer(elo, startdepth::Integer, processtime::Union{Integer,Float64})
        new(elo, startdepth, processtime)
    end
end

mutable struct HumanPlayer
    elo::Float32 

    function HumanPlayer(elo)
        new(elo)
    end

end

@memoize function eval_board(player::BetterMiniMaxPlayer, board::Board)

    forcolor = flip(sidetomove(board))
    eval::Float64 = 0

    eval += countpieces(board, forcolor) * 1000
    eval += ischeck(board) ? 100 : 0
    eval += ischeckmate(board) ? 1000 : 0
    eval += isterminal(board) ? -100 : 0
    eval += development_rating(board, forcolor) * 100
    eval += rand(-1:1)
    
    return eval
end



# @memoize function eval_board(player::Union{MiniMaxPlayer,TimerMiniMaxPlayer}, board::Board)
function eval_board(player::Union{MiniMaxPlayer,TimerMiniMaxPlayer}, board::Board)

    forcolor = flip(sidetomove(board))
    eval::Float64 = 0

    eval += countpieces(board, forcolor) * 100
    eval += ischeckmate(board) ? 1000 : 0
    eval += isterminal(board) ? -100 : 0
    # eval += rand(-1:1)
    
    return eval
end

#  Make moves

function makemove(player::TimerMiniMaxPlayer, board::Board)
    
    starttime = time()
    depth = player.startdepth
    
    move::Move = Move(Square(FILE_D, RANK_5), Square(FILE_D, RANK_5))
    eval::Float64 = 0
    found_move = false

    while time() - starttime < player.processtime

        # println("depth $depth")

        # not using the generic because I don't know julia
        # https://discourse.julialang.org/t/break-function-on-time-limit/7376/7
        t = @async minimax(player, board, depth)

        while time() - starttime < player.processtime
            sleep(0.1)
            # println("waiting... $(time() - starttime)")
            if istaskdone(t)
                move, eval = fetch(t)
                found_move = true
                break
            end
        end

        sleep(0.1)
        depth += 1
    end
    # end
    if !found_move
        mlist = moves(board)
        m = choice(mlist)
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
    m = choice(mlist)
  
    # println(m)
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
            move = readline()
            board = domove(board, move)
    error = false

        catch 
            print("❌ ")
        end
    end

    return board
end