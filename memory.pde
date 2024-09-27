// Pruek Tanvorakul 6601012610083

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

void setup() {
  size(800, 800);
  int[] values = new int[cols * rows];
  for (int i = 0; i < (cols * rows) / 2; i++) {
    values[i] = i + 1;
    values[i + (cols * rows) / 2] = i + 1;
  }
  values = shuffle(values); 
  
  
  int index = 0;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      cards[i][j] = values[index];
      revealed[i][j] = false;
      index++;
    }
  }
}

void draw() {
  background(200);
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
    textSize(14);
    text("you can change diffical game by wheeling your mouse wheel", 300, 700);
    
  }
  
  if (checking) {
    checkTimer++;
    if (checkTimer > 60) {
      if (cards[firstCardX][firstCardY] == cards[secondCardX][secondCardY]) {
        revealed[firstCardX][firstCardY] = true;
        revealed[secondCardX][secondCardY] = true;
        matchesFound++;
      }
      firstCardX = -1;
      firstCardY = -1;
      secondCardX = -1;
      secondCardY = -1;
      checking = false;
    }
  }
  
  if (matchesFound == (cols * rows) / 2) {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("You Win!", width / 2, height / 2);
  }
}

void mousePressed() {
  if (checking || matchesFound == (cols * rows) / 2) return; 
  
  int x = mouseX / cardSize;
  int y = mouseY / cardSize;
  
  if (x >= cols || y >= rows || revealed[x][y]) return; 
  
  if (firstCardX == -1 && firstCardY == -1) {
    firstCardX = x;
    firstCardY = y;
  } else if (secondCardX == -1 && secondCardY == -1 && (x != firstCardX || y != firstCardY)) {
    secondCardX = x;
    secondCardY = y;
    checking = true;
    checkTimer = 0;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e == 1) {
  cols = 2;
  setup();
}
  else {
    if(cols == 4){
      cols = 8;
      setup();
    }else {
      cols = 4;
      setup();
    }
}
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
