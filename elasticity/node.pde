class Node {
  int id;
  float r;  // Radius
  color oc; // Original Color
  color cc; // Current Color
  float m;  // Mass
  Vector s; // Position
  Vector v; // Velocity

  Node(int pid, Vector ps, float pr, color pc, float pm) {
    // Initialize all instance variables
    id = pid;
    r = pr;
    oc = pc;
    cc = pc;
    m = pm;
    s = ps;
    v = new Vector(0, 0);
  }

  void display() {
    // Draw or redraw the node
    fill(cc);
    ellipse(s.x, s.y, r*2, r*2);
    // If mouse is inside the node
    // also print the id of the node
    if (cc != oc) {
      fill(0);
      textAlign(CENTER, CENTER);
      text(id, s.x, s.y);
    }
  }

  boolean contains(Vector ps) {
    // Decide whether the point is in the node
    if (s.minus(ps).getLength() <= r) 
      return true;
    else
      return false;
  }
}

