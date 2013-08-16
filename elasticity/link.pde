class Link {
  Node ni, nj;    // Node i & Node j
  float strength; // Strength of the link between Node i & Node j

  Link(Node pni, Node pnj, float pstrength) {
    // Initialize all instance variables
    ni = pni;
    nj = pnj;
    strength = pstrength;
  }

  void display() {
    // Draw or redraw the link
    line(ni.s.x, ni.s.y, nj.s.x, nj.s.y);
  }
}

