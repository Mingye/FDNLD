color randomColor() {
  int r = int(random(256));
  int g = int(random(256));
  int b = int(random(256));
  return color(r, g, b);
}

Vector randomPosition() {
  int x = int(random(width));
  int y = int(random(height));
  return new Vector(x, y);
} 
