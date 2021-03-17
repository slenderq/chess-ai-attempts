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
    white += len(current_board.pieces(chess.PAWN, color)) * 1
    white += len(current_board.pieces(chess.KNIGHT, color)) * 3
    white += len(current_board.pieces(chess.BISHOP, color)) * 3
    white += len(current_board.pieces(chess.ROOK, color)) * 5
    white += len(current_board.pieces(chess.QUEEN, color)) * 9

    color = chess.BLACK
    black += len(current_board.pieces(chess.PAWN, color)) * 1
    black += len(current_board.pieces(chess.KNIGHT, color)) * 3
    black += len(current_board.pieces(chess.BISHOP, color)) * 3
    black += len(current_board.pieces(chess.ROOK, color)) * 5
    black += len(current_board.pieces(chess.QUEEN, color)) * 9

    if turn == chess.BLACK:
        differential = black - white
    else:  # chess.WHITE
        differential = white - black

    # eval_number = differential * 100

    return differential


def all_pieces(current_board, color):
    """Get all the pieces regareless of type

    Args:
        current_board (board): current_board
        color ([type]): [description]
    """

    all_types = [
        chess.PAWN,
        chess.KNIGHT,
        chess.BISHOP,
        chess.ROOK,
        chess.QUEEN,
        chess.KING,
    ]
    full_list = []
    for p_type in all_types:
        full_list += current_board.pieces(p_type, color)

    return full_list


def min_max(
    context,
    board,
    search_depth=None,
    max_player=True,
    alpha=-math.inf,
    beta=math.inf,
    save_tree=False,
    sum_children=False,
):
    if search_depth is None:
        search_depth = context.search_depth

    # TODO: Actually add ab pruning here
    processes = []
    best_move = None
    best_eval = math.inf
    if max_player:
        best_eval = best_eval * -1

    if board.is_game_over():
        return None, 0

    for move in board.legal_moves:

        board.push(move)

        if search_depth == 0 or board.is_game_over():

            # If we are at the bottom already
            node_value = context.eval_board(board)

        else:
            # spawn a new thread

            _, node_value = min_max(
                context,
                board.copy(stack=1),
                search_depth - 1,
                not max_player,
                alpha=alpha,
                beta=beta,
            )

        _ = board.pop()
        # try:
        # if sum_children:
        # node_value = context.eval_move(move, board) + level_eval
        # else:
        # node_value = context.eval_move(move, board)
        # except TypeError:
        # print(context.eval_move(move, board))
        # print(level_eval)

        if max_player:
            if best_eval < node_value:
                best_eval = node_value
                best_move = move

            if node_value > beta:
                return best_move, best_eval

            if node_value > alpha:
                alpha = node_value

        else:
            if best_eval > node_value:
                best_eval = node_value
                best_move = move

            if node_value < alpha:
                return best_move, best_eval

            if node_value < beta:
                beta = node_value

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


class TestPlayer(Player):
    """Basic player is only there to test mini-max"""

    def eval_board(self, current_board):
        pass


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

    def eval_board(self, current_board):

        # Turn is who played the last move
        last_turn = not current_board.turn

        eval_number = 0

        eval_number += count_pieces(current_board, last_turn) * 100

        eval_number += constraint_value(current_board.is_checkmate(), 1000)

        eval_number += constraint_value(current_board.is_stalemate(), -100)

        return eval_number


class BetterMinMaxPlayer(Player):
    """This player will make random moves but will always capture"""

    def __init__(self, search_depth=7):
        super().__init__()

        self.search_depth = search_depth

    def __str__(self):
        previous = super().__str__()
        return previous + " " + str(self.search_depth)

    def eval_board(self, current_board):

        # Turn is who played the last move
        last_turn = not current_board.turn

        eval_number = 0

        eval_number += count_pieces(current_board, last_turn)
        # eval_number += random.randint(-1, 1)

        eval_number += constraint_value(current_board.is_checkmate(), 1000)

        eval_number += constraint_value(current_board.is_stalemate(), -100)

        eval_number += constraint_value(current_board.is_check(), 100)

        eval_number += constraint_value(
            current_board.has_castling_rights(not last_turn), -100
        )
        # prev_board = current_board.copy(stack=1)
        # last_move = prev_board.pop()

        # eval_number += constraint_value(prev_board.has_castling_rights(last_turn), 100)
        # current_board.push(move)

        # if current_board.is_game_over():
        #     result = current_board.result()

        #     score_change = 0
        #     if result == "1-0":
        #         score_change = 1
        #     elif result == "0-1":
        #         score_change = -1

        #     if last_turn == chess.WHITE:
        #         score_change *= -1

        #     if result == "1/2-1/2":
        #         score_change = -1
        #     # Both players dislike draws

        #     eval_number += score_change * 100

        return eval_number

    def eval_move(self, move, current_board):
        """Get a value for the goodness of a board

        Return:
            int
        """
        return 0
        # current_board = current_board.copy(stack=False)

        # turn = current_board.turn
        # eval_number = 0

        # eval_number += constraint_value(current_board.gives_check(move), 100)
        # eval_number += constraint_value(current_board.is_capture(move), 100)

        # eval_number += constraint_value(current_board.is_castling(move), 50)
        # # eval_number += constraint_value(current_board.gives_check(move), 1000)

        # # Add some randomness
        # eval_number += random.randint(-1, 1)

        # our_legal_moves = len(list(current_board.legal_moves))

        # current_board.push(move)

        # if current_board.is_game_over():
        #     result = current_board.result()

        #     if result == "1-0":
        #         score_change = 1
        #     if result == "0-1":
        #         score_change = -1
        #     if result == "1/2-1/2":
        #         score_change = -0.5

        #     if turn == chess.BLACK:
        #         score_change *= -1
        #     eval_number += score_change * 100
        # their_legal_moves = len(list(current_board.legal_moves))
        # move_differentail = our_legal_moves - their_legal_moves
        # eval_number += move_differentail * 10

        # eval_number += constraint_value(current_board.is_checkmate(), 100)

        # eval_number += constraint_value(current_board.is_stalemate(), -100)

        # eval_number += count_pieces(current_board, turn)

        # # attacker detection
        # for our_piece_square in all_pieces(current_board, turn):

        #     # Check that we are not getting attacked!
        #     eval_number += constraint_value(
        #         current_board.is_attacked_by(not turn, our_piece_square), -100
        #     )

        #     # Check that we are not getting pinned!
        #     eval_number += constraint_value(
        #         current_board.is_pinned(turn, our_piece_square), -100
        #     )

        # for their_piece_square in all_pieces(current_board, not turn):

        #     # Try to attack when you can
        #     eval_number += constraint_value(
        #         current_board.is_attacked_by(turn, their_piece_square), 100
        #     )

        #     # Check that we are not getting pinned!
        #     eval_number += constraint_value(
        #         current_board.is_pinned(turn, their_piece_square), 100
        #     )

        # current_board.pop()
        # return eval_number
