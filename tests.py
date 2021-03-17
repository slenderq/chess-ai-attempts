import unittest
import players
import chess


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