class Time{
  public int minHour = 7;
  public int maxHour = 24;
  public int framesPerTick = 15;
  public int minutesPerIndex = 15;
  public int timeTextSize = 76;
  public color timeColor = color(255,255,255);
  public int textWidth;
  
  private int hour = minHour;
  private int minute = 0;
  private int lastTick = 0;
  private boolean paused = false;
  
  private Slider timeSlider;
  
  public Time(){
    timeSlider = new Slider(10,130,350,new Action(){
      public void execute(){
        float pos = timeSlider.getPosition();
        int min = minHour * 60;
        int max = maxHour * 60 - 1;
        int newTime = (int)map(pos, 0, 1, min, max);
        hour = newTime / 60;
        minute = newTime % 60;
      }
    });
  }
  
  public void pause(){
    paused = true;
  }
  
  public void resume(){
    paused = false;
  }
  
  public String nextSpeed(){
   if(framesPerTick==15){
   speed2x();
   return "2x";
   }
   else if (framesPerTick==7){
    speed4x(); 
    return"4x";
   }
   else{
    speed1x(); 
    return"1x";
   }
  }
  
  public void speed1x(){
    framesPerTick = 15;
  }
  public void speed2x(){
    framesPerTick = 7;
  }
  public void speed4x(){
    framesPerTick = 4;
  }
  
  public boolean isPaused(){
    return paused;
  }
  
  public void update(){
    if(!paused && frameCount-lastTick>framesPerTick){
      tick();
    }
    timeSlider.update();
  }
  
  private void tick(){
    lastTick = frameCount;
    minute++;
    if(minute >= 60){
      minute = 0;
      hour++;
    }
    if(hour >= maxHour){
      hour = minHour;
    }
    
    //move the slider
    int min = minHour * 60;
    int max = maxHour * 60 - 1;
    int time = hour * 60 + minute;
    float newPos = map(time, min, max, 0, 1);
    timeSlider.setPosition(newPos);
  }
  
  public void render(){
    textSize(timeTextSize);
    textAlign(LEFT, TOP);
    fill(0);
    
    noStroke();
    rectMode(CORNER);
    rect(5, 5, textWidth(format()) + 10, timeTextSize + 60);
    fill(timeColor);
    text(format(),10,10);
    
    timeSlider.render();
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