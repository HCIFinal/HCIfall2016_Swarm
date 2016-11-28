class Node{
  public float nodeDiameter = 5;
  public color nodeColor = color(0,0,255);
  public float maxAcceleration = .15;
  public float maxSpeed = 5;
  public float maxRepel = 1;
  
  private PVector loc, vel, acc, target;
  
  public Node(float x, float y){
    this.loc = new PVector(x, y);
    this.vel = new PVector(0, 0);
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