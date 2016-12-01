class Node{
  public float nodeDiameter = 5;
  public float maxAcceleration = .12;
  public float maxSpeed = 4;

  private PVector loc, vel, acc, target;
  private color nodeColor = color(0,0,255);
  
  public Node(float x, float y, float dx, float dy){
    this.loc = new PVector(x, y);
    this.vel = new PVector(dx, dy);
    this.acc = new PVector(0, 0);
    this.target = loc;
  }
  
  public void setTarget(PVector target){
    this.target = target;
  }
  
  public void update(){
    acc.add(PVector.sub(target, loc));
    acc.limit(maxAcceleration);
    vel.add(acc);
    vel.limit(maxSpeed);
    loc.add(vel);
  }
  
  public void render(){
    stroke(nodeColor);
    fill(nodeColor);
    ellipseMode(CENTER);
    ellipse(loc.x, loc.y, nodeDiameter, nodeDiameter);
  }
}