import spacebrew.*;

PImage soli;
PImage crd;
PVector pos;
PVector vel;
float grav;

// Spacebrew stuff
String server = "sandbox.spacebrew.cc";
String name   = "ExquisiteCorpse_YOUR_NAME_HERE!";
String desc   = "Some stuff";

Spacebrew sb;

// App Size: you should decide on a width and height
// for your group
int appWidth  = 1280;
int appHeight = 720;

// EC stuff
int corpseStarted   = 0;
boolean bDrawing    = false;
boolean bNeedToClear = false;
boolean play2=false;

//Part 3 Variables
float[] angle, rad, speed, x, y, diam;
int[] nbConnex;
int nbPts;
final static int RADIUS = 30;
boolean isInitialized;

void setup() {
  size( appWidth, appHeight );
  smooth();

  sb = new Spacebrew(this);
  sb.addPublish("doneExquisite", "boolean", false);
  sb.addSubscribe("startExquisite", "boolean");

  // add any of your own subscribers here!

  sb.connect( server, name, desc );

  soli = loadImage("soli.png");
  crd  = loadImage("crd.png");
  pos = new PVector(685, 8);
  vel = new PVector(-5, -1);
  grav = .6;
  
  isInitialized = false;
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
    background(0); // feel free to change the background color!
  }


  // ---- start person 1 ---- //
  
  if ( millis() - corpseStarted < 10000 ) {
    noFill();
    stroke(255);
    rect(0, 0, width / 3.0, height );
    
    // ---- start person 2 ---- //
  } 
  else if ( millis() - corpseStarted < 20000 ) {

    if (!play2) {
      play2=true;  
      fill(0, 128, 0);
      rect(width / 3.0, 0, width / 3.0, height );
      image(soli, width/3, 0);
    }
    if (play2) {
      image(crd, pos.x, pos.y);
      pos.x+=vel.x;
      pos.y+=vel.y;
      vel.y+=grav;

      if (pos.x<=width/3) {
        pos.x=(width/3)+1;
        vel.x*=-.9;
      }
      if (pos.x+crd.width>=2*width/3) {
        pos.x=(2*width/3)-crd.width-1;
        vel.x*=-.9;
      }
      if (pos.y<=0) {
        pos.y=1;
        vel.y*=-.9;
      }
      if (pos.y+crd.height>=height) {
        pos.y=height-crd.height-1;
        vel.y*=-.9;
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
}

void onStringMessage( String name, String value ) {
}

float ease(float variable, float target, float easingVal) {
  float d = target - variable;
  if (abs(d)>1) variable+= d*easingVal;
  return variable;
}

