import chess
import os
import time
import random
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

    board_string = board_string.replace(".", "□")
    # board_string = board_string.replace(".", "∷")

    # Add coords for ease of use
    board_list = board_string.split("\n")
    i = 8
    new_board_list = []

    letter_row = "   a b c d e f g h"
    new_board_list.append(letter_row)

    for row in board_list:
        new_row = f"{i}  {row}  {i}"
        new_board_list.append(new_row)
        i -= 1

    new_board_list.append(letter_row)

    board_string = "\n".join(new_board_list)

    print(board_string)


def random_move(board):
    """Return a random move from the board"""

    return random.choice(list(board.legal_moves))


def game_loop(white, black, wait=0):
    """Main game loop for the game

    Args:
        white (Player): The white player
        black (Player): The black player
    """

    board = chess.Board()

    while not board.is_game_over():
        os.system('cls' if os.name == 'nt' else 'clear')
        print_board(board)

        time.sleep(wait)

        if board.turn == chess.WHITE:
            move = white.get_move(board)
        elif board.turn == chess.BLACK:
            move = black.get_move(board)
        else:
            raise Exception
        board.push(move)

    print(board.result())


class HumanPlayer:
    def get_move(self, board):
        """take input and get a move for the player"""
        error = False
        move = None

        while move is None:

            if error:
                prefix = "❌"
            elif board.turn == chess.WHITE:
                prefix = "♙"
            elif board.turn == chess.BLACK:
                prefix = "♟"
            input_string = f"{prefix} Please Enter a move \n"

            move_san = input(input_string)
            try:
                move = board.parse_san(move_san)
            except ValueError:
                error = True

        return move


class RandomPlayer:
    def get_move(self, board):
        """take input and get a move for the player"""

        return random_move(board)


class GreedyPlayer:
    """This player will make random moves but will always capture"""

    def get_move(self, board):
        """take input and get a move for the player"""
        capture_moves = [move for move in list(
            board.legal_moves) if board.is_capture(move)]

        if len(capture_moves) > 0:
            return random.choice(capture_moves)

        return random_move(board)


if __name__ == '__main__':

    black = RandomPlayer()
    white = GreedyPlayer()

    # white = HumanPlayer()
    # black = HumanPlayer()

    game_loop(white, black, wait=0.1)
