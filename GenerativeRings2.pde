boolean RECORD = false;
int N_OF_RINGS = 9;
int RING_SEPARATION = 8;
float startRadius = 35;

Ring[] rings;

void setup() {
  size(1060, 1060, P3D);
  //fullScreen(P3D);
  //smooth(8);

  reset();
}

void draw() {  
  for (int i = 0; i < N_OF_RINGS; i++)
    rings[i].draw();
  
  if(RECORD)
    saveFrame("frames/####.png");
}

void reset() {
  background(240);

  PVector origin = new PVector(width/2.0, height/2.0);
  //PVector origin = new PVector(0, 0);

  rings = new Ring[N_OF_RINGS];

  float innerRadius = startRadius;
  float outerRadius = innerRadius + RING_SEPARATION;
  
  rings[0] = new Ring(origin.x, origin.y, innerRadius, outerRadius, 960);

  for (int i = 1; i < N_OF_RINGS; i++)
    rings[i] = new Ring(rings[i-1]);
}

void mousePressed() {
  reset();
}

void keyPressed() {
  if (key == 's')
    saveFrame("captures/####.png");
}
