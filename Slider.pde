class Slider{
  
  public int sTextSize = 32;
  public int sThickness = 3;
  public int w = 100;
  public int handleWidth = 10;
  public int handleHeight = 20;
  
  private int x, y;
  private int min, max;
  private float position;
  
  private Action action;
  
  public Slider(int x, int y, int w, Action a){
    this.x = x;
    this.y = y;
    this.w = w;
    this.action = a;
  }
  
  public void update(){
    if(isMouseOver() && mousePressed){
      position = mouseToPosition(mouseX);
    }
  }
  
  public void render(){
    strokeWeight(sThickness);
    stroke(150);
    line(x, y, x+w, y);
    
    strokeWeight(1);
    fill(175);
    if(isMouseOver()){
      fill(200);
    }
    rectMode(CENTER);
    rect(x + getValueX(), y, handleWidth, handleHeight);
  }
  
  public int getValueX(){
    return (int)map(position, 0, 1, x, x+w);
  }
  
  public int mouseToPosition(int x){
    return (int)map(x, x, x+w, 0, 1);
  }
  
  public boolean isMouseOver(){
   return mouseX > x &&
       mouseY > y - handleHeight/2 &&
       mouseX < x+w &&
       mouseY < y + handleHeight/2;
  }
}