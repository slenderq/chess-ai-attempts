import chess
import os
import time
import random
from itertools import combinations, permutations
import math

import players

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


def basic_game():

    # black = RandomPlayer()
    # white = CapturePlayer()

    white = players.HumanPlayer()
    black = players.HumanPlayer()

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
        players.CapturePlayer(),
        players.BasicMinMaxPlayer(),
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

    random.seed(1)
    tournament()
    # basic_game()
