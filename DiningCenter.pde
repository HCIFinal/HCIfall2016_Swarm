class DiningCenter{
  public float dcDiameter = 200; 
  public color dcFontColor = color(255);
  public color dcOutlineColor = color(255);
  public int dcFontSize = 20;
  
  private PVector loc;
  private String name;
  
  public DiningCenter(String name, float x, float y, color c){
    this.name = name;
    loc = new PVector(x, y);
    this.dcFontColor = c;
    this.dcOutlineColor = c;
  }
  
  public void setName(String name){
    this.name = name;
  }
    
  public void setLocation(PVector loc){
    this.loc = loc;
  }
  
  public void setLocation(float x, float y){
    setLocation(new PVector(x, y));
  }
  
  public void update(){
    
  }
  
  public void render(){
    fill(dcFontColor);
    textSize(dcFontSize);
    rectMode(CENTER);
    textAlign(CENTER, BOTTOM);
    text(name, loc.x, loc.y - dcDiameter - dcFontSize, dcDiameter - dcFontSize, dcDiameter - dcFontSize);
    noFill();
    strokeWeight(1);
    stroke(dcOutlineColor);
    ellipse(loc.x, loc.y, dcDiameter, dcDiameter);
    ellipse(loc.x, loc.y, dcDiameter+8, dcDiameter+8);
  }
}