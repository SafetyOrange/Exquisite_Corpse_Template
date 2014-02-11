import spacebrew.*;

PImage soli;
PImage crd;
PVector kPos;
PVector kVel;
float kScale;
float kGrav;

// Spacebrew stuff
String server = "sandbox.spacebrew.cc";
String name   = "ExquisiteCorpse_BERNARDO_ANTHONY_BOBBY";
String desc   = "Some stuff";

Spacebrew sb;

// App Size: you should decide on a width and height
// for your group
int appWidth  = 1280;
int appHeight = 720;

// EC stuff
int corpseStarted   = 0;
boolean bDrawing    = false;
boolean bNeedToClear = true;
boolean play2=false;

//Part 3 Variables
float[] angle, rad, speed, x, y, diam;
int[] nbConnex;
int nbPts;
final static int RADIUS = 30;
boolean isInitialized;

//bernardo variables (all start with bs)
int bsFormResolution = 15;
float bsStepSize = 2;
float bsDistortionFactor = 1;
float bsInitRadius = 120;
float bsCenterX, bsCenterY;
float[] bsX = new float[bsFormResolution];
float[] bsY = new float[bsFormResolution];

void setup() {
  size( appWidth, appHeight );
  smooth();

  sb = new Spacebrew(this);
  sb.addPublish("doneExquisite", "boolean", false);
  sb.addSubscribe("startExquisite", "boolean");
  
  sb.addSubscribe("remoteReceiveNoise", "range");
  sb.addSubscribe("remoteRecieveVictory", "range");

  // add any of your own subscribers here!

  sb.connect( server, name, desc );

  //initializing bernardo's variables
  bsCenterX = width/6; 
  bsCenterY = height/2;
  float bsAngle = radians(360/float(bsFormResolution));
  for (int i=0; i<bsFormResolution; i++) {
    bsX[i] = cos(bsAngle*i) * bsInitRadius;
    bsY[i] = sin(bsAngle*i) * bsInitRadius;
  }

  //initializing anthony's variables
  soli = loadImage("soli.png");
  crd  = loadImage("crd.png");

  pos = new PVector(685, 8);
  vel = new PVector(-5, -1);
  grav = .6;
  
  isInitialized = false;

  kPos = new PVector(685, 8);
  kVel = new PVector(-5, -1);
  kGrav = .6;
  
  bDrawing=true;
  
}
void initialize() {
  nbPts = int(random(20, 40));
  angle = new float[nbPts];
  rad = new float[nbPts];
  speed = new float[nbPts];
  x = new float[nbPts];
  y = new float[nbPts];
  diam = new float[nbPts];
  nbConnex = new int[nbPts];

  for (int i = 0; i<nbPts; i++) {
    angle[i] = random(TWO_PI);
    rad[i] = int(random(1, 5)) * RADIUS;
    speed[i] = random(-.01, .01);
    x[i] = width * 5/6;
    y[i] = height/2;
    nbConnex[i] = 0;
    diam[i] = 0;
  }
}

void draw() {
    // this will make it only render to screen when in EC draw mode
  if (!bDrawing) return;

  // blank out your background once
  if ( bNeedToClear ) {
    bNeedToClear = false;
    background(255); // feel free to change the background color!
  }

  // ---- start bernardo ---- //
  if ( millis() - corpseStarted < 10000 ) {
    
    noFill();
    stroke(255);
    rect(0, 0, width / 3.0, height );

    for (int i=0; i<bsFormResolution; i++) {
      bsX[i] += random(-bsStepSize, bsStepSize);
      bsY[i] += random(-bsStepSize, bsStepSize);
      
      if (bsX[i]+bsCenterX >= width/3) bsX[i] = width/3-bsCenterX-20;
      if (bsX[i]+bsCenterX <= 0) bsX[i] = 0+bsCenterX+20;
      
      if (bsY[i]+bsCenterY >= height) bsY[i] = height-bsCenterY-20;
      if (bsY[i]+bsCenterY <= 0) bsY[i] = 0+bsCenterY+20;
      
    }

    strokeWeight(0.75);
    stroke (0, 30);

    beginShape();
    // start controlpoint
    curveVertex(bsX[bsFormResolution-1]+bsCenterX, bsY[bsFormResolution-1]+bsCenterY);

    // only these points are drawn
    for (int i=0; i<bsFormResolution; i++) {
      curveVertex(bsX[i]+bsCenterX, bsY[i]+bsCenterY);
    }
    curveVertex(bsX[0]+bsCenterX, bsY[0]+bsCenterY);
    
    // end controlpoint
    curveVertex(bsX[1]+bsCenterX, bsY[1]+bsCenterY);
    endShape();


    // ---- start anthony ---- //
  } 
  else if ( millis() - corpseStarted < 20000 ) {

    if (!play2) {
      play2=true;  
      fill(0, 128, 0);
      rect(width / 3.0, 0, width / 3.0, height );
      image(soli, width/3, 0);
    }
    if (play2) {
      image(crd, kPos.x, kPos.y);
      kPos.x+=kVel.x*kScale;
      kPos.y+=kVel.y*kScale;
      kVel.y+=kGrav;

      if (kPos.x<=width/3) {
        kPos.x=(width/3)+1;
        kVel.x*=-.9;
      }
      if (kPos.x+crd.width>=2*width/3) {
        kPos.x=(2*width/3)-crd.width-1;
        kVel.x*=-.9;
      }
      if (kPos.y<=0) {
        kPos.y=1;
        kVel.y*=-.9;
      }
      if (kPos.y+crd.height>=height) {
        kPos.y=height-crd.height-1;
        kVel.y*=-.9;
      }
      noFill();
      stroke(255);    
      rect(width / 3.0, 0, width / 3.0, height );
      fill(255);
    }

    // ---- start person 3 ---- //
  } 
  else if ( millis() - corpseStarted < 30000 ) {    
    fill(255, 255, 255, 50);
    rect(width * 2.0/ 3.0, 0, width / 3.0, height );
    
if (!isInitialized) {
     initialize();
     isInitialized = true;
    }
    stroke(0, 50);
    for (int i=0; i<nbPts-1; i++) {
      for (int j=i+1; j<nbPts; j++) {
        if (dist(x[i], y[i], x[j], y[j])<RADIUS+100) {
          line(x[i], y[i], x[j], y[j]);
          nbConnex[i]++;
          nbConnex[j]++;
        }
      }
    }

    noStroke();
    for (int i=0; i<nbPts; i++) {
      angle[i] += speed[i];
      x[i] = ease(x[i], width * 5/6 + cos(angle[i]) * rad[i], 0.1);
      y[i] = ease(y[i], height/2 + sin(angle[i]) * rad[i], 0.1);
      diam[i] = ease(diam[i], min(nbConnex[i], 7)*(rad[i]/RADIUS), 0.1);
      //Draw Circles
      //        fill(0, 100);
      //        ellipse(x[i], y[i], diam[i] + 16, diam[i] + 16);
      //        fill(0);
      //        ellipse(x[i], y[i], diam[i] + 5, diam[i] + 5);

      nbConnex[i] = 0;
    }


    // ---- we're done! ---- //
  } 
  else {
    sb.send( "doneExquisite", true );
    bDrawing = false;
  }
}

void mousePressed() {
  // for debugging, comment this out!
  sb.send( "doneExquisite", true );
}

void onBooleanMessage( String name, boolean value ) {
  if ( name.equals("startExquisite") ) {
    // start the exquisite corpse process!
    bDrawing = true;
    corpseStarted = millis();
    bNeedToClear = true;
  }
}

void onRangeMessage( String name, int value ) {
  
  println("got range message " + name + " : " + value);
  bsStepSize = map (value, 0, 1023, 0, 20);
  kScale = value/100;
  
}

void onStringMessage( String name, String value ) {
}

float ease(float variable, float target, float easingVal) {
  float d = target - variable;
  if (abs(d)>1) variable+= d*easingVal;
  return variable;
}

