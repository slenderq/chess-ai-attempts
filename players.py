import chess

import math
import random
import multiprocessing


def constraint_value(bool_chk, value):
    if bool_chk:
        return value
    return 0


def random_move(board):
    """Return a random move from the board"""

    return random.choice(list(board.legal_moves))


def min_max(
    context, board, search_depth=7, max_player=True, alpha=-math.inf, beta=math.inf
):
    # TODO: Actually add ab pruning here
    processes = []
    best_move = None
    best_eval = math.inf
    if max_player:
        best_eval = best_eval * -1

    for move in board.legal_moves:

        level_eval = 0

        if search_depth != 0:
            # board.push(move)

            # spawn a new thread
            args = (context, board.copy(), search_depth - 1, not max_player)
            multiprocessing.Process(target=min_max, args=args)

            # _ = board.pop()

        try:
            eval_value = context.eval_move(move, board) + level_eval
        except TypeError:
            print(context.eval_move(move, board))
            print(level_eval)

        if max_player:
            if best_eval < eval_value:
                best_eval = eval_value
                best_move = move
        else:
            if best_eval > eval_value:
                best_eval = eval_value
                best_move = move

    for process in processes:
        process.join()

    return best_move, best_eval


class Player:
    def __init__(self):
        self.elo = 400

    def __str__(self):
        return str(type(self).__name__)

    def get_move(self, board):
        """take input and get a move for the player"""

        move, _ = min_max(self, board)
        return move


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

        current_board.push(move)

        eval_number += constraint_value(current_board.is_checkmate(), 1000)
        # white = constraint_value(current_board.is_checkmate(), -1e9)

        # If the board is checkmate then we should
        # if current_board.turn == chess.WHITE:
        # black = constraint_value(current_board.is_checkmate(), 1e9)
        # white = constraint_value(current_board.is_checkmate(), -1e9)

        # if current_board.turn == chess.BLACK:
        # white = constraint_value(current_board.is_checkmate(), 1e9)
        # black = constraint_value(current_board.is_checkmate(), -1e9)
        current_board.pop()
        return eval_number
