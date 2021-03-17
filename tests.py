import unittest
import players
import chess

import multiprocessing as mp
import os

import main
from time import time


def do_something(number):
    return number ** 2


class UtilitesTest(unittest.TestCase):
    # https://www.chessvideos.tv/chess-diagram-generator.php
    def test_count_pieces(self):
        # Assuming black is up
        fen_to_count = {
            "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR": 0,
            "rnbqkbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR": 1,
            "rnb1kbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR": -8,
        }

        for fen, count in fen_to_count.items():
            with self.subTest():
                board = chess.Board(fen=fen)

                actual = players.count_pieces(board, chess.BLACK)

                self.assertEqual(actual, count)

    def test_min_max(self):

        board = chess.Board(fen="6k1/2Q5/1P3R1R/p4P1P/5p1p/1PPP1r1r/2q5/6K1")
        player = players.BasicMinMaxPlayer(search_depth=4)
        # player = players.BetterMinMaxPlayer(search_depth=2)

        move = player.get_move(board)

        with self.subTest():
            self.assertEqual(move.uci(), "c7d8")

        # with self.subTest():

    def test_min_max_perf(self):

        white = players.BasicMinMaxPlayer(search_depth=2)
        black = players.BasicMinMaxPlayer(search_depth=2)
        # black = players.BetterMinMaxPlayer(search_depth=3)
        # black = players.HumanPlayer()

        start = time()
        main.game_loop(white, black, wait=0)
        end = time()

        process_time = end - start
        self.assertLessEqual(process_time, 30)

    @unittest.skip("just want the lower test")
    def test_pool(self):

        array_of_numbers = [x for x in range(0, 100000)]
        with mp.Pool(os.cpu_count()) as p:
            print(p.map(do_something, array_of_numbers))