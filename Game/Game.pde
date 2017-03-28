private final float MAX_ANGLE = PI/3.0;
private final float MIN_SPEED = 0.2;
private final float MAX_SPEED = 1.5;
private float speed;
private float xAngle;
private float zAngle;
private Board board;
private Mover mover;
private ArrayList<Cylinder> cylinderList;
private final PVector GRAVITY = new PVector(0, 0.981, 0);
private final float BALL_RADIUS = 48;
private final float BOX_SIDE = 500;
private final float BOX_THICK = 10;

void settings() {
  //fullScreen();
  size(displayWidth, displayHeight, P3D);
}

void setup() {
  noStroke();
  lights();
  //creating variables
  xAngle = zAngle = 0;
  speed = 1;
  board = new Board();
  mover = new Mover();
  cylinderList = new ArrayList<Cylinder>();
}

void draw() {
  //set scene elements
  camera();
  background(255);

  /* for debug purpose
   textSize(32);
   fill(0, 102, 153);
   text("xAngle : " + xAngle + ", zAngle = " + zAngle + ", speed : " + speed, 10, 60);
   // */
  directionalLight(50, 100, 125, 1, 1, 1);
  ambientLight(120, 120, 120);
  adjustParameters();

  //transformations to the scene
  //translate(width/2, height/2, 0);
  //rotateX(-xAngle);
  //rotateZ(zAngle);
  board.display(isShiftClicked());
  for (Cylinder c : cylinderList) {
    c.display();
  }
  if (!isShiftClicked()) {
    mover.update();
    mover.checkEdges();
    for (Cylinder c : cylinderList) {
      mover.checkCylinderCollision(c);
    }
  }
  mover.display();
}

void mouseDragged() {
  if (!isShiftClicked()) {
    zAngle += map(mouseX - pmouseX, -width/2, width/2, -MAX_ANGLE, MAX_ANGLE)*speed;
    xAngle += map(mouseY - pmouseY, -height/2, height/2, -MAX_ANGLE, MAX_ANGLE)*speed;
  }
}

void mouseClicked() {
  if (isShiftClicked()) {
    Cylinder cylinder = new Cylinder(mouseX, -BOX_THICK/2, mouseY);
    if (cylinder.checkBorder() && !cylinder.isOverlap(cylinderList)) {
      cylinderList.add(cylinder);
    }
  }
}

boolean isShiftClicked() {
  return (keyPressed == true && keyCode == SHIFT);
}

void mouseWheel(MouseEvent e) {
  speed += -0.1 * e.getCount();
}

//keeping inside the boundries
void adjustParameters() {
  speed = Math.max(Math.min(speed, MAX_SPEED), MIN_SPEED);
  zAngle = Math.max(Math.min(zAngle, MAX_ANGLE), -1*MAX_ANGLE);
  xAngle = Math.max(Math.min(xAngle, MAX_ANGLE), -1*MAX_ANGLE);
} 