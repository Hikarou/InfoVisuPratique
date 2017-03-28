class Mover {
  private PVector location;
  private PVector velocity;
  private PVector gravityForce; // Gravity vector.
  private PVector friction;     // Friction vector.
  private final float frictionMagnitude = 0.01;
  Mover() {
    location = new PVector(0, - BALL_RADIUS, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
  }
  void update() {
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    gravityForce.set(sin(zAngle)*GRAVITY.y, 0, sin(xAngle)*GRAVITY.y);
    velocity.add(gravityForce);
    velocity.add(friction);
    location.add(velocity);
  }
  void display() {
    pushMatrix();
    noStroke();
    fill(255);
    translate(location.x, -BALL_RADIUS, location.z);
    sphere(BALL_RADIUS);
    popMatrix();
  }
  void checkEdges() {
    if (location.x > BOX_SIDE/2) {
      velocity.x = velocity.x * -1.;
      location.x = BOX_SIDE/2;
    } else if (location.x < -BOX_SIDE/2) {
      velocity.x = velocity.x * -1.;
      location.x = -BOX_SIDE/2;
    }
    if (location.z > BOX_SIDE/2) {
      velocity.z = velocity.z * -1.;
      location.z = BOX_SIDE/2;
    } else if (location.z < -BOX_SIDE/2) {
      velocity.z = velocity.z * -1.;
      location.z = -BOX_SIDE/2;
    }
  }
  
  void checkCylinderCollision(Cylinder cylinder){
     PVector Vdist = new PVector(location.x - cylinder.location.x, location.z - cylinder.location.z);
     float distance = Vdist.mag();
     if(distance <= BALL_RADIUS + cylinder.cylinderRadius){
       location.x = location.x + Vdist.x  / (BALL_RADIUS+cylinder.cylinderRadius);
       location.z = location.z + Vdist.z / (BALL_RADIUS+cylinder.cylinderRadius);
       PVector normal = new PVector(location.x - cylinder.location.x, 0, location.z - cylinder.location.z).normalize();
       velocity = PVector.sub(velocity, normal.mult(PVector.dot(velocity, normal) * 2));
     }
}
}