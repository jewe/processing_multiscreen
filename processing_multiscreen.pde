/**
 *  multiscreen / multiwindow
 *  developed with Processing 2.1.1 on OSX 10.9
 */

import processing.video.*; 
import java.awt.Frame; // multiple windows


// multiple windows
PFrame secondFrame, thirdFrame, fourthFrame; 

// first frame / controlframe
XML firstXml;
int fx,fy,w,h;
PShape gui;
ArrayList<Button> buttons;

// video
Movie secondMovie, thirdMovie, fourthMovie;

void setup() {
  println("main setup");
  
  // load settings
  XML xml = loadXML("config.xml");
  firstXml = xml.getChild("firstFrame");
  XML secondXml = xml.getChild("secondFrame");
  XML thirdXml = xml.getChild("thirdFrame");
  XML fourthXml = xml.getChild("fourthFrame");
  
  // first frame settings
  w = firstXml.getInt("width");
  h = firstXml.getInt("height");
  size(w, h); // this command restarts processing of setup()
  
  // this section will be executed only once
  
  // load video
  // (other PApplets loose their data-path)
  secondMovie = new Movie(this, secondXml.getString("source"));
  secondMovie.loop();
  thirdMovie = new Movie(this, thirdXml.getString("source"));
  thirdMovie.loop();
  fourthMovie = new Movie(this, fourthXml.getString("source"));
  fourthMovie.loop();
  
  // position of first frame
  fx = firstXml.getInt("x");
  fy = firstXml.getInt("y");
  frame.setLocation(fx, fy);
  
  // other screens
  println("main setup other screens sections");
  secondFrame = new PFrame(secondXml, secondMovie);
  thirdFrame = new PFrame(thirdXml, thirdMovie);
  fourthFrame = new PFrame(fourthXml, fourthMovie);
  
  // GUI in first frame
  // load svg data to extract button positions
  // layer 2 in svg needs to contain the buttons!
  XML guiXml = loadXML("gui.svg"); 
  XML[] buttonsXml = guiXml.getChildren("g")[1].getChildren("rect");
  //println("xml",buttonsXml);
  
  // xml -> button-arraylist
  buttons = new ArrayList<Button>();
  for (int i = 0; i < buttonsXml.length; i++) {
    int bx = round(buttonsXml[i].getFloat("x"));
    int by = round(buttonsXml[i].getFloat("y"));
    int bw = round(buttonsXml[i].getFloat("width"));
    int bh = round(buttonsXml[i].getFloat("height"));
    String baction = buttonsXml[i].getString("id");
    buttons.add( new Button(bx,by,bw,bh,baction) );
  }
  //println("btn",buttons);
  
  // show svg as image
  gui = loadShape("gui.svg");
  
  // draw control frame one time 
  background(0);
  //image(firstMovie, 0, 0);
  drawGrid("Control Frame");
  shape(gui, 0, 0); 
  
  noLoop();
}

public void init() { 
  println("main init");
  frame.removeNotify(); 
  frame.setUndecorated(true); 
  frame.addNotify(); 
  super.init();
}

void draw() {
  // no loop
}

void movieEvent(Movie m) {
  m.read();
}

/*
boolean sketchFullScreen() {
  return false;
}
*/

// grid for first frame
void drawGrid(String text){
  for (int x=0;x<w;x+=10){
    stroke( (x%100 == 0)? 100: 50);
    line(x,0, x,h);
  }
  for (int y=0;y<h;y+=10){
    stroke( (y%100 == 0)? 100: 50);
    line(0,y, w,y);
  }
  
  fill(200);
  noStroke();
  textSize(20);
  text(text, 30,30);
  textSize(12);
  String params = "x:"+fx+" y:"+fy;
  text(params, 30,50);
  params = "width:"+w+" height:"+h;
  text(params, 30,65);
}

void mouseClicked() {
  // check buttons in buttons-arraylist
  String action = "";
  for (int i = 0;(i<buttons.size()&&action.equals(""));i++) {
    Button button = buttons.get(i);
    action = button.clicked(mouseX,mouseY);
    //println("action", action);    
  }
  
  // process actions
  if (action.equals("Button_1")){
    secondFrame.playVideo();
    thirdFrame.playVideo();
  } else if (action.equals("Button_2")){
    secondFrame.stopVideo();
    thirdFrame.stopVideo();
  } else if (action.equals("Button_3")){
    secondFrame.playVideo();
    thirdFrame.playVideo();
  }  else {
    secondFrame.stopVideo();
    thirdFrame.stopVideo();
  }
}
