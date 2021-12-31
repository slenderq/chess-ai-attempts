using Profile

include("tests.jl")
include("tables.jl")

player = TimerMiniMaxPlayer(400, 1, 7)
    # player = TimerMiniMaxPlayer(400, 1, 0.1)

@profile @time rapid_engie_test(player, game_blunders, true) # 3/8

println("Writing...")
open("profile.txt", "w") do io;
    data = copy(Profile.fetch())  
    Profile.print(IOContext(io, :displaysize => (24, 500)), data)  
end;