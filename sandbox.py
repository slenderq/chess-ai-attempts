import chess
# https://github.com/niklasf/python-chess
def print_board(board):
    board_string = board.__str__()

    board_string = board_string.replace("r", "♜")
    board_string = board_string.replace("n", "♞")
    board_string = board_string.replace("b", "♝")
    board_string = board_string.replace("q", "♛")
    board_string = board_string.replace("k", "♚")
    board_string = board_string.replace("p", "♟")

    board_string = board_string.replace("R", "♖")
    board_string = board_string.replace("N", "♘")
    board_string = board_string.replace("B", "♗")
    board_string = board_string.replace("Q", "♕")
    board_string = board_string.replace("K", "♔")
    board_string = board_string.replace("P", "♙")
    print(board_string)



board = chess.Board() 
board.push_san("e4")
print_board(board)
