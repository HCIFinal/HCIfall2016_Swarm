class Slider{
  
  public int sTextSize = 32;
  public int sThickness = 3;
  public int w = 100;
  public int handleWidth = 35;
  public int handleHeight = 20;
  
  private int x, y;
  private int min, max;
  private float position;
  
  private Action action;
  private boolean isHeld = false;
  
  public Slider(int x, int y, int w, Action a){
    this.x = x;
    this.y = y;
    this.w = w;
    this.action = a;
  }
  
  public void update(){
    if(isMouseOver() && mousePressed){
      isHeld = true;
    }
    if(!mousePressed){
      isHeld = false;
    }
    if(isHeld){
      //print("B: " + position);
      position = constrain(mouseToPosition(mouseX),0,1);
      action.execute();
      //println("\tA: " + position);
    }
  }
  
  public void render(){
    strokeWeight(sThickness);
    stroke(100);
    line(x, y, x+w, y);
    
    noStroke();
    fill(100);
    if(isMouseOver()){
      fill(75);
    }
    if(isHeld){
      fill(125);
    }
    rectMode(CENTER);
    rect(getValueX(), y, handleWidth, handleHeight);
    strokeWeight(1);
    stroke(150);
    for(int i=0;i<3;i++){
      int _x = i*3;
      int _yt = y - handleHeight/2 + 2;
      int _yb = y + handleHeight/2 - 2;
      line(getValueX() - 3 + _x, _yt, getValueX() - 3 + _x, _yb); 
    }
  }
  
  public void setPosition(float pos){
    this.position = pos;
  }
  
  public float getPosition(){
    return position;
  }
  
  public int getValueX(){
    return (int)map(position, 0, 1, x, x+w);
  }
  
  public float mouseToPosition(int mousex){
    return map(mousex, x, x+w, 0, 1);
  }
  
  public boolean isMouseOver(){
   return mouseX > x &&
       mouseY > y - handleHeight/2 &&
       mouseX < x+w &&
       mouseY < y + handleHeight/2;
  }
}