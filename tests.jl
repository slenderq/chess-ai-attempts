include("main.jl")

include("utils.jl")
include("players.jl")

using Test
using Chess
# testing that piece counting works 
function test_piece_count()
    @test countpieces(fromfen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"), BLACK) == 0
    @test countpieces(fromfen("rnbqkbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR"), BLACK) == 1
    @test countpieces(fromfen("rnb1kbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR"), BLACK) == -8
end

function test_min_max()
    # Test that minimax finds this move
    b = fromfen("6k1/2Q5/1P3R1R/p4P1P/5p1p/1PPP1r1r/2q5/6K1")
    p = MiniMaxPlayer(400, 8)
    new_b = makemove(p, b)
    move = lastmove(new_b)
    @test tostring(move) == "c7f7"

end

function test_min_max_fail()

    b = fromfen("r7/5k2/1p3ppn/p2p4/Pn3PP1/KP5P/1RR5/q7 w - -")
    bb =fromfen("r7/5k2/1p3ppn/p2p4/P4PP1/KP5P/R1n5/q7 w - - 0 2")
    p = MiniMaxPlayer(400, 2)
    # println(isterminal(bb))
    # println(ischeckmate(bb))
    new_b = makemove(p, b)
end

function test_development()
    @test development_rating(fromfen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq"), WHITE) == 0
    @test development_rating(fromfen("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1"), WHITE) == 1
    @test development_rating(fromfen("rnbqkbnr/pppppppp/8/8/4P3/8/PPPPKPPP/RNBQ1BNR w kq - 0 1"), WHITE) == 1

end

function run()
    # test_min_max()
    test_min_max_fail()
    test_development()
    test_piece_count()
end
run()
println("Tests pass!")