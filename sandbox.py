import chess
import os
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

def game_loop(board):
    while True:
        move = input("Please Enter a move \n")
        try:
            board.push_san(move)
        except ValueError:
            print("Please enter a valid move")
            continue

        os.system('cls' if os.name == 'nt' else 'clear')

        print_board(board)

board = chess.Board() 

game_loop(board)