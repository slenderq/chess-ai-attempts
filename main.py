import chess
import os
import time
import random
from itertools import combinations, permutations
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


def game_loop(white, black, wait=0, printing=True):
    """Main game loop for the game

    Args:
        white (Player): The white player
        black (Player): The black player
    """

    board = chess.Board()

    while not board.is_game_over():
        if printing:
            os.system('cls' if os.name == 'nt' else 'clear')
            print_board(board)

        time.sleep(wait)

        if board.turn == chess.WHITE:
            move = white.get_move(board.copy())
        elif board.turn == chess.BLACK:
            move = black.get_move(board.copy())
        else:
            raise Exception
        board.push(move)

    return board.result()


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
    elo = 400

    def get_move(self, board):
        """take input and get a move for the player"""

        return random_move(board)


class CapturePlayer:
    elo = 400
    """This player will make random moves but will always capture"""

    def get_move(self, board):
        """take input and get a move for the player"""
        capture_moves = [move for move in list(
            board.legal_moves) if board.is_capture(move)]

        if len(capture_moves) > 0:
            return random.choice(capture_moves)

        return random_move(board)


def basic_game():

    black = RandomPlayer()
    white = CapturePlayer()

    # white = HumanPlayer()
    # black = HumanPlayer()

    result = game_loop(white, black, wait=0.01)

    if result == "1-0":
        print("White wins")
    if result == "0-1":
        print("Black wins")
    if result == "1/2-1/2":
        print("Draw")


def tournament(games_in_match=4):
    all_players = [RandomPlayer(),
                   CapturePlayer()]

    bracket = list(combinations(all_players, r=2),)

    for match in bracket:
        score = []
        # Game
        for i in range(0, games_in_match):
            if random.choice([True, False]):
                white = match[0]
                black = match[1]
            else:
                white = match[1]
                black = match[0]

            print(i)

    print(bracket)


if __name__ == '__main__':

    tournament()
    # basic_game()
