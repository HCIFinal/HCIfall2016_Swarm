class Time{
  public int minHour = 6;
  public int maxHour = 24;
  public int framesPerTick = 5;
  public int minutesPerIndex = 15;
  public int timeTextSize = 76;
  public color timeColor = color(255);
  
  private int hour = minHour;
  private int minute = 0;
  private int lastTick = 0;
  
  public void update(){
    if(frameCount-lastTick>framesPerTick){
      tick();
    }
  }
  
  public void tick(){
    lastTick = frameCount;
    minute++;
    if(minute >= 60){
      minute = 0;
      hour++;
    }
    if(hour >= maxHour){
      hour = minHour;
    }
  }
  
  public void render(){
    textSize(timeTextSize);
    textAlign(LEFT, TOP);
    fill(0);
    noStroke();
    rectMode(CORNER);
    rect(10, 10, textWidth(format()), timeTextSize);
    fill(timeColor);
    text(format(),10,10);
  }
  
  public int index(){
    int index = hour*60+minute;
    return index / minutesPerIndex;
  }
  
  public String format(){
    String out = "";
    boolean am = false;
    if(hour >= 0 && hour < 12){
      am = true;
    }
    if(hour < 10 || (hour > 12 && hour - 12 < 10)){
      out += "0";
    }
    
    if(hour == 0){
      out += "12";
    }
    if(hour > 0 && hour <= 12){
      out += hour;
    }
    if(hour > 12){
      out += (hour - 12);
    }
    
    out += ":";
    
    if(minute < 10){
      out += "0";
    }
    out += minute;
    
    out += (am?" am":" pm");
    return out;
  }
}