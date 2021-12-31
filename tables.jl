
using Chess

function ranktonum(r)
    if r == RANK_1 
        return 1
    elseif r == RANK_2
        return 2
    elseif r == RANK_3
        return 3
    elseif r == RANK_4
        return 4
    elseif r == RANK_5
        return 5
    elseif r == RANK_6
        return 6
    elseif r == RANK_7
        return 7
    elseif r == RANK_8
        return 8
    end
end

function filetonum(f) 
    if f == FILE_A
        return 1
    elseif f == FILE_B
        return 2
    elseif f == FILE_C
        return 3
    elseif f == FILE_D
        return 4
    elseif f == FILE_E
        return 5
    elseif f == FILE_F
        return 6
    elseif f == FILE_G
        return 7
    elseif f == FILE_H
        return 8
    end

end

mg_pawn_table = [
    0   0   0   0   0   0  0   0;
    98 134  61  95  68 126 34 -11;
    -6   7  26  31  65  56 25 -20;
    -14  13   6  21  23  12 17 -23;
    -27  -2  -5  12  17   6 10 -25;
    -26  -4  -4 -10   3   3 33 -12;
    -35  -1 -20 -23 -15  24 38 -22;
    0   0   0   0   0   0  0   0
]

eg_pawn_table = [
    0   0   0   0   0   0   0   0;
    178 173 158 134 147 132 165 187;
    94 100  85  67  56  53  82  84;
    32  24  13   5  -2   4  17  17;
    13   9  -3  -7  -7  -8   3  -1;
    4   7  -6   1   0  -5  -1  -8;
    13   8   8  10  13   0   2  -7;
    0   0   0   0   0   0   0   0
]

mg_knight_table = [
    -167 -89 -34 -49  61 -97 -15 -107;
    -73 -41  72  36  23  62   7  -17;
    -47  60  37  65  84 129  73   44;
    -9  17  19  53  37  69  18   22;
    -13   4  16  13  28  19  21   -8;
    -23  -9  12  10  19  17  25  -16;
    -29 -53 -12  -3  -1  18 -14  -19;
    -105 -21 -58 -33 -17 -28 -19  -23
]

eg_knight_table = [
    -58 -38 -13 -28 -31 -27 -63 -99;
    -25  -8 -25  -2  -9 -25 -24 -52;
    -24 -20  10   9  -1  -9 -19 -41;
    -17   3  22  22  22  11   8 -18;
    -18  -6  16  25  16  17   4 -18;
    -23  -3  -1  15  10  -3 -20 -22;
    -42 -20 -10  -5  -2 -20 -23 -44;
    -29 -51 -23 -15 -22 -18 -50 -64
]

mg_bishop_table = [
    -29   4 -82 -37 -25 -42   7  -8;
    -26  16 -18 -13  30  59  18 -47;
    -16  37  43  40  35  50  37  -2;
    -4   5  19  50  37  37   7  -2;
    -6  13  13  26  34  12  10   4;
    0  15  15  15  14  27  18  10;
    4  15  16   0   7  21  33   1;
    -33  -3 -14 -21 -13 -12 -39 -21
]

eg_bishop_table = [
    -14 -21 -11  -8 -7  -9 -17 -24;
    -8  -4   7 -12 -3 -13  -4 -14;
    2  -8   0  -1 -2   6   0   4;
    -3   9  12   9 14  10   3   2;
    -6   3  13  19  7  10  -3  -9;
    -12  -3   8  10 13   3  -7 -15;
    -14 -18  -7  -1  4  -9 -15 -27;
    -23  -9 -23  -5 -9 -16  -5 -17
]

mg_rook_table = [
    32  42  32  51 63  9  31  43;
    27  32  58  62 80 67  26  44;
    -5  19  26  36 17 45  61  16;
    -24 -11   7  26 24 35  -8 -20;
    -36 -26 -12  -1  9 -7   6 -23;
    -45 -25 -16 -17  3  0  -5 -33;
    -44 -16 -20  -9 -1 11  -6 -71;
    -19 -13   1  17 16  7 -37 -26
]

eg_rook_table = [
    13 10 18 15 12  12   8   5;
    11 13 13 11 -3   3   8   3;
    7  7  7  5  4  -3  -5  -3;
    4  3 13  1  2   1  -1   2;
    3  5  8  4 -5  -6  -8 -11;
    -4  0 -5 -1 -7 -12  -8 -16;
    -6 -6  0  2 -9  -9 -11  -3;
    -9  2  3 -1 -5 -13   4 -20
]

mg_queen_table = [
    -28   0  29  12  59  44  43  45;
    -24 -39  -5   1 -16  57  28  54;
    -13 -17   7   8  29  56  47  57;
    -27 -27 -16 -16  -1  17  -2   1;
    -9 -26  -9 -10  -2  -4   3  -3;
    -14   2 -11  -2  -5   2  14   5;
    -35  -8  11   2   8  15  -3   1;
    -1 -18  -9  10 -15 -25 -31 -50
]

eg_queen_table = [
    -9  22  22  27  27  19  10  20;
    -17  20  32  41  58  25  30   0;
    -20   6   9  49  47  35  19   9;
    3  22  24  45  57  40  57  36;
    -18  28  19  47  31  34  39  23;
    -16 -27  15   6   9  17  10   5;
    -22 -23 -30 -16 -16 -23 -36 -32;
    -33 -28 -22 -43  -5 -32 -20 -41
]

mg_king_table = [
    -65  23  16 -15 -56 -34   2  13;
    29  -1 -20  -7  -8  -4 -38 -29;
    -9  24   2 -16 -20   6  22 -22;
    -17 -20 -12 -27 -30 -25 -14 -36;
    -49  -1 -27 -39 -46 -44 -33 -51;
    -14 -14 -22 -46 -44 -30 -15 -27;
    1   7  -8 -64 -43 -16   9   8;
    -15  36  12 -54   8 -28  24  14
]

eg_king_table = [
    -74 -35 -18 -18 -11  15   4 -17;
    -12  17  14  17  17  38  23  11;
    10  17  23  15  20  45  44  13;
    -8  22  24  27  26  33  26   3;
    -18  -4  21  24  27  23   9 -11;
    -19  -3  11  21  23  16   7  -9;
    -27 -11   4  13  14   4  -5 -17;
    -53 -34 -21 -11 -28 -14 -24 -4
]
game_blunders = [
    ["rnbqk1nr/pppp2pp/4p3/5p2/1bPP4/P1N5/1P2PPPP/R1BQKBNR b KQkq - 0 4", "Bxc3+"],
    ["6b1/1k6/3P4/1pp3q1/8/6nK/5r2/8 b - - 0 40", "Be6"],
    ["1r6/8/4k3/8/8/K7/8/3q4 b - - 1 1" , "Qa1"],
    ["r1bqkb1r/ppppppp1/8/4n2p/2B1P1n1/3P1N1P/PPP1QPP1/RNB1K2R b KQkq - 0 6" , "Nf3"],
    ["rnb1k1nr/ppqppp1p/2p3pB/8/3PP3/2NB1N2/PPP2PPP/R2QK2R b KQkq -" , "Nxh6"],
    ["8/3P4/8/8/4Q3/4P3/R4K2/3k4 w - - 2 2", "Qb1 Qh1" ],
    ["r1bqkbnr/pp2pppp/2n5/2pp4/4P3/1PNP4/P1P2PPP/R1BQKBNR b KQkq -", "d4"],
    ["3k4/3p4/bN1Q4/1p5p/6p1/3B2P1/1PP2K1P/8 b - - 0 1", "Bc8"],
    ["8/8/1Q6/P3K3/8/k7/8/8 w - - 0 1", "Kd4"],
    ]

selected = [
    ["r1bqkbnr/pp2pppp/2n5/2pp4/4P3/1PNP4/P1P2PPP/R1BQKBNR b KQkq -", "d4"],
]

rapid_engine_table = [
        ["r1bqk1r1/1p1p1n2/p1n2pN1/2p1b2Q/2P1Pp2/1PN5/PB4PP/R4RK1 w q ","Rxf4"],
        ["r1n2N1k/2n2K1p/3pp3/5Pp1/b5R1/8/1PPP4/8 w ", "Ng6" ],
        ["r1b1r1k1/1pqn1pbp/p2pp1p1/P7/1n1NPP1Q/2NBBR2/1PP3PP/R6K w - -"  "f5"],
        ["5b2/p2k1p2/P3pP1p/n2pP1p1/1p1P2P1/1P1KBN2/7P/8 w - -", "Nxg5"],
        ["r3kbnr/1b3ppp/pqn5/1pp1P3/3p4/1BN2N2/PP2QPPP/R1BR2K1 w kq -", "Bxf7"],
        ["r2r2k1/1p1n1pp1/4pnp1/8/PpBRqP2/1Q2B1P1/1P5P/R5K1 b - -", "Nc5"],
        ["2rq1rk1/pb1n1ppN/4p3/1pb5/3P1Pn1/P1N5/1PQ1B1PP/R1B2RK1 b - -", "Nde5"],
        ["r2qk2r/ppp1bppp/2n5/3p1b2/3P1Bn1/1QN1P3/PP3P1P/R3KBNR w KQkq -", "Qxd5"],
        ["rnb1kb1r/p4p2/1qp1pn2/1p2N2p/2p1P1p1/2N3B1/PPQ1BPPP/3RK2R w Kkq -", "Ng6"],
        ["5rk1/pp1b4/4pqp1/2Ppb2p/1P2p3/4Q2P/P3BPP1/1R3R1K b - -", "d4"],
        ["r1b2r1k/ppp2ppp/8/4p3/2BPQ3/P3P1K1/1B3PPP/n3q1NR w - -", "dxe5, Nf3"],
        ["1nkr1b1r/5p2/1q2p2p/1ppbP1p1/2pP4/2N3B1/1P1QBPPP/R4RK1 w - -", "Nxd5"],
        ["1nrq1rk1/p4pp1/bp2pn1p/3p4/2PP1B2/P1PB2N1/4QPPP/1R2R1K1 w - -", "Qd2, Bc2"],
        ["5k2/1rn2p2/3pb1p1/7p/p3PP2/PnNBK2P/3N2P1/1R6 w - -", "Nf3"],
        ["8/p2p4/r7/1k6/8/pK5Q/P7/b7 w - -", "Qd3"],
        ["1b1rr1k1/pp1q1pp1/8/NP1p1b1p/1B1Pp1n1/PQR1P1P1/4BP1P/5RK1 w - -", "Nc6"],
        ["1r3rk1/6p1/p1pb1qPp/3p4/4nPR1/2N4Q/PPP4P/2K1BR2 b - -", "Rxb2"],
        ["r1b1kb1r/1p1n1p2/p3pP1p/q7/3N3p/2N5/P1PQB1PP/1R3R1K b kq -", "Qg5"],
        ["3kB3/5K2/7p/3p4/3pn3/4NN2/8/1b4B1 w - -", "Nf5"],
        ["1nrrb1k1/1qn1bppp/pp2p3/3pP3/N2P3P/1P1B1NP1/PBR1QPK1/2R5 w - -", "Bxh7"],
        ["3rr1k1/1pq2b1p/2pp2p1/4bp2/pPPN4/4P1PP/P1QR1PB1/1R4K1 b - -", "Rc8"],
        ["r4rk1/p2nbpp1/2p2np1/q7/Np1PPB2/8/PPQ1N1PP/1K1R3R w - -", "h4"],
        ["r3r2k/1bq1nppp/p2b4/1pn1p2P/2p1P1QN/2P1N1P1/PPBB1P1R/2KR4 w - -", "Ng6"],
        ["r2q1r1k/3bppbp/pp1p4/2pPn1Bp/P1P1P2P/2N2P2/1P1Q2P1/R3KB1R w KQ -", "Bxd8"],
        ["rqn2rk1/pp2b2p/2n2pp1/1N2p3/5P1N/1PP1B3/4Q1PP/R4RK1 w - -", "Nxg6"],
        ["8/3Pk1p1/1p2P1K1/1P1Bb3/7p/7P/6P1/8 w - -", "g4"],
        ["4rrk1/Rpp3pp/6q1/2PPn3/4p3/2N5/1P2QPPP/5RK1 w - -", "Rxc5"],
        ["rnbq1r1k/4p1bP/p3p3/1pn5/8/2Np1N2/PPQ2PP1/R1B1KB1R w KQ -", "Nh4"],
        ["4b1k1/1p3p2/4pPp1/p2pP1P1/P2P4/1P1B4/8/2K5 w - -", "b4"],
        ["8/7p/5P1k/1p5P/5p2/2p1p3/P1P1P1P1/1K3Nb1 w - -", "Ng3"],
        ["r3kb1r/ppnq2pp/2n5/4pp2/1P1PN3/P4N2/4QPPP/R1B1K2R w KQkq -", "Nxe5"],
        ["b4r1k/6bp/3q1ppN/1p2p3/3nP1Q1/3BB2P/1P3PP1/2R3K1 w - -", "Rc8"],
        ["r3k2r/5ppp/3pbb2/qp1Np3/2BnP3/N7/PP1Q1PPP/R3K2R w KQkq -", "Nxb5"],
        ["r1k1n2n/8/pP6/5R2/8/1b1B4/4N3/1K5N w - -", "b7"],
        ["1k6/bPN2pp1/Pp2p3/p1p5/2pn4/3P4/PPR5/1K6 w - -", "Na8"],
        ["8/6N1/3kNKp1/3p4/4P3/p7/P6b/8 w - -", "exd5"],
        ["r1b1k2r/pp3ppp/1qn1p3/2bn4/8/6P1/PPN1PPBP/RNBQ1RK1 w kq -", "a3"],
        ["r3kb1r/3n1ppp/p3p3/1p1pP2P/P3PBP1/4P3/1q2B3/R2Q1K1R b kq -", "Bc5"],
        ["3q1rk1/2nbppb1/pr1p1n1p/2pP1Pp1/2P1P2Q/2N2N2/1P2B1PP/R1B2RK1 w - -", "Nxg5"],
        ["8/2k5/N3p1p1/2KpP1P1/b2P4/8/8/8 b - -", "Kb7"],
        ["2r1rbk1/1pqb1p1p/p2p1np1/P4p2/3NP1P1/2NP1R1Q/1P5P/R5BK w - -", "Nxf5"],
        ["rnb2rk1/pp2q2p/3p4/2pP2p1/2P1Pp2/2N5/PP1QBRPP/R5K1 w - -", "h4"],
        ["5rk1/p1p1rpb1/q1Pp2p1/3Pp2p/4Pn2/1R4N1/P1BQ1PPP/R5K1 w - -", "Rb4"],
        ["8/4nk2/1p3p2/1r1p2pp/1P1R1N1P/6P1/3KPP2/8 w - -", "Nd3"],
        ["4kbr1/1b1nqp2/2p1p3/2N4p/1p1PP1pP/1PpQ2B1/4BPP1/r4RK1 w - -", "Nxb7"],
        ["r1b2rk1/p2nqppp/1ppbpn2/3p4/2P5/1PN1PN2/PBQPBPPP/R4RK1 w - -", "cxd5"],
        ["r1b1kq1r/1p1n2bp/p2p2p1/3PppB1/Q1P1N3/8/PP2BPPP/R4RK1 w kq -", "f4"],
        ["r4r1k/p1p3bp/2pp2p1/4nb2/N1P4q/1P5P/PBNQ1PP1/R4RK1 b - -", "Nf3"],
        ["6k1/pb1r1qbp/3p1p2/2p2p2/2P1rN2/1P1R3P/PB3QP1/3R2K1 b - -", "Bh6"],
        ["2r2r2/1p1qbkpp/p2ppn2/P1n1p3/4P3/2N1BB2/QPP2PPP/R4RK1 w - -", "b4"],
        ["r1bq1rk1/p4ppp/3p2n1/1PpPp2n/4P2P/P1PB1PP1/2Q1N3/R1B1K2R b KQ -", "c4"],
        ["2b1r3/5pkp/6p1/4P3/QppqPP2/5RPP/6BK/8 b - -", "c3"],
        ["r2q1rk1/1p2bpp1/p1b2n1p/8/5B2/2NB4/PP1Q1PPP/3R1RK1 w - -", "Bxh6"],
        ["r2qr1k1/pp2bpp1/2pp3p/4nbN1/2P4P/4BP2/PPPQ2P1/1K1R1B1R w - -", "Be2"],
        ["r2qr1k1/pp1bbp2/n5p1/2pPp2p/8/P2PP1PP/1P2N1BK/R1BQ1R2 w - -", "d6"],
        ["8/8/R7/1b4k1/5p2/1B3r2/7P/7K w - -", "h4"],
        ["rq6/5k2/p3pP1p/3p2p1/6PP/1PB1Q3/2P5/1K6 w - -", "Qd3"],
        ["q2B2k1/pb4bp/4p1p1/2p1N3/2PnpP2/PP3B2/6PP/2RQ2K1 b - -", "Qxd8"],
        ["4rrk1/pp4pp/3p4/3P3b/2PpPp1q/1Q5P/PB4B1/R4RK1 b - -", "Rf6"],
        ["rr1nb1k1/2q1b1pp/pn1p1p2/1p1PpNPP/4P3/1PP1BN2/2B2P2/R2QR1K1 w - -", "g6"],
        ["r3k2r/4qn2/p1p1b2p/6pB/P1p5/2P5/5PPP/RQ2R1K1 b kq -", "Kf8"],
        ["8/1pp5/p3k1pp/8/P1p2PPP/2P2K2/1P3R2/5r2 b - -", "Qb6"],
        ["8/2pN1k2/p4p1p/Pn1R4/3b4/6Pp/1P3K1P/8 w - -", "Ke1"],
        ["5r1k/1p4bp/3p1q2/1NpP1b2/1pP2p2/1Q5P/1P1KBP2/r2RN2R b - -", "f3"],
        ["r3kb1r/pbq2ppp/1pn1p3/2p1P3/1nP5/1P3NP1/PB1N1PBP/R2Q1RK1 w kq -", "a3"],
        ["5rk1/n2qbpp1/pp2p1p1/3pP1P1/PP1P3P/2rNPN2/R7/1Q3RK1 w - -", "h5"],
        ["r5k1/1bqp1rpp/p1n1p3/1p4p1/1b2PP2/2NBB1P1/PPPQ4/2KR3R w - -", "a3"],
        ["1r4k1/1nq3pp/pp1pp1r1/8/PPP2P2/6P1/5N1P/2RQR1K1 w - -", "f5"],
        ["q5k1/p2p2bp/1p1p2r1/2p1np2/6p1/1PP2PP1/P2PQ1KP/4R1NR b - -", "Qd5"],
        ["r4rk1/ppp2ppp/1nnb4/8/1P1P3q/PBN1B2P/4bPP1/R2QR1K1 w - -", "Qxe2"],
        ["1r3k2/2N2pp1/1pR2n1p/4p3/8/1P1K1P2/P5PP/8 w - -", "Kc4"],
        ["6r1/6r1/2p1k1pp/p1pbP2q/Pp1p1PpP/1P1P2NR/1KPQ3R/8 b - -", "Qf5"],
        ["r1b1kb1r/1p1npppp/p2p1n2/6B1/3NPP2/q1N5/P1PQ2PP/1R2KB1R w Kkq -", "Bxf6"],
        ["r3r1k1/1bq2ppp/p1p2n2/3ppPP1/4P3/1PbB4/PBP1Q2P/R4R1K w - -", "gxf6"],
        ["r4rk1/ppq3pp/2p1Pn2/4p1Q1/8/2N5/PP4PP/2KR1R2 w - -", "Rxf6"],
        ["r1bqr1k1/3n1ppp/p2p1b2/3N1PP1/1p1B1P2/1P6/1PP1Q2P/2KR2R1 w - -", "Qxe8"],
        ["5rk1/1ppbq1pp/3p3r/pP1PppbB/2P5/P1BP4/5PPP/3QRRK1 b - -", "Bc1"],
        ["r3r1kb/p2bp2p/1q1p1npB/5NQ1/2p1P1P1/2N2P2/PPP5/2KR3R w - -", "Bg7"],
        ["8/3P4/1p3b1p/p7/P7/1P3NPP/4p1K1/3k4 w - -", "g4"],
        ["3q1rk1/7p/rp1n4/p1pPbp2/P1P2pb1/1QN4P/1B2B1P1/1R3RK1 w - -", "Nb5"],
        ["4r1k1/1r1np3/1pqp1ppB/p7/2b1P1PQ/2P2P2/P3B2R/3R2K1 w - -", "Bg7 Bg5"],
        ["r4rk1/q4bb1/p1R4p/3pN1p1/8/2N3P1/P4PP1/3QR1K1 w - -", "Ng4"],
        ["r3k2r/pp2pp1p/8/q2Pb3/2P5/4p3/B1Q2PPP/2R2RK1 w kq -", "c5"],
        ["r3r1k1/1bnq1pbn/p2p2p1/1p1P3p/2p1PP1B/P1N2B1P/1PQN2P1/3RR1K1 w - -", "e5"],
        ["8/4k3/p2p2p1/P1pPn2p/1pP1P2P/1P1NK1P1/8/8 w - -", "g4"],
        ["8/2P1P3/b1B2p2/1pPRp3/2k3P1/P4pK1/nP3p1p/N7 w - -", "e8N"],
        ["4K1k1/8/1p5p/1Pp3b1/8/1P3P2/P1B2P2/8 w - -", "f4"],
        ["8/6p1/3k4/3p1p1p/p2K1P1P/4P1P1/P7/8 b - -", "g6, Kc6"],
        ["r1b2rk1/ppp3p1/4p2p/4Qpq1/3P4/2PB4/PPK2PPP/R6R b - -", "Nd6"],
        ["2k2Br1/p6b/Pq1r4/1p2p1b1/1Ppp2p1/Q1P3N1/5RPP/R3N1K1 b - -", "Rf6"],
        ["r2qk2r/ppp1b1pp/2n1p3/3pP1n1/3P2b1/2PB1NN1/PP4PP/R1BQK2R w KQkq -", "Nxg5"],
        ["8/8/4p1Pk/1rp1K1p1/4P1P1/1nP2Q2/p2b1P2/8 w - -", "Kf6"],
        ["2k5/p7/Pp1p1b2/1P1P1p2/2P2P1p/3K3P/5B2/8 w - -", "c5"],
        ["8/6pp/5k2/1p1r4/4R3/7P/5PP1/5K2 w - -", "Re8"],
        ["rn2k2r/3pbppp/p3p3/8/Nq1Nn3/4B1P1/PP3P1P/R2Q1RK1 w k -", "Nf5"],
        ["r1b1kb1N/pppnq1pB/8/3p4/3P4/8/PPPK1nPP/RNB1R3 b q -", "Ne5"],
        ["N4rk1/pp1b1ppp/n3p1n1/3pP1Q1/1P1N4/8/1PP2PPP/q1B1KB1R b K -", "Nxb4"],
        ["4k1br/1K1p1n1r/2p2pN1/P2p1N2/2P3pP/5B2/P2P4/8 w - -", "Kc8"],
        ["r1bqkb1r/ppp3pp/2np4/3N1p2/3pnB2/5N2/PPP1QPPP/2KR1B1R b kq -", "Ne7"],
        ["r3kb1r/pbqp1pp1/1pn1pn1p/8/3PP3/2PB1N2/3N1PPP/R1BQR1K1 w kq -", "e5"],
        ["r2r2k1/pq2bppp/1np1bN2/1p2B1P1/5Q2/P4P2/1PP4P/2KR1B1R b - -", "Bxf6"],
        ["1r1r2k1/2pq3p/4p3/2Q1Pp2/1PNn1R2/P5P1/5P1P/4R2K b - -", "Rb5"],
        ["8/5p1p/3P1k2/p1P2n2/3rp3/1B6/P4R2/6K1 w - -", "Ba4"],
        ["2rbrnk1/1b3p2/p2pp3/1p4PQ/1PqBPP2/P1NR4/2P4P/5RK1 b - -", "Qxd4"],
        ["4r1k1/1bq2r1p/p2p1np1/3Pppb1/P1P5/1N3P2/1R2B1PP/1Q1R2BK w - -", "c5"],
        ["8/8/8/8/4kp2/1R6/P2q1PPK/8 w - -", "a3"]
    ]