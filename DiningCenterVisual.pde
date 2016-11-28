//---visual settings----
public color bgColor = color(0, 255);
public String[] dcNames = {"Residence", "Union", "West"};
public color[] dcColors = {color(0,255,255), color(255,0,255), color(255,255,0)};
public int peoplePerNode = 5;

private DiningCenter[] dc = new DiningCenter[3];
private ArrayList<Node>[] nodes = new ArrayList[3];
private Time time = new Time();
private int lastIndex = -1;
private float[][] data = new float[3][24*60/time.minutesPerIndex];

private Button pauseButton;
private Button speedButton;
private Slider timeSlider;

void setup(){
  size(900,900);
  //read text file for daily data
  String[] lines = loadStrings("times.txt");
  for(int j=0;j<lines.length;j++){
    if(j==0){
      //skip the first line, it is only headers.
      continue;
    }
    String[] numbers = lines[j].split("\t");
    for(int i=0;i<data.length;i++){
      data[i][j-1] = Float.parseFloat(numbers[i]);
    }
  }
  
  //create the three dining center objects
  for(int i=0;i<dc.length;i++){
    float t = (float) i / dc.length * TWO_PI;
    dc[i] = new DiningCenter(dcNames[i], width/2 + cos(t) * width/4, height/2 - sin(t) * (height-time.timeTextSize)/4 + time.timeTextSize/2, dcColors[i]);
  }
  
  //create node array lists for future population
  for(int i=0;i<nodes.length;i++){
    nodes[i] = new ArrayList<Node>();
  }
  
  ////populate random nodes within each arraylist
  //for(int i=0;i<nodes.length;i++){
  //  for(int j=0;j<100;j++){
  //    Node n = new Node(random(width), random(height));
  //    nodes[i].add(n);
  //    n.setTarget(dc[i].loc);
  //    n.nodeColor = dc[i].dcOutlineColor;
  //  }
  //}
  
  setupControls();
}

void draw(){
  //draw the background slightly opaque
  fill(0, 30);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height);
  
  //update and render each dining center
  for(int i=0;i<dc.length;i++){
    dc[i].update();
    dc[i].render();
  }
  //update and render each node
  for(int i=0;i<nodes.length;i++){
    for(Node n : nodes[i]){
      n.update();
      n.render();
    }
  }
  //update and render the clock
  time.update();
  time.render();
  
  //balance arrays based off of clock if we havent already
  int index = time.index();
  if(lastIndex != index){
    balanceArrays(data[0][index],data[1][index],data[2][index]);
    lastIndex = index;
  }
  
  pauseButton.render();
  speedButton.render();
  timeSlider.update();
  timeSlider.render();
}

void balanceArrays(float l1, float l2, float l3){
  //calcualte target balance percentages
  int t = (int)(l1 + l2 + l3);
  int neededNodes = (int) t / peoplePerNode;
  int[] target = {(int)(l1 / t * neededNodes), 
        (int)(l2 / t * neededNodes),
        (int)(l3 / t * neededNodes)};
  //for each (potentially) unballanced array
  for(int i=0;i<3;i++){
    if(nodes[i].size() > target[i]){
      //we have too many nodes, try to move them.
      boolean moved = false;
      //search for a target dining center
      for(int j=0;j<3;j++){
        if(i==j) continue;
        while(nodes[i].size() > target[i] && nodes[j].size() < target[j]){
          //found one, move one here
          Node removed = nodes[i].remove(0);
          //update target, color and add it to new list
          removed.setTarget(dc[j].loc);
          removed.nodeColor = dc[j].dcOutlineColor;
          nodes[j].add(removed);
          moved = true;
        }
      }
      //if we never moved any, then delete the nodes.
      if(!moved){
        while(nodes[i].size() > target[i]){
          //found one, delete it.
          Node removed = nodes[i].remove(0);
        }
      }
    }
  }
  //after balancing, see if we need to add any more nodes to the display.
  for(int i=0;i<3;i++){
    while(nodes[i].size() < target[i]){
      Node n = new Node(dc[i].loc.x - dc[i].dcDiameter/2 + random(dc[i].dcDiameter), dc[i].loc.y - dc[i].dcDiameter/2 + random(dc[i].dcDiameter));
      n.setTarget(dc[i].loc);
      n.nodeColor = dc[i].dcOutlineColor;
      nodes[i].add(n);
    }
    
    println(dcNames[i] + ": Target(" + target[i] + "), Actual(" + nodes[i].size() + ")");
  }
}

//if mouse is pressed, crudely reassign the nodes to other dining centers
void mousePressed(){
  //read text file for daily data
  String[] lines = loadStrings("times.txt");
  for(int j=0;j<lines.length;j++){
    if(j==0){
      //skip the first line, it is only headers.
      continue;
    }
    String[] numbers = lines[j].split("\t");
    for(int i=0;i<data.length;i++){
      data[i][j-1] = Float.parseFloat(numbers[i]);
    }
  }
}

void setupControls(){
  pauseButton = new Button(470,10,120,50, "Pause", new Action(){
  
    public void execute(){
      if(time.isPaused()){
        pauseButton.setText("Pause");
        time.resume();
      }
      else{
        pauseButton.setText("Play");
        time.pause();
      }
    }
  });
  speedButton = new Button(470,70,120,50,"1x", new Action(){
    public void execute(){
      speedButton.setText(time.nextSpeed());
    }
  });
  timeSlider = new Slider(10,100,200,null);
}