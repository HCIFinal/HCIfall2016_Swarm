//---visual settings----
public color bgColor = color(0, 255);
public String[] dcNames = {"Residence", "Union", "West"};
public color[] dcColors = {color(0,255,255), color(255,0,255), color(255,255,0)};
public int peoplePerNode = 2;

private DiningCenter[] dc = new DiningCenter[3];
private ArrayList<Node>[] nodes = new ArrayList[3];
private Time time = new Time();
private int lastIndex = -1;
private float[][] data = new float[3][24*60/time.minutesPerIndex];
private boolean showNumbers = true;

private Button pauseButton;
private Button speedButton;

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
    dc[i] = new DiningCenter(dcNames[i], width/2 + cos(t) * width/4, height/2 - sin(t) * (height-time.timeTextSize)/4 + time.timeTextSize, dcColors[i]);
  }
  
  //create node array lists for future population
  for(int i=0;i<nodes.length;i++){
    nodes[i] = new ArrayList<Node>();
  }
  
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
    if(showNumbers){
      dc[i].setName(dcNames[i] + "\n" + (int)(data[i][time.index()]) + " People");
    }
    dc[i].render();
  }
  //update and render each node
  for(int i=0;i<nodes.length;i++){
    for(Node n : nodes[i]){
      //if(!time.isPaused())
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
  
  //draw the legend
  fill(255);
  textAlign(RIGHT, BOTTOM);
  textSize(28);
  text("1 node represents " + peoplePerNode + " People", width-25, height-25);
}

void balanceArrays(float l1, float l2, float l3){
  //calcualte target balance percentages
  //float t = (l1 + l2 + l3);
  //int neededNodes = (int) t / peoplePerNode;
  //println(neededNodes);
  int[] target = {(int)(l1 / peoplePerNode ), 
        (int)(l2 / peoplePerNode ),
        (int)(l3 / peoplePerNode )};
  println(target[0] + " " + target[1] + " " + target[2]);
  //for each (potentially) unballanced array
  for(int i=0;i<3;i++){
    if(nodes[i].size() > target[i]){
      //we have too many nodes, try to move them.
      boolean moved = false;
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
      Node n = new Node(dc[i].loc.x - dc[i].dcDiameter/2 + random(dc[i].dcDiameter*.8), dc[i].loc.y - dc[i].dcDiameter/2 + random(dc[i].dcDiameter*.8), random(-2,2), random(-2,2));
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

void keyPressed(){
  
}

void keyReleased(){
}

void setupControls(){
  pauseButton = new Button(width-170-10,10,170,50, "Pause", new Action(){
  
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
  speedButton = new Button(width-170-10,70,170,50,"Speed: 1x", new Action(){
    public void execute(){
      speedButton.setText(time.nextSpeed());
    }
  });
}