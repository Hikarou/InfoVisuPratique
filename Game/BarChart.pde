class BarChart { 
  private final int BARCHART_WIDTH, BARCHART_HEIGHT, SLOT_WIDTH, NUM_SLOTS;
  private final color COLOUR;
  private ArrayList<Float> scoreRecap; 
  private PGraphics graphic;

  //A Revoir...
  BarChart(int barChartWidth, int barCharHeight) {
    scoreRecap = new ArrayList<Float>(); 
    scoreRecap.add(0.);
    BARCHART_WIDTH = barChartWidth;
    BARCHART_HEIGHT = barCharHeight;
    SLOT_WIDTH = BARCHART_HEIGHT/20;
    COLOUR = color(246, 229, 160);
    NUM_SLOTS = BARCHART_WIDTH/SLOT_WIDTH;
    graphic = createGraphics(BARCHART_WIDTH, BARCHART_HEIGHT, P2D);
  }

  void update() {
    graphic.beginDraw();
    float widthRect = map(hs.sliderPosition, hs.sliderPositionMin, hs.sliderPositionMax, 2, 10);
    //Limite le nombre de dessins
    if (changedScroll) {
      graphic.background(COLOUR);
      for (int x = 0; x < scoreRecap.size(); x++) {
        //draw bar ith
        graphic.pushMatrix();
        graphic.translate(x*widthRect, 0);
        for (int y = 0; y < Math.min((int)(java.lang.Math.ceil(scoreRecap.get(x))/20), 21); y++) {
          graphic.pushMatrix();
          graphic.translate(0, BARCHART_HEIGHT-(y*SLOT_WIDTH));
          drawSquaredCell(widthRect);
          graphic.popMatrix();
        }
        graphic.popMatrix();
      }
      changedScroll = false;
    } else if (mover.collisionCounter == 0){
      //To reduce number of writing processing
      int drawUntil = scoreRecap.size();
      for (int x = lastDrawn; x < drawUntil; x++) {
        graphic.pushMatrix();
        graphic.translate(x*widthRect, 0);
        for (int y = 0; y < Math.min((int)(java.lang.Math.ceil(scoreRecap.get(x))/20), 21); y++) {
          graphic.pushMatrix();
          graphic.translate(0, BARCHART_HEIGHT-(y*SLOT_WIDTH));
          drawSquaredCell(widthRect);
          graphic.popMatrix();
        }
        graphic.popMatrix();
      }
    }
    graphic.endDraw();
  }
  void drawSquaredCell(float widthRect) {
    graphic.stroke(color(255));
    graphic.strokeWeight(1);
    graphic.fill(color(70, 50, 200));
    graphic.rect(SLOT_WIDTH/2, SLOT_WIDTH/2, widthRect, SLOT_WIDTH);
  }
}