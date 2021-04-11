int inflation = 100; //<>//
boolean Button1Active, Button2Active;
int points = -1;
int lives = 10;
PImage heart;
int wobble;
float disabled = 0;
float maxDisabled = 0;
int[] scores;

//Setting up;
void setup() {
  size(800, 800);
  background(51);
  heart = loadImage("data/Heart.png");
  scores = new int[10];
  String[] scoreString = loadStrings("data/scores.txt");
  for (int i = 0; i < 10; i ++) {
    if (scoreString.length > i) scores[i] = int(scoreString[i]);
  }
  sort(scores);
  frameRate(30);
}

//Draw loop
void draw() {
  background(51);
  if (lives >= 0 || lives > 0 && disabled == 0) {
    drawBalloon();
    drawButtons();
    drawPoints();
    drawLives();
    countDown(260);

    Button1Active = mouseX>=20 && mouseX<=380 && mouseY>=160 && mouseY<=240 && lives > 0 && disabled == 0;
    Button2Active = mouseX>=420 && mouseX<=780 && mouseY>=160 && mouseY<=240 && lives > 0 && disabled == 0;
  } else {
    if (lives == -1 && disabled > 0) {
      countDown(30);
      drawScores();
    } else if (disabled == 0 && points == 0) {
      lives = 10;
    } else {
      saveScores();
    }
  }
  if (disabled > 0) disabled -= 5;
  if (wobble > 0) wobble -= 10;
  if (disabled == 0 && lives == -1) {
    lives = 0;
    return;
  }
  if (disabled == 0 && lives == 0) {
    lives = -1;
    return;
  }
}

//Draw the balloon
void drawBalloon() {
  fill(lerpColor(color(90, 250, 140), color(250, 50, 40), inflation / 600f));
  pushMatrix();
  translate(width/2, height/3*2);
  float step = 2*PI/200;
  float p = 1.2;
  float h = 0.2;
  float q = 1;
  float d = 0.6;
  //egg
  beginShape();
  for (float theta=0; theta < 2*PI; theta+=step) {
    float x = d*(p+h*sin(theta))*h*cos(theta);
    float y = (1/q) * ( h * sin(theta));
    vertex((inflation*2+wobble)*x, (inflation*2+wobble)*-y);
  }
  endShape();
  popMatrix();
}

//Draw buttons to screen
void drawButtons() {
  if (Button1Active) {
    fill(255, 190, 190);
    rect(20, 160, 360, 80, 20);
    
    fill(255);
    text("Inflate",100,190);
  } else if(disabled == 0 && lives > 0) {
    fill(180, 130, 130);
    rect(20, 160, 360, 80, 20);
    
    fill(170);
    text("Inflate",100,190);
  } else {
    fill(90, 65, 65);
    rect(20, 160, 360, 80, 20);
    
    fill(50);
    text("Inflate",100,190);
  }

  if (Button2Active) {
    fill(190, 140, 190);
    rect(420, 160, 360, 80, 20);
    
    fill(255);
    text("Bank",520,190);
  } else if (disabled == 0 && lives > 0) {
    fill(130, 110, 130);
    rect(420, 160, 360, 80, 20);
    
    fill(170);
    text("Bank",520,190);
  } else {
    fill(65, 55, 65);
    rect(420, 160, 360, 80, 20);
    
    fill(50);
    text("Bank",520,190);
  }
}
//Draw scores to screen
void drawScores() {
  textSize(60);
  fill(255);
  for (int i = 0; i < 10; i ++) {
    text("Place ("+i+"): " +scores[i], 20, 120 + 70 * i);
  }
}

//SaveScores
void saveScores() {
  disabled = 2000;
  maxDisabled = 2000;
  scores = append(scores, points);
  scores = reverse(sort(scores));
  saveStrings("scores.txt", str(scores));
  points = 0;
}

//Draw points to screen
void drawPoints() {
  fill(230, 240, 255);
  textSize(60);
  textAlign(LEFT, CENTER);
  text("Points: "+max(points, 0), 20, 30);
  text("Inflation: "+floor((inflation - 100) / 5), 20, 90);
}


//Draw Lives to Screen
void drawLives() {
  for (int i = 0; i < lives; i ++) {
    image(heart, 380 + ((i%5)*80), 10 + floor(i/5) * 80);
  }
}


//Draw Count down to screen
void countDown(int Height) {
  if (disabled != 0) {
    fill(20);
    rect(20, Height, width - 40, 60, 20);
    fill((disabled / maxDisabled)*255, 255 - (disabled / maxDisabled)*255, 0);
    rect(20, Height, (disabled / maxDisabled) * (width-40f), 60, 20);
  }
}

//Try pop the balloon
boolean tryPop(int inf) {
  return random(10) < (1/sqrt(1-(pow(inf, 2)/pow(100, 2))))-1;
}


//Detect mouse clicks
void mousePressed() {
  if (Button1Active && disabled == 0) {
    if (tryPop((inflation - 100) / 5) || inflation > 600) {
      wobble = inflation;
      inflation = 100;
      lives -= 1;
      if (lives >= 0) {
         disabled = 200;
         maxDisabled = 200;
      }
    } else {
      inflation += 5;
      wobble = 50;
    }
  }
  
  if (Button2Active) {
    if(points == -1 && inflation > 100) points++;
    points += floor((inflation - 100)/5);
    wobble = inflation - 100;
    inflation = 100;
    lives -= 1;
    if (lives >= 0) {
       disabled = 200;
       maxDisabled = 200;
    }
  }
}
