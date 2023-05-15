import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: debugDisableShadows,
      home: const TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({Key? key}) : super(key: key);

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> board;
  late String currentPlayer;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
      gameOver = false;
    });
  }

  void makeMove(int row, int col) {
    if (board[row][col].isEmpty && !gameOver) {
      setState(() {
        board[row][col] = currentPlayer;
        if (checkWin(row, col)) {
          gameOver = true;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Game Over'),
              content: Text('Player $currentPlayer wins!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startNewGame();
                  },
                  child: const Text('New Game'),
                ),
              ],
            ),
          );
        } else if (isBoardFull()) {
          gameOver = true;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Game Over'),
              content: const Text('It\'s a draw!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startNewGame();
                  },
                  child: const Text('New Game'),
                ),
              ],
            ),
          );
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWin(int row, int col) {
    final String player = board[row][col];

    // Check row
    if (board[row].every((cell) => cell == player)) {
      return true;
    }

    // Check column
    if (board.every((row) => row[col] == player)) {
      return true;
    }

    // Check diagonal
    if (row == col && board.every((list) => list[row] == player)) {
      return true;
    }

    // Check anti-diagonal
    if (row + col == 2 && board.every((list) => list[2 - row] == player)) {
      return true;
    }

    return false;
  }

  bool isBoardFull() {
    for (var row in board) {
      if (row.any((cell) => cell == '')) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.brown[500],
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              startNewGame();
                            },
                            child: const Text(
                              'New Game',
                              style: TextStyle(
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Exit',
                              style: TextStyle(
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 230),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 15.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(color: Colors.grey, blurRadius: 10),
                ],
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final row = index ~/ 3;
                  final col = index % 3;
                  return GestureDetector(
                    onTap: () {
                      makeMove(row, col);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.brown[200],
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: const TextStyle(fontSize: 70.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            'Current Player: $currentPlayer',
            style: const TextStyle(fontSize: 24.0),
          ),
        ],
      ),
    );
  }
}
