class GameLogic {
  
  List<List<String>> parseBoard(String boardString, int boardSize) {
    return boardString.split('|').map((row) => row.split(',')).toList();
  }

  String checkWinner(List<List<String>> board) {
    int size = board.length;

    for (int i = 0; i < size; i++) {
      if (board[i].every((cell) => cell == board[i][0] && cell != '')) {
        return board[i][0];
      }
      if (List.generate(size, (index) => board[index][i]).every((cell) => cell == board[0][i] && cell != '')) {
        return board[0][i];
      }
    }

    if (List.generate(size, (index) => board[index][index]).every((cell) => cell == board[0][0] && cell != '')) {
      return board[0][0];
    }
    if (List.generate(size, (index) => board[index][size - index - 1]).every((cell) => cell == board[0][size - 1] && cell != '')) {
      return board[0][size - 1];
    }

    return '';
  }

  bool isBoardFull(List<List<String>> board) {
    for (var row in board) {
      for (var cell in row) {
        if(cell == '') return false;
}
}
return true;
}
void resetBoard(List<List<String>> board) {
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        board[i][j] = '';
      }
    }
  }
}