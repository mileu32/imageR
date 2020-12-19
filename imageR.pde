color[][][] image = new color[512][512][2]; //<>//
color[][][] image2 = new color[512][512][2];
color[][][] image3 = new color[512][512][2];
PImage target;
PGraphics out, out2, out3;
int step;
float theta;


void setup() {
  size(1063, 1063);
  background(127);

  textSize(32);
  textAlign(CENTER, TOP);
  fill(0);

  target = loadImage("lenna.png");
  out = createGraphics(512, 512);
  out2 = createGraphics(512, 512);
  out3 = createGraphics(512, 512);

  step = 40;
  theta = radians(step);

  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      image[i][j][0] = target.get(i, j);
      image2[i][j][0] = target.get(i, j);
      image3[i][j][0] = target.get(i, j);
    }
  }

  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      image[i][j][1] = color(127);
      image2[i][j][1] = color(127);
      image3[i][j][1] = color(127);
    }
  }

  frameRate(1);
  image(target, 13, 13);
  image(target, 538, 13);
  image(target, 13, 538);
  image(target, 538, 538);
}

void draw() {

  for (int i = 0; i < 512; i++) { // nearest neighbor
    for (int j = 0; j < 512; j++) {
      image[i][j][1] = color(255);
      int ii = int((i - 255.5) * cos(theta) - (j - 255.5) * sin(theta) + 1/2 + 255.5);
      int jj = int((i - 255.5) * sin(theta) + (j - 255.5) * cos(theta) + 1/2 + 255.5);
      if (ii >= 0 && ii < 512 && jj >=0 && jj < 512) {
        image[i][j][1] = image[ii][jj][0];
      }
    }
  }

  for (int i = 0; i < 512; i++) { // bilinear
    for (int j = 0; j < 512; j++) {
      image2[i][j][1] = color(255);
      float ii = (i - 255.5) * cos(theta) - (j - 255.5) * sin(theta) + 255.5;
      float jj = (i - 255.5) * sin(theta) + (j - 255.5) * cos(theta) + 255.5;

      int i0 = int(ii);
      int j0 = int(jj);

      if (ii >= 0 && ii < 511 && jj >=0 && jj < 511) {
        int r, g, b;
        r = int(red(image2[i0][j0][0]) * (1 - ii + i0) * (1 - jj + j0) + red(image2[i0 + 1][j0][0]) * (ii - i0) * (1 - jj + j0) + red(image2[i0][j0 + 1][0]) * (1 - ii + i0) * (jj - j0) + red(image2[i0 + 1][j0 + 1][0]) * (ii - i0) * (jj - j0));
        g = int(green(image2[i0][j0][0]) * (1 - ii + i0) * (1 - jj + j0) + green(image2[i0 + 1][j0][0]) * (ii - i0) * (1 - jj + j0) + green(image2[i0][j0 + 1][0]) * (1 - ii + i0) * (jj - j0) + green(image2[i0 + 1][j0 + 1][0]) * (ii - i0) * (jj - j0));
        b = int(blue(image2[i0][j0][0]) * (1 - ii + i0) * (1 - jj + j0) + blue(image2[i0 + 1][j0][0]) * (ii - i0) * (1 - jj + j0) + blue(image2[i0][j0 + 1][0]) * (1 - ii + i0) * (jj - j0) + blue(image2[i0 + 1][j0 + 1][0]) * (ii - i0) * (jj - j0));
        if (r > 255) r = 255;
        if (r < 0) r = 0;
        if (g > 255) g = 255;
        if (g < 0) g = 0;
        if (b > 255) b = 255;
        if (b < 0) b = 0;
        image2[i][j][1] = color(r, g, b);
      }
    }
  }

  for (int i = 0; i < 512; i++) { //Fittinga a Quadratic Curve to Data
    for (int j = 0; j < 512; j++) {
      image3[i][j][1] = color(255);
      float ii = (i - 255.5) * cos(theta) - (j - 255.5) * sin(theta) + 255.5;
      float jj = (i - 255.5) * sin(theta) + (j - 255.5) * cos(theta) + 255.5;

      int i0 = int(ii);
      int j0 = int(jj);
      if (ii >= 1 && ii < 510 && jj >= 1 && jj < 510) {
        float r0 = fqcd(ii - i0, red(image3[i0 - 1][j0 - 1][0]), red(image3[i0][j0 - 1][0]), red(image3[i0 + 1][j0 - 1][0]), red(image3[i0 + 2][j0 - 1][0]));
        float r1 = fqcd(ii - i0, red(image3[i0 - 1][j0][0]), red(image3[i0][j0][0]), red(image3[i0 + 1][j0][0]), red(image3[i0 + 2][j0][0]));
        float r2 = fqcd(ii - i0, red(image3[i0 - 1][j0 + 1][0]), red(image3[i0][j0 + 1][0]), red(image3[i0 + 1][j0 + 1][0]), red(image3[i0 + 2][j0 + 1][0]));
        float r3 = fqcd(ii - i0, red(image3[i0 - 1][j0 + 2][0]), red(image3[i0][j0 + 2][0]), red(image3[i0 + 1][j0 + 2][0]), red(image3[i0 + 2][j0 + 2][0]));

        float rr = fqcd(jj - j0, r0, r1, r2, r3);

        float g0 = fqcd(ii - i0, green(image3[i0 - 1][j0 - 1][0]), green(image3[i0][j0 - 1][0]), green(image3[i0 + 1][j0 - 1][0]), green(image3[i0 + 2][j0 - 1][0]));
        float g1 = fqcd(ii - i0, green(image3[i0 - 1][j0][0]), green(image3[i0][j0][0]), green(image3[i0 + 1][j0][0]), green(image3[i0 + 2][j0][0]));
        float g2 = fqcd(ii - i0, green(image3[i0 - 1][j0 + 1][0]), green(image3[i0][j0 + 1][0]), green(image3[i0 + 1][j0 + 1][0]), green(image3[i0 + 2][j0 + 1][0]));
        float g3 = fqcd(ii - i0, green(image3[i0 - 1][j0 + 2][0]), green(image3[i0][j0 + 2][0]), green(image3[i0 + 1][j0 + 2][0]), green(image3[i0 + 2][j0 + 2][0]));

        float gg = fqcd(jj - j0, g0, g1, g2, g3);

        float b0 = fqcd(ii - i0, blue(image3[i0 - 1][j0 - 1][0]), blue(image3[i0][j0 - 1][0]), blue(image3[i0 + 1][j0 - 1][0]), blue(image3[i0 + 2][j0 - 1][0]));
        float b1 = fqcd(ii - i0, blue(image3[i0 - 1][j0][0]), blue(image3[i0][j0][0]), blue(image3[i0 + 1][j0][0]), blue(image3[i0 + 2][j0][0]));
        float b2 = fqcd(ii - i0, blue(image3[i0 - 1][j0 + 1][0]), blue(image3[i0][j0 + 1][0]), blue(image3[i0 + 1][j0 + 1][0]), blue(image3[i0 + 2][j0 + 1][0]));
        float b3 = fqcd(ii - i0, blue(image3[i0 - 1][j0 + 2][0]), blue(image3[i0][j0 + 2][0]), blue(image3[i0 + 1][j0 + 2][0]), blue(image3[i0 + 2][j0 + 2][0]));

        float bb = fqcd(jj - j0, b0, b1, b2, b3);

        int r = int(rr);
        int g = int(gg);
        int b = int(bb);

        if (r > 255) r = 255;
        if (r < 0) r = 0;
        if (g > 255) g = 255;
        if (g < 0) g = 0;
        if (b > 255) b = 255;
        if (b < 0) b = 0;


        image3[i][j][1] = color(r, g, b);
      }
    }
  }

  image(target, 13, 13);
  text("target image", 269, 26);


  out.beginDraw();
  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      out.set(i, j, image[i][j][1]);
    }
  }
  out.endDraw();

  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      image[i][j][0] = image[i][j][1];
    }
  }

  image(out, 13, 538);
  text("nearest neighbor", 269, 551);

  out2.beginDraw();
  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      out2.set(i, j, image2[i][j][1]);
    }
  }
  out2.endDraw();

  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      image2[i][j][0] = image2[i][j][1];
    }
  }

  image(out2, 538, 13);
  text("bilinear interpolation", 794, 26);

  out3.beginDraw();
  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      out3.set(i, j, image3[i][j][1]);
    }
  }
  out3.endDraw();

  for (int i = 0; i < 512; i++) {
    for (int j = 0; j < 512; j++) {
      image3[i][j][0] = image3[i][j][1];
    }
  }

  image(out3, 538, 538);
  text("Fitting a Quadratic Curve to Data", 794, 551);

  if (frameCount >= (360 / step)) {
    noLoop();
    textAlign(CENTER, BOTTOM);
    text("rotate 40° per step, 9 steps", 269, 512);
    text("error : " + rmsdiff(out), 269, 1037);
    text("error : " + rmsdiff(out2), 794, 512);
    text("error : " + rmsdiff(out3), 794, 1037);
  }
  saveFrame("data/####.png");
}

void exit() {
}

float rmsdiff(PGraphics pg) { //root mean square

  float rerr, gerr, berr;
  float fit = 0;

  for (int x = 0; x < target.width; x++) {
    for (int y = 0; y < target.height; y++) {
      int loc = x + y*target.width;
      //int comploc = x + (y+(target.height))*target.width;
      color sourcepix = target.pixels[loc];
      color comparepix = pg.pixels[loc];

      //find the error in color (0 to 255, 0 is no error)
      rerr = abs(red(sourcepix)-red(comparepix));
      gerr = abs(green(sourcepix)-green(comparepix));
      berr = abs(blue(sourcepix)-blue(comparepix));
      fit += pow((rerr + gerr + berr) / 3, 2) ;
    }
  }  
  return pow(fit/65536, 0.5);
}

float fqcd(float x, float y1, float y2, float y3, float y4) {//Fitting a Quadratic Curve to Data
  float a0 = (3 * y1)/20 + (11 * y2)/20 + (9 * y3)/20 - (3 * y4)/20;
  float a1 = (-11 * y1)/20 + (3 * y2)/20 + (7 * y3)/20 + y4/20;
  float a2 = y1/4 - y2/4 - y3/4 + y4/4;

  return a0 + a1 * x + a2 * x * x;
}
