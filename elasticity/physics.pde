float getDistance(Node ni, Node nj) {
  // The distance between node i and node j
  return nj.s.minus(ni.s).getLength();
}

Vector getUnitVector(Node ni, Node nj) {
  // The unit vector from node i to node j
  return nj.s.minus(ni.s).standardize();
}

Vector getGravity(Node ni, Node nj) {
  // Newton's law of universal gravitation
  // F = G * m1 * m2 / r^2
  // G: gravitational constant
  float r = getDistance(ni, nj);
  float gscalar = G*ni.m*nj.m/sq(r);
  return getUnitVector(ni, nj).times(gscalar);
}

Vector getElasticity(Node ni, Node nj, Link link) {
  // Hooke's law (Mass-Spring-Damper)
  // F = - k * x - c * v
  // k: spring constant (STIFFNESS)
  // c: damping coefficient (DAMPING)
  float x = getDistance(ni, nj) - link.strength;
  Vector deformation = getUnitVector(nj, ni).times(x);
  return deformation.times(-STIFFNESS).plus(ni.v.times(-DAMPING));
}

Vector getAcceleration(Vector f, float m) {
  // a = F / m
  return f.dividedBy(m);
}

Vector getVelocity(Vector v, Vector a, float t) {
  // v_t = v_0 + a * t
  return v.plus(a.times(t));
}

Vector getPosition(Vector s, Vector v, float t) {
  // s_t = s_0 + v * t
  return s.plus(v.times(t));
}

float getEnergy(Node n) {
  // Kinetic energy of rigid bodies
  // E = 1/2 * m * v^2
  return 0.5*n.m*sq(n.v.getLength());
}
