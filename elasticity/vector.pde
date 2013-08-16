class Vector {
  float x, y; // Immutable

  Vector(float px, float py) {
    x = px;
    y = py;
  }

  float getLength() {
    return sqrt(sq(x) + sq(y));
  }

  Vector standardize() {
    // Set the length of the vector to one while keep its direction
    return new Vector(x/getLength(), y/getLength());
  }

  Vector getOpposite() {
    // Set the direction of the vector to its opposite while keep its length
    return new Vector(-x, -y);
  }

  Vector plus(Vector pv) {  
    return new Vector(x + pv.x, y + pv.y);
  }

  Vector minus(Vector pv) {
    return plus(pv.getOpposite());
  }

  Vector times(float scalar) {
    return new Vector(scalar*x, scalar*y);
  }

  Vector dividedBy(float scalar) {
    return times(1/scalar);
  }

  String toString() {
    return "(" + x + ", " + y + ")";
  }
}

