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
int currentPlayer = 1;
int player1Score = 0;
int player2Score = 0;

// Developer Mode
boolean devMode = false;

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

  firstCardX = firstCardY = secondCardX = secondCardY = -1;
  checking = false;
  matchesFound = 0;
  totalSeconds = 600;
  hintRow = -1;
  player1Score = 0;
  player2Score = 0;
  currentPlayer = 1;
  devMode = false;
}

void draw() {
  background(200);
  drawBoard();
  drawDevModeButton();
  updateTimer();

  if (checking) {
    checkTimer++;
    if (checkTimer > 60) {
      checkMatch();
      togglePlayer();
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
    noLoop();
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

        if (devMode) {
          fill(0);
          textSize(10);
          textAlign(CENTER, CENTER);
          text(cards[i][j], i * cardSize + cardSize / 2, j * cardSize + cardSize / 2);
        }
      }
    }
  }

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

void drawDevModeButton() {
  int buttonX = width - 120;  // Button aligned to the right
  int buttonY = height - 70;  // Button aligned to the bottom

  fill(devMode ? color(0, 255, 0) : color(255, 0, 0));
  rect(buttonX, buttonY, 100, 40);  // Draw the button

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("Dev Mode", buttonX + 50, buttonY + 20);  // Button label centered
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
    noLoop();
  }
}

void checkMatch() {
  if (cards[firstCardX][firstCardY] == cards[secondCardX][secondCardY]) {
    revealed[firstCardX][firstCardY] = true;
    revealed[secondCardX][secondCardY] = true;
    matchesFound++;

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
  currentPlayer = (currentPlayer == 1) ? 2 : 1;
}

void mousePressed() {
  int buttonX = width - 120;
  int buttonY = height - 70;

  if (mouseX >= buttonX && mouseX <= buttonX + 100 && mouseY >= buttonY && mouseY <= buttonY + 40) {
    devMode = !devMode;
    return;
  }

  if (checking || matchesFound == (cols * rows) / 2) return;

  int x = mouseX / cardSize;
  int y = mouseY / cardSize;

  if (x >= cols || y >= rows || revealed[x][y]) return;

  if (firstCardX == -1) {
    firstCardX = x;
    firstCardY = y;
    provideHint();
  } else if (secondCardX == -1 && (x != firstCardX || y != firstCardY)) {
    secondCardX = x;
    secondCardY = y;
    checking = true;
    checkTimer = 0;
  }
}

void provideHint() {
  hintRow = -1;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (cards[i][j] == cards[firstCardX][firstCardY] && !(i == firstCardX && j == firstCardY)) {
        hintRow = j;
        return;
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e == 1) {
    cols = 2;
  } else if (cols == 4) {
    cols = 8;
  } else {
    cols = 4;
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
