include("main.jl")
include("utils.jl")
include("players.jl")
include("tables.jl")

using Test
using Chess
using Profile
using PrettyPrint

# testing that piece counting works 
function test_piece_count()
    @test countpieces(fromfen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")) == 0
    @test countpieces(fromfen("rnbqkbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR")) == -1
    @test countpieces(fromfen("rnb1kbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR")) == 8
    @test countpieces(fromfen("rnb1k1nr/pp1ppp1p/2p3p1/8/3PPB2/2NB1N2/PPP2PPP/R2QK2R b KQkq -")) == 12 
end

function test_development()
    @test development_rating(fromfen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq"), WHITE) == 0
    @test development_rating(fromfen("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1"), WHITE) == 1
    @test development_rating(fromfen("rnbqkbnr/pppppppp/8/8/4P3/8/PPPPKPPP/RNBQ1BNR w kq - 0 1"), WHITE) == 1
end

function test_time()
    # TODO: Fix this test!
    # https://discourse.julialang.org/t/break-function-on-time-limit/7376/10
    t = time()
    b = fromfen("r1bqkb1r/ppppppp1/8/4n2p/2B1P1n1/3P1N1P/PPP1QPP1/RNB1K2R b KQkq - 0 6")
    timer_time = 20.0
    println("running for $timer_time")
    p = TimerMiniMaxPlayer(400, 1, timer_time)

    new_b = makemove(p, b)
    @test timer_time ≈ (time() - t) atol = 1

end


function rapid_engie_test(player)
    rapid_engie_test(player, false)
end

function rapid_engie_test(player, debug::Bool)
    tests = rapid_engine_table    
end

function rapid_engie_test(player, tests ,debug::Bool)
    # https://www.chessprogramming.org/Eigenmann_Rapid_Engine_Test#Forum_Posts

    passed_tests::Integer = 0
    failed = []
    depth = 4
    eval_failures = true

    # Don't eval when you have a crapton of tests to do
    if length(tests) > 100
        println("Setting eval to false because we have $(lenght(tests)) tests!")
        eval_failures = false
    end
    for (index, test) in enumerate(tests)
        fen = test[1]
        board = fromfen(fen)
        answers = test[2]
        raw_answers = split(test[2], " ")
        answers = [movefromsan(board, String(x)) for x in raw_answers]
        new_b = makemove(player, board)
        move = lastmove(new_b)

        if move in answers
            passed_tests += 1
            print("✔")
        else

            if debug
                if eval_failures
                    # get the eval for the bad move
                    f_board = domove(board, move)
                    f_move, fail_eval = minimax(player, f_board, depth)

                    # get the eval for the correct move
                    s_board = domove(board, answers[1])
                    f_move, success_eval = minimax(player, s_board, depth)

                    str_mistake =  movetosan(board, move)
                    str_answer = movetosan(board, answers[1])
                else 
                    fail_eval = 0 
                    success_eval = 0
                end

                if sidetomove(board) == WHITE
                    color_str = "W"
                else
                    color_str = "B"
                end
            
                println()
                println("$index. ❌:$str_mistake $fail_eval  ✔:$str_answer $success_eval $color_str fen( $fen )")
            else
                print("❌")
            end
        end
    end
    println()
    println("Engie Test for $player: $passed_tests/$(length(tests))")
end

function test_basic_pstable()
    # Non-endgame
    @test basic_pstable(fromfen("2bqk3/8/8/2n2r1p/8/R2P4/5N2/2BQK3 w - - 0 1"), WHITE) == 62
    @test basic_pstable(fromfen("2bqk3/8/8/2n2r1p/8/R2P4/5N2/2BQK3 w - - 0 1"), BLACK) == 18 
end

function write_transition_table(player)
    f = open("trans_table.txt" ,"w")
    # TODO: maybe do this in json?
    write(f, pformat(player.trans_table))
    close(f)

end
function test_double_pawns()
    @test double_pawns(fromfen("r1bqkb1r/ppppppp1/8/7p/2B1P1n1/3P1P1P/PPP1QP2/RNB1K2R b KQkq - 0 1"), WHITE) == 1
    @test double_pawns(fromfen("r1bqkb1r/ppppppp1/8/3P3p/2BP2n1/P2P1P1P/P3QP2/RNB1K2R b KQkq - 0 1"), WHITE) == 4
end

function run()
    test_double_pawns()

    # rapid engine test. Takes ~50 min
    # @time rapid_engie_test(TimerMiniMaxPlayer(400, 1, 14), rapid_engine_table, false) # 11/111
    player = TimerMiniMaxPlayer(400, 1, 7)
    # player = TimerMiniMaxPlayer(400, 1, 0.1)

    @time rapid_engie_test(player, game_blunders, true) # 3/8
    # Write the transpotion table
    write_transition_table(player)

    test_basic_pstable()
    test_development()
    test_piece_count()
    test_time()
end

if abspath(PROGRAM_FILE) == @__FILE__
    run()
    println("Tests pass!")
end;