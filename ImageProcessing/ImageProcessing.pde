import java.util.Collections;
import java.util.Arrays;

final String toPrintName = "board1.jpg";
PImage img,imgToPrint;

void settings() { size(1200, 300); }

void setup() {
  img = loadImage(toPrintName);
  imgToPrint = loadImage(toPrintName);
  noLoop();
}

void draw() {  
  PImage result = hueThreshold(img, 101, 144); 
  result = gaussianBlur(result);        
  result = gaussianBlur(result);
  result = gaussianBlur(result);
  result = brightnessThreshold(result,253);
  BlobDetection b = new BlobDetection(result);
  PImage blob = b.findConnectedComponents(true);
  result = scharr(blob);
  PImage edge = brightnessThreshold(result,40);
 
  imgToPrint.resize(400, 300);
  image(imgToPrint, 0, 0);
  blob.resize(400, 300);
  edge.resize(400, 300);

  HoughAlgorithm h = new HoughAlgorithm(edge);
  ArrayList<PVector> linesIntersection = h.hough(4);
  
  ArrayList<int[]> quads = getQuad(linesIntersection, edge.width, edge.height);
  ArrayList<PVector> linesToDraw = new ArrayList<PVector>();

  //We select only the first quad or drawing...
  if (quads.size() > 0) {
    for (int i : quads.get(0)) {
      linesToDraw.add(linesIntersection.get(i));
    }
    drawBorderLines(linesToDraw, blob.width);
    ArrayList<PVector> intersections = getIntersections(linesToDraw);
    drawIntersections(intersections);
    drawQuads(Collections.singletonList(quads.get(0)), linesIntersection);
  }

  image(blob, 400, 0);
  image(edge, 800, 0);
}