import chess
#https://github.com/pychess/pychess 

# import chess.svg
# board = chess.Board("8/8/8/8/4N3/8/8/8 w - - 0 1")
# squares = board.attacks(chess.E4)
# image = chess.svg.board(board, squares=squares, size=350) 
# print(image)

import hichess
from PySide2.QtWidgets import QApplication
import sys

if __name__ == "__main__":
    app = QApplication(sys.argv)
    boardWidget = hichess.BoardWidget()
    boardWidget.show()
    sys.exit(app.exec_())