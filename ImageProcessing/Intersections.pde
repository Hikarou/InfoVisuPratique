ArrayList<PVector> getIntersections(List<PVector> lines) {
  QuadGraph graph = new QuadGraph();
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);
      // compute the intersection and add it to 'intersections'
      PVector intersection = graph.intersection(line1, line2);
      intersections.add(intersection);
    }
  }
  return intersections;
}

void drawIntersections(ArrayList<PVector> intersections) {
  for (PVector i : intersections) {
    fill(255, 128, 0);
    ellipse(i.x, i.y, 10, 10);
  }
}

ArrayList<int[]> getQuad(ArrayList<PVector> lines, int imgWidth, int imgHeight) {
  QuadGraph graph = new QuadGraph();
  graph.build(lines, imgWidth, imgHeight);
  graph.findCycles(false);
  ArrayList<int[]> validQuads = new ArrayList<int[]>();
  for (int[] quad : graph.cycles) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    PVector c12 = graph.intersection(l1, l2);
    PVector c23 = graph.intersection(l2, l3);
    PVector c34 = graph.intersection(l3, l4);
    PVector c41 = graph.intersection(l4, l1);
    if (graph.isConvex(c12, c23, c34, c41) &&
        graph.validArea(c12, c23, c34, c41, imgWidth*imgHeight, (imgWidth*imgHeight)/100) != 0 && 
        graph.nonFlatQuad(c12, c23, c34, c41)) {
      validQuads.add(quad);
    }
  }
  return validQuads;
}

void drawQuads(List<int[]> quads, ArrayList<PVector> lines) {
  QuadGraph graph = new QuadGraph();
  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    PVector c12 = graph.intersection(l1, l2);
    PVector c23 = graph.intersection(l2, l3);
    PVector c34 = graph.intersection(l3, l4);
    PVector c41 = graph.intersection(l4, l1);
    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 50));
    quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
  }
}