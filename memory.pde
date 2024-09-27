int cols = 4; 
int rows = 4; 
int[][] cards = new int[cols][rows]; 
boolean[][] revealed = new boolean[cols][rows]; 
int cardSize = 100; 
int firstCardX = -1, firstCardY = -1; 
int secondCardX = -1, secondCardY = -1;
boolean checking = false;
int checkTimer = 0;
int matchesFound = 0;

void setup() {
  size(400, 400);
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
  // วาดการ์ด
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (revealed[i][j] || (i == firstCardX && j == firstCardY) || (i == secondCardX && j == secondCardY)) {
        // ถ้าการ์ดหงายอยู่หรือเลือกอยู่ แสดงตัวเลข
        fill(255);
        rect(i * cardSize, j * cardSize, cardSize, cardSize);
        fill(0);
        textAlign(CENTER, CENTER);
        text(cards[i][j], i * cardSize + cardSize / 2, j * cardSize + cardSize / 2);
      } else {
        // ถ้าการ์ดคว่ำอยู่ แสดงเป็นกล่องเปล่า
        fill(150);
        rect(i * cardSize, j * cardSize, cardSize, cardSize);
      }
    }
  }
  
  // ตรวจสอบการจับคู่
  if (checking) {
    checkTimer++;
    if (checkTimer > 60) {
      if (cards[firstCardX][firstCardY] == cards[secondCardX][secondCardY]) {
        // ถ้าเป็นคู่กัน เปิดการ์ดทั้งคู่
        revealed[firstCardX][firstCardY] = true;
        revealed[secondCardX][secondCardY] = true;
        matchesFound++;
      }
      // รีเซ็ตสถานะการเลือกการ์ด
      firstCardX = -1;
      firstCardY = -1;
      secondCardX = -1;
      secondCardY = -1;
      checking = false;
    }
  }
  
  // แสดงข้อความเมื่อจับคู่ครบ
  if (matchesFound == (cols * rows) / 2) {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("You Win!", width / 2, height / 2);
  }
}

void mousePressed() {
  if (checking || matchesFound == (cols * rows) / 2) return; // ห้ามคลิกระหว่างตรวจสอบหรือเมื่อเกมจบ
  
  // คำนวณการ์ดที่ถูกคลิก
  int x = mouseX / cardSize;
  int y = mouseY / cardSize;
  
  if (x >= cols || y >= rows || revealed[x][y]) return; // ถ้าคลิกนอกพื้นที่หรือคลิกการ์ดที่เปิดอยู่แล้ว
  
  if (firstCardX == -1 && firstCardY == -1) {
    // เลือกการ์ดแรก
    firstCardX = x;
    firstCardY = y;
  } else if (secondCardX == -1 && secondCardY == -1 && (x != firstCardX || y != firstCardY)) {
    // เลือกการ์ดที่สอง
    secondCardX = x;
    secondCardY = y;
    checking = true;
    checkTimer = 0;
  }
}

int[] shuffle(int[] array) {
  // ฟังก์ชันสำหรับสุ่มลำดับของ array
  for (int i = array.length - 1; i > 0; i--) {
    int j = int(random(i + 1));
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
  return array;
}
