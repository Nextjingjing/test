// Pruek Tanvorakul 6601012610083
// Mutliplayer
// Hint 
// Timer

int cols = 8;
int rows = 5;
int[][] cards = new int[cols][rows];
boolean[][] revealed = new boolean[cols][rows];
int cardSize = 100;
int firstCardX = -1, firstCardY = -1;
int secondCardX = -1, secondCardY = -1;
boolean checking = false;
int checkTimer = 0;
int matchesFound = 0;
int totalSeconds = 600;  // 10 minutes
int hintRow = -1;

// Player-related variables
int currentPlayer = 1;  // 1 or 2 to represent the active player
int player1Score = 0;
int player2Score = 0;

void setup() {
  size(800, 800);
  resetGame();
}

void resetGame() {
  int[] values = new int[cols * rows];
  for (int i = 0; i < (cols * rows) / 2; i++) {
    values[i] = i + 1;
    values[i + (cols * rows) / 2] = i + 1;
  }
  values = shuffle(values);

  int index = 0;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      cards[i][j] = values[index++];
      revealed[i][j] = false;
    }
  }

  // Reset game state
  firstCardX = firstCardY = secondCardX = secondCardY = -1;
  checking = false;
  matchesFound = 0;
  totalSeconds = 600;  // Reset to 10 minutes
  hintRow = -1;

  // Reset player state
  player1Score = 0;
  player2Score = 0;
  currentPlayer = 1;
}

void draw() {
  background(200);
  drawBoard();
  updateTimer();

  if (checking) {
    checkTimer++;
    if (checkTimer > 60) {
      checkMatch();
      togglePlayer();  // Switch to the other player after a complete turn
    }
  }

  if (matchesFound == (cols * rows) / 2) {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(32);
    if (player1Score > player2Score) {
      text("Player 1 Wins!", width / 2, height / 2);
    } else if (player2Score > player1Score) {
      text("Player 2 Wins!", width / 2, height / 2);
    } else {
      text("It's a Draw!", width / 2, height / 2);
    }
    noLoop();  // Stop the game when it's over
  }
}

void drawBoard() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (revealed[i][j] || (i == firstCardX && j == firstCardY) || (i == secondCardX && j == secondCardY)) {
        fill(255);
        rect(i * cardSize, j * cardSize, cardSize, cardSize);
        fill(0);
        textAlign(CENTER, CENTER);
        text(cards[i][j], i * cardSize + cardSize / 2, j * cardSize + cardSize / 2);
      } else {
        fill(150);
        rect(i * cardSize, j * cardSize, cardSize, cardSize);
      }
    }
  }

  // Display Timer, Scores, and Current Player
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  int mins = totalSeconds / 60;
  int secs = totalSeconds % 60;
  text(String.format("Time: %02d:%02d", mins, secs), 400, 550);
  text("Player 1 Score: " + player1Score, 300, 600);
  text("Player 2 Score: " + player2Score, 500, 600);
  text("Current Player: Player " + currentPlayer, 400, 650);

  if (hintRow != -1) {
    text("Hint: Match in row " + (hintRow + 1), 400, 700);
  } else {
    text("Hint: No hint available", 400, 700);
  }

  text("Use mouse wheel to adjust difficulty or restart.", 400, 750);
}

void updateTimer() {
  if (frameCount % 60 == 0 && totalSeconds > 0) {
    totalSeconds--;
  }
  if (totalSeconds == 0) {
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Time's Up! Game Over.", width / 2, height / 2);
    noLoop();  // Stop the game when time is up
  }
}

void checkMatch() {
  if (cards[firstCardX][firstCardY] == cards[secondCardX][secondCardY]) {
    revealed[firstCardX][firstCardY] = true;
    revealed[secondCardX][secondCardY] = true;
    matchesFound++;

    // Increase the score of the current player
    if (currentPlayer == 1) {
      player1Score++;
    } else {
      player2Score++;
    }
  }
  firstCardX = firstCardY = secondCardX = secondCardY = -1;
  checking = false;
}

void togglePlayer() {
  currentPlayer = (currentPlayer == 1) ? 2 : 1;  // Switch between Player 1 and Player 2
}

void mousePressed() {
  if (checking || matchesFound == (cols * rows) / 2) return;

  int x = mouseX / cardSize;
  int y = mouseY / cardSize;

  if (x >= cols || y >= rows || revealed[x][y]) return;

  if (firstCardX == -1) {
    firstCardX = x;
    firstCardY = y;
    provideHint();  // Provide hint immediately on first click
  } else if (secondCardX == -1 && (x != firstCardX || y != firstCardY)) {
    secondCardX = x;
    secondCardY = y;
    checking = true;
    checkTimer = 0;
  }
}

void provideHint() {
  hintRow = -1;  // Reset hint
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (cards[i][j] == cards[firstCardX][firstCardY] && !(i == firstCardX && j == firstCardY)) {
        hintRow = j;  // Store the row where a match is found
        return;
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e == 1) {
    cols = 2;  // Easy mode
  } else if (cols == 4) {
    cols = 8;  // Hard mode
  } else {
    cols = 4;  // Medium mode
  }
  setup();
}

int[] shuffle(int[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = int(random(i + 1));
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
  return array;
}
