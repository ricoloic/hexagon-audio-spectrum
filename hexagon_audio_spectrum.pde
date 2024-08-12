import processing.sound.*;

int sides = 2;

color[] COLORS = {
  #420f1b,
  #77243b,
  #8b263e,
  #a52b45,
  #c73f58,
  #da596a,
  #e78590,
  #f0b1b7,
  #f7d4d7,
  #fbe8e8,
  #fdf3f4,
};

int radius = 200;

SoundFile file;
FFT fft;

int bands = 256;
float[] spectrum = new float[bands];

int MIN_FREQUENCY = 20;
int MAX_FREQUENCY = 20_000;

void setup() {
  fullScreen();
  
  file = new SoundFile(this, "Firebeatz  KSHMR  No Heroes ft Luciana Official Music Video.mp3");
  
  fft = new FFT(this);
  fft.input(file);

  file.play();
}

void draw() {
  background(33);
  translate(width / 2, height / 2);
  noStroke();
  
  fft.analyze(spectrum);

  int amount = spectrum.length / COLORS.length;
  
  for (int j = COLORS.length - 1; j >= 0; j--) {
    int startIndex = j * amount;
    int endIndex = startIndex + amount;
    
    float sum = 0;
    for (int k = startIndex; k < endIndex; k++) {
      sum += spectrum[k];
    }
    sum *= map(j, 0, COLORS.length - 1, 1, sides - 1);
    
    int r = j == COLORS.length - 1 ? radius - 15 : radius - ((COLORS.length - j) * 15) + (int) (sum * 5);
    r = min(radius, r);
    fill(COLORS[COLORS.length - j - 1]);
    beginShape();
    for (float i = 0; i < TWO_PI - 0.01; i += TWO_PI / sides) {
      float x = cos(i) * r;
      float y = sin(i) * r;
      vertex(x, y);
    }
    endShape(CLOSE);
  }
  
  int index = 0;
  int frequencyCount = ((spectrum.length) / sides) - 1;
  for (float i = 0; i < TWO_PI - 0.01; i += TWO_PI / sides) {
    float startX = cos(i) * (radius - 15);
    float startY = sin(i) * (radius - 15);
    float endX = cos(i + TWO_PI / sides) * (radius - 15);
    float endY = sin(i + TWO_PI / sides) * (radius - 15);
    float perpendicularX = endY - startY;
    float perpendicularY = -(endX - startX);
    float div = sqrt(perpendicularX * perpendicularX + perpendicularY * perpendicularY);
    perpendicularX /= div;
    perpendicularY /= div;
    
    for (int j = 0; j < frequencyCount - 1; j++) {
      float p = map(j, 0, frequencyCount - 1, 0, 1);
      float x1 = startX + (p) * (endX - startX);
      float y1 = startY + (p) * (endY - startY);
      float x2 = x1 + perpendicularX * spectrum[index] * 500;
      float y2 = y1 + perpendicularY * spectrum[index] * 500;

      strokeWeight(3);
      stroke(COLORS[6]);
      line(x1, y1, x2, y2);
      
      float x3 = x1 + perpendicularX * spectrum[index] * 450;
      float y3 = y1 + perpendicularY * spectrum[index] * 450;

      strokeWeight(3);
      stroke(COLORS[8]);
      point(x3, y3);

      index++;
    }
  }
}

void keyPressed() {
  if (keyCode == UP) {
    if (sides < 30) sides++;
  } else if (keyCode == DOWN) {
    if (sides > 2) sides--;
  } else if (keyCode == 32) {
    if (file.isPlaying()) file.pause();
    else file.play();
  }
}
