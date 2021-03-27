# https://juliabyexample.helpmanual.io/#Packages-and-Including-of-Files
# https://riptutorial.com/julia-lang
using Chess
# https://romstad.github.io/Chess.jl/dev/
# https://docs.julialang.org/en/v1/manual/types/#Composite-Types-1

using ArgParse

include("utils.jl")
include("players.jl")

function gameover(b::Board)
    return isstalemate(b) || ischeckmate(b)

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

    allplayers = [MiniMaxPlayer(400, 16), MiniMaxPlayer(400, 32), MiniMaxPlayer(400, 2), RandomPlayer(100),
                    BetterMiniMaxPlayer(400, 3), BetterMiniMaxPlayer(400, 16), ]
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
    # println("$tournament_winner wins the tournament")
    rankings = sort(allplayers,by = x -> x.elo, rev=true)
    for i in 1:length(rankings)
        if i == 1
            print(" 👑 ")
        else
            print("    ")
        end
        println(rankings[i])
    
    end
end


if abspath(PROGRAM_FILE) == @__FILE__

    s = ArgParseSettings()
    @add_arg_table! s begin
        "--tournament"
            help = "run a tournament will all the ai"
            action = :store_true
        "--play"
            help = "play the ai"
            action = :store_true
    end
    parsed_args = parse_args(ARGS, s)
    if parsed_args["tournament"]
        tournament(13, false)
    end
    if parsed_args["play"]
        basic_game()
    end
end