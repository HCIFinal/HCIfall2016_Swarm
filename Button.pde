class Button{
  
  public int bTextSize = 32;
  public int bRadius = 13;
  
  private int x, y;
  private int w, h;
  private String text;
  private Action action;
  private boolean pressed;
  
  public Button(int x, int y, int w, int h, String text, Action a){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.action = a;
  }
  
  public void setText(String text){
    this.text = text;
  }
  
  public void render(){
    fill(100);
    if(mousePressed && !isMouseOver()){
      pressed = true;
    }
    if(isMouseOver()){
      fill(75);
      if(mousePressed){
        fill(125);
        if(!pressed){
          action.execute();
        }
        pressed = true;
      }
      else{
        pressed = false;
      }
    }
    rectMode(CORNER);
    rect(x, y, w, h, bRadius);
    textAlign(CENTER, CENTER);
    textSize(bTextSize);
    fill(255);
    text(text, x, y-bTextSize/8, w, h);
  }
  
  public boolean isMouseOver(){
    return mouseX > x &&
        mouseY > y &&
        mouseX < x+w &&
        mouseY < y+h;
  }
}