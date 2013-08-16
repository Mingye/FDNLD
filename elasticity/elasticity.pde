// Configuration Constants
String FILE_PATH = "data.csv";

// Physics Constants
float STIFFNESS = 100; 
float DAMPING = 2;
float G = pow(10, 6);

// Display Constants
color HOVER_COLOR = color(255, 255, 255);
float RADIUS = 10;
float MASS = 1;
float LOWEST_ENERGY = 0.001;

// Global Variables
Node[] nodes; // ArrayList of all nodes
Link[] links; // ArrayList of all links
Node dNode;   // The node that the mouse is dragging
float energy; // The total enery in the system
boolean recalculate; // Whether recalculation is necessary

Node findOrCreateNode(ArrayList tNodes, int id) {
  // Try to find the node in the list
  for (Object tNode : tNodes) {
    Node node = (Node) tNode;
    if (node.id == id)
      return node;
  }
  // Node not found - create new node
  Node node = new Node(id, randomPosition(), RADIUS, randomColor(), MASS);
  tNodes.add(node);
  return node;
}

void setup() {
  // Set the size of the canvas
  size(600, 600);

  // Read the data file
  String[] lines = loadStrings(FILE_PATH);
  // Create a temporary list for nodes
  ArrayList tNodes = new ArrayList();

  // Initialize links
  links = new Link[lines.length];
  for (int i = 0; i < lines.length; i++) {
    String[] tokens = split(lines[i], ",");
    int id1 = int(tokens[0]);
    int id2 = int(tokens[1]);
    float strength = float(tokens[2]);
    Node node1 = findOrCreateNode(tNodes, id1);
    Node node2 = findOrCreateNode(tNodes, id2);
    links[i] = new Link(node1, node2, strength);
  }

  // Initialize nodes
  nodes = new Node[tNodes.size()];
  for (int i = 0; i < tNodes.size(); i++)
    nodes[i] = (Node) tNodes.get(i);

  recalculate = true;
}

void draw() {
  if (recalculate) {
    // Recalculate the position of all nodes
    calculate();
    // Stop recalculating if the total energy is too low
    if (energy < LOWEST_ENERGY)
      recalculate = false;
  }

  // Clear the canvas
  background(255);

  // Display all links and nodes
  for (Link link : links) 
    link.display();
  for (Node node : nodes)
    node.display();

  // Print the total enery to the screen
  fill(180, 120, 60);
  textAlign(LEFT, TOP);
  text("Energy: " + energy, 10, 10);
}

void mouseMoved() {
  // Forget any rememebered node
  // when mouse is not dragging
  dNode = null;

  // Reset the color of all nodes
  for (Node node : nodes)
    node.cc = node.oc;

  // Find the node that the mouse is inside and change its color
  for (Node node : nodes) {
    if (node.contains(new Vector(mouseX, mouseY))) {
      node.cc = HOVER_COLOR;      
      break;
    }
  }
}

void mouseDragged() {
  // If no node is currently remembered,
  // find the node that the mouse is inside and remember it
  if (dNode == null)
    for (Node node : nodes)
      if (node.contains(new Vector(mouseX, mouseY)))
        dNode = node;

  // If any node is remembered, it will be attached the mouse
  // Otherwise, the mouse is dragging outside all nodes
  if (dNode != null) {
    dNode.v = new Vector(0, 0);
    dNode.s = new Vector(mouseX, mouseY);
    // Start recalculating if any node is dragged
    recalculate = true;
  }
}

void calculate() {
  // Initialize local variables
  Vector[] f = new Vector[nodes.length];
  Vector[] g = new Vector[nodes.length];
  Vector[] a = new Vector[nodes.length];

  // Find the time slice before updating anything
  float t = 1/frameRate;

  for (int i = 0; i < nodes.length; i++) {
    Node node = nodes[i];

    // Calculate the sum of universal gravitation
    g[i] = new Vector(0, 0);
    for (int j = 0; j < nodes.length; j++) {
      Node node2 = nodes[j];
      if (i != j) {
        // Note: The universal gravitation here
        //       is changed to universal repulsion force
        g[i] = g[i].plus(getGravity(node, node2).getOpposite());
      }
    }

    // Calculate the sum of elasticity
    f[i] = new Vector(0, 0);
    for (int j = 0; j < links.length; j++) {
      Link link = links[j];
      if (link.ni == node)
        f[i] = f[i].plus(getElasticity(link.ni, link.nj, link));
      else if (link.nj == node)
        f[i] = f[i].plus(getElasticity(link.nj, link.ni, link));
    }

    // Add the forces up and calculate the acceleration accordingly
    a[i] = getAcceleration(f[i].plus(g[i]), node.m);
  }

  // Calculate the new velocity and position based on
  // previous velocity, position and new acceleration
  for (int i = 0; i < nodes.length; i++) {
    Node node = nodes[i];
    if (node != dNode) {
      node.v = getVelocity(node.v, a[i], t);
      node.s = getPosition(node.s, node.v, t);
    }
  }

  // Calculate the total enery in the system
  energy = 0;
  for (Node node : nodes)
    energy += getEnergy(node);
}

