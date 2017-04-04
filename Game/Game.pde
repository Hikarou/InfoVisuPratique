private final float MAX_ANGLE = PI/3.0;
private final float MIN_SPEED = 0.2;
private final float MAX_SPEED = 1.5;
private float speed;
private float xAngle;
private float zAngle;
private Board board;
private Mover mover;
private ArrayList<Cylinder> cylinderList;
private PGraphics bgScore;
private PGraphics topView;
private PGraphics scoreBoard;
private PGraphics barChart;
private HScrollbar hs;
private BarChart bc;
private PGraphics bcPg;
private ArrayList<Float> score;
//private final float GRAPH_POINTS_WIDTH_FULL = 5;
//private final float GRAPH_POINTS_HEIGHT = 2.5;
private final PVector GRAVITY = new PVector(0, 0.981, 0);
private final float BALL_RADIUS = 20;
private final float BOX_SIDE = 500;
private final float BOX_THICK = 10;
private final int DISPLAY_SCORE_HEIGHT = 160;
private final int UPDATE_RATE = 5;
private int MAX_ENTRIES;
private boolean changedScroll;
private int lastDrawn;

void settings() {
  fullScreen();
  size(displayWidth, displayHeight, P3D);
}

void setup() {
  noStroke();
  lights();
  //creating variables
  xAngle = zAngle = 0;
  speed = 1;
  score = new ArrayList();
  //Start with value 0 to begin at a correct score
  score.add(0.);
  score.add(0.);
  board = new Board();
  mover = new Mover();
  cylinderList = new ArrayList<Cylinder>();
  bgScore = createGraphics(width, DISPLAY_SCORE_HEIGHT, P2D);
  topView = createGraphics(DISPLAY_SCORE_HEIGHT - 20, DISPLAY_SCORE_HEIGHT - 20, P2D);
  scoreBoard = createGraphics(DISPLAY_SCORE_HEIGHT - 20, DISPLAY_SCORE_HEIGHT - 20, P2D);
  hs = new HScrollbar(2 * DISPLAY_SCORE_HEIGHT + 3 * 10, height - 35, width - 2 * DISPLAY_SCORE_HEIGHT - 2 * 20, 25);
  bc = new BarChart (width - 2 * DISPLAY_SCORE_HEIGHT - 2 * 20, DISPLAY_SCORE_HEIGHT - 55);
  MAX_ENTRIES = (width - 2 * DISPLAY_SCORE_HEIGHT - 2 * 20) / 2;
  changedScroll = true;
  lastDrawn = 0;
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
  drawBgScore();
  image(bgScore, 0, height - bgScore.height);
  drawTopView();
  image(topView, 10, height - topView.height - 10);
  drawScore();
  image(scoreBoard, DISPLAY_SCORE_HEIGHT - 10, height - topView.height - 10);
  hs.update();
  hs.display();
  bc.update();
  image(bc.graphic, 2 * DISPLAY_SCORE_HEIGHT + 30, height - topView.height - 10);
  directionalLight(50, 100, 125, 1, 1, 1);
  ambientLight(120, 120, 120);
  adjustParameters();

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
  if (!isShiftClicked() && !hs.locked) {
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

void drawBgScore() {
  bgScore.beginDraw();
  bgScore.background(204, 204, 153);
  bgScore.endDraw();
}

void drawScore() {
  scoreBoard.beginDraw();
  scoreBoard.background(204, 204, 153);
  scoreBoard.text("Total Score :\n" + score.get(score.size() - 1) + "\n\nVelocity :\n" + mover.velocity.mag() + 
    "\n\nLast Score :\n" + score.get(score.size() - 2), 10, 10);
  scoreBoard.endDraw();
}

void drawTopView() {
  topView.beginDraw();
  topView.background(0, 51, 255);
  float xPos = topView.width/2 + (mover.location.x * (topView.width*1. / BOX_SIDE));
  float yPos = topView.height/2 + (mover.location.z * (topView.height*1. / BOX_SIDE));
  topView.fill(255, 0, 0);
  topView.ellipse(xPos, yPos, BALL_RADIUS/2, BALL_RADIUS/2);
  topView.fill(255);
  for (Cylinder c : cylinderList) {
    float c_xPos = topView.width/2 + (c.location.x * (topView.width*1.0 / BOX_SIDE));
    float c_yPos = topView.height/2 + (c.location.z * (topView.height*1.0 / BOX_SIDE));
    topView.ellipse(c_xPos, c_yPos, c.cylinderRadius/2, c.cylinderRadius/2);
  }
  topView.endDraw();
}

void drawGraph() {
  barChart.beginDraw();

  barChart.endDraw();
}