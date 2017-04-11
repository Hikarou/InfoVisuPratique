class Board {
  Board() {
    xAngle = 0.0;
    zAngle = 0.0;
  }
  void display(boolean isShiftClicked) {
    fill(118);
    //Add cylinders mode
    if (isShiftClicked) {
      rotateX(-PI/2.0);
    } else {
      rotateX(-xAngle);
      rotateZ(zAngle);
    }
    box(BOX_SIDE, BOX_THICK, BOX_SIDE);
  }
}