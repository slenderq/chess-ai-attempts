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


def count_pieces(current_board, turn):

    # https://en.wikipedia.org/wiki/Chess_piece_relative_value
    # TODO: This could actually be more complex
    white = 0
    black = 0

    color = chess.WHITE
    white += sum(current_board.pieces(chess.PAWN, color)) * 1
    white += sum(current_board.pieces(chess.KNIGHT, color)) * 3
    white += sum(current_board.pieces(chess.BISHOP, color)) * 3
    white += sum(current_board.pieces(chess.ROOK, color)) * 5
    white += sum(current_board.pieces(chess.QUEEN, color)) * 9

    color = chess.BLACK
    black += sum(current_board.pieces(chess.PAWN, color)) * 1
    black += sum(current_board.pieces(chess.KNIGHT, color)) * 3
    black += sum(current_board.pieces(chess.BISHOP, color)) * 3
    black += sum(current_board.pieces(chess.ROOK, color)) * 5
    black += sum(current_board.pieces(chess.QUEEN, color)) * 9

    if turn == chess.BLACK:
        differential = black - white
    else:  # chess.WHITE
        differential = white - black

    eval_number = differential * 10

    return eval_number


def min_max(
    context, board, search_depth=None, max_player=True, alpha=-math.inf, beta=math.inf
):
    if search_depth is None:
        search_depth = context.search_depth

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

    @property
    def str_elo(self):
        return f"{round(self.elo, 1)}"


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

    def __init__(self, search_depth=7):
        super().__init__()

        self.search_depth = search_depth

    def __str__(self):
        previous = super().__str__()
        return previous + " " + str(self.search_depth)

    def eval_move(self, move, current_board):
        """Get a value for the goodness of a board

        Return:
            int
        """
        current_board = current_board.copy()

        turn = current_board.turn
        eval_number = 0

        eval_number += constraint_value(current_board.gives_check(move), 1000)

        eval_number += constraint_value(current_board.is_capture(move), 1000)

        # Add some randomness
        eval_number += random.randint(-1, 1)

        current_board.push(move)

        eval_number += constraint_value(current_board.is_checkmate(), 1000)

        white = 0

        eval_number += count_pieces(current_board, turn)

        current_board.pop()
        return eval_number
