public class Button {
  int x,y,x2,y2,w,h;
  String action;
  
  Button(int _x,int _y,int _w,int _h, String _action){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    x2 = x+w;
    y2 = y+h;
    
    action = _action;
  }
  
  String clicked(int mx,int my){
    if (mx > x && mx < x2 && my > y && my < y2){
      return action;
    } else {
      return "";
    }
  }
}
