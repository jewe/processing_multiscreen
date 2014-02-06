import javax.swing.JFrame;

public class PFrame extends JFrame {
  secondApplet s;
  XML frameXml;
  int fx,fy,w,h;
  
  public PFrame(XML _xml, Movie secondMovie) {
    //println("PFrame ", _xml);
    frameXml = _xml;
    
    fx = frameXml.getInt("x");
    fy = frameXml.getInt("y");
    w = frameXml.getInt("width");
    h = frameXml.getInt("height");
    
    setUndecorated(true);
    setBounds(fx, fy, w, h);
    
    // new applet inside
    s = new secondApplet();
    add(s);
    s.init();
    s.setupVideo(secondMovie); // secondApplet has no path to data 
    s.injectXml(frameXml);
    show();
  }
  
  void playVideo(){
    s.playVideo();
  }
  void stopVideo(){
    s.stopVideo();
  }
  
}

public class secondApplet extends PApplet {
  Movie secondMovie;
  XML xml;
  int fx,fy, w,h;
  
  public void setup() {
    //println("setup 2");
  }
  
  public void setupVideo(Movie _secondMovie){
    //println("setupVideo", _secondMovie);
    secondMovie = _secondMovie;
  }
  
  public void injectXml(XML _xml){
    xml = _xml;
    fx = xml.getInt("x");
    fy = xml.getInt("y");
    w = xml.getInt("width");
    h = xml.getInt("height");
  }
  
  public void draw() {
    background(0);
    image(secondMovie, 0, 0);
    drawGrid2();
  }
  
  void playVideo(){
    secondMovie.play();
  }
  void stopVideo(){
    secondMovie.stop();
  }
  
  void drawGrid2(){
    for (int x=0;x<width;x+=10){
      stroke( (x%100 == 0)? 100: 50);
      line(x,0, x,h);
    }
    for (int y=0;y<height;y+=10){
      stroke( (y%100 == 0)? 100: 50);
      line(0,y, w,y);
    }
    
    fill(200);
    noStroke();
    textSize(20);
    text(xml.getName(), 30,30);
    textSize(12);
    String params = "x:"+fx+" y:"+fy;
    text(params, 30,50);
    params = "width:"+width+" height:"+height;
    text(params, 30,65);
  }
  
}
