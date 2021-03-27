include("main.jl")

using Test
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


function run()
    # test_min_max()
    test_piece_count()
end
run()
println("Tests pass!")