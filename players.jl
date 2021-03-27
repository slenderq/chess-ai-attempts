
using Chess

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

function makemove(player::RandomPlayer, board::Board)
    mlist = []
    mlist = moves(board)
    m = choice(mlist)
  
    # println(m)

    board = domove(board, m)
    return board
    

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