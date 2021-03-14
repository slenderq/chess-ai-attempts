import chess
import os
import time
import random
from itertools import combinations, permutations
import math

# https://github.com/niklasf/python-chess


def constraint_value(bool_chk, value):
    if bool_chk:
        return value
    return 0


def key_max_val(d):
    """a) create a list of the dict's keys and values;
    b) return the key with the max value"""
    v = list(d.values())
    k = list(d.keys())
    return k[v.index(max(v))]


def key_min_val(d):
    """a) create a list of the dict's keys and values;
    b) return the key with the max value"""
    v = list(d.values())
    k = list(d.keys())
    return k[v.index(min(v))]


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
            os.system("cls" if os.name == "nt" else "clear")
            print_board(board)

        time.sleep(wait)

        old_board = board.fen()

        if board.turn == chess.WHITE:
            move = white.get_move(board)
        elif board.turn == chess.BLACK:
            move = black.get_move(board)
        else:
            raise Exception

        # Making sure no funny business is going on
        assert old_board == board.fen()

        assert move is not None
        board.push(move)

    return board.result()


class Player:
    def __init__(self):
        self.elo = 400

    def __str__(self):
        return str(type(self).__name__)


class HumanPlayer(Player):
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


class RandomPlayer(Player):
    def get_move(self, board):
        """take input and get a move for the player"""

        return random_move(board)


class CapturePlayer(Player):
    """This player will make random moves but will always capture"""

    def get_move(self, board):
        """take input and get a move for the player"""
        checking_move = [
            move for move in list(board.legal_moves) if board.gives_check(move)
        ]

        if len(checking_move) > 0:
            return random.choice(checking_move)

        capture_moves = [
            move for move in list(board.legal_moves) if board.is_capture(move)
        ]

        if len(capture_moves) > 0:
            return random.choice(capture_moves)

        return random_move(board)


class BasicMinMaxPlayer(Player):
    """This player will make random moves but will always capture"""

    def get_move(self, board):
        """take input and get a move for the player"""

        move, level_eval = self.min_max(board)
        return move

    def min_max(
        self, board, search_depth=2, max_player=True, alpha=-math.inf, beta=math.inf
    ):

        best_move = None
        best_eval = math.inf
        if max_player:
            best_eval = best_eval * -1

        for move in board.legal_moves:

            level_eval = 0

            if search_depth != 0:
                board.push(move)
                _, level_eval = self.min_max(
                    board, search_depth=search_depth - 1, max_player=not max_player
                )

                _ = board.pop()

            try:
                eval_value = self.eval_move(move, board) + level_eval
            except TypeError:
                print(self.eval_move(move, board))
                print(level_eval)

            if max_player:
                if best_eval < eval_value:
                    best_eval = eval_value
                    best_move = move
            else:
                if best_eval > eval_value:
                    best_eval = eval_value
                    best_move = move

        return best_move, best_eval

    def eval_move(self, move, current_board):
        """Get a value for the goodness of a board

        Return:
            int
        """

        eval_number = 0

        eval_number += constraint_value(current_board.gives_check(move), 1000)

        eval_number += constraint_value(current_board.is_capture(move), 1000)

        # Add some randomness
        eval_number += random.randint(-1, 1)

        return eval_number
        # white = constraint_value(current_board.is_checkmate(), -1e9)

        # If the board is checkmate then we should
        # if current_board.turn == chess.WHITE:
        # black = constraint_value(current_board.is_checkmate(), 1e9)
        # white = constraint_value(current_board.is_checkmate(), -1e9)

        # if current_board.turn == chess.BLACK:
        # white = constraint_value(current_board.is_checkmate(), 1e9)
        # black = constraint_value(current_board.is_checkmate(), -1e9)


def basic_game():

    # black = RandomPlayer()
    # white = CapturePlayer()

    white = HumanPlayer()
    black = HumanPlayer()

    result = game_loop(white, black, wait=0.01)

    if result == "1-0":
        print("White wins")
    if result == "0-1":
        print("Black wins")
    if result == "1/2-1/2":
        print("Draw")


def tournament(games_in_match=3, wait=0):
    all_players = [
        # RandomPlayer(),
        CapturePlayer(),
        BasicMinMaxPlayer(),
    ]

    bracket = list(
        combinations(all_players, r=2),
    )

    for match in bracket:
        score = [0, 0]
        # Game
        for i in range(0, games_in_match):
            print(f"Match {i + 1}")

            if random.choice([True, False]):
                white = match[0]
                black = match[1]
            else:
                white = match[1]
                black = match[0]

            # TODO: It would be nice to expose the actual games for later analysis
            result = game_loop(white, black, wait=0, printing=False)

            if result == "1-0":
                i = match.index(white)
                score[i] += 1
                print(f"{white} wins")
            if result == "0-1":
                i = match.index(black)
                score[i] += 1
                print(f"{black} wins")
            if result == "1/2-1/2":
                score[0] += 0.5
                score[1] += 0.5
                print("Draw")

            time.sleep(wait)

        os.system("cls" if os.name == "nt" else "clear")
        if score[0] == score[1]:
            print(f"draw match! {score}")
        else:
            best_score = max(score)
            best_index = score.index(best_score)
            winner = match[best_index]
            loser = match[abs(best_index - 1)]

            print(f"{winner} won the match! {score}")
            print(f"{loser} lost the match!")

        temp_elo = match[0].elo
        match[0].elo += (match[1].elo + (400 * (score[0] - score[1]))) / games_in_match
        match[1].elo += (temp_elo + (400 * (score[1] - score[0]))) / games_in_match

    sorted_list = sorted(all_players, key=lambda x: x.elo, reverse=True)

    for player in sorted_list:
        print(f"{player} ELO: {player.elo}")


if __name__ == "__main__":

    random.seed = 1
    tournament()
    # basic_game()
