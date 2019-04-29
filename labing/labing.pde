import processing.video.*;
Capture video;
Movie appdemo;
Movie systemdemo;
color track;
float[] x=new float[20];
float[] y=new float[20];
int segNum=20;
int segLength=18;
int nowx=600;
int nowy=300;
int yesback=1;
int stop=0; //to detect whether the track mode is on
int mode=0;
String istrack="Track On";
String count="Solve Number:";
int num=0;
int max=10;
worm myworm;
ArrayList<garbage> garbages;

class garbage{
  PVector loc;
  int lifespan;
  int r;
  boolean dead;
  garbage(){
    loc=new PVector(random(100,width-100),random(100,height-100));
    lifespan=255;
    r=(int)random(10,70);
    dead=false;
  }
  void update_killed(int inx,int iny){
    if(dead==false){
    if(abs(inx-loc.x)<r&&abs(iny-loc.y)<r){
        dead=true;
        num++;
    }
    }
  }
  void render(){
    noStroke();
    fill(255,lifespan);
    if(dead==true){
      lifespan-=10;
    }
    ellipse(loc.x,loc.y,r,r);
  }
  boolean isdead(){
    if(lifespan<0){
      return true;
    }
    else{
      return false;
    }
  }
}

class worm{
  PVector v;
  PVector a;
  PVector location;
  worm(){
    v=new PVector(random(-0.5,0.5),random(-0.5,0.5));
    a=new PVector(random(-0.5,0.5),random(-0.5,0.5));
    location=new PVector(random(0,width),random(0,height));
  }
  void updatetrack(int inx,int iny){
   /* v.x=random(-2,2);
    v.y=random(-2,2);
    a.x=random(-2,2);
    a.y=random(-2,2);*/
    v.x=random(-0.5,0.5);
    v.y=random(-0.5,0.5);
    a.x=random(-0.5,0.5);
    a.y=random(-0.5,0.5);
    location.x=inx;
    location.y=iny;
  }
  void update(){
    a.x=random(-0.5,0.5);
    a.y=random(-0.5,0.5);
    location.add(v);
    v.add(a);
  }
  void rendertrack(int nowx,int nowy){
    strokeWeight(19);
    stroke(205,51,51);
    updatetrack(nowx,nowy);
    checkedge();
    dragworm(0,nowx,nowy);
    for (int i=0;i<x.length-1;i++) {
    dragworm(i+1,x[i],y[i]);
  }
  }
  void render(){
    strokeWeight(19);
    stroke(205,51,51);
    update();
    checkedge();
    dragworm(0,location.x,location.y);
    for (int i=0;i<x.length-1;i++) {
    dragworm(i+1,x[i],y[i]);
  }
  }
  void checkedge(){
    if(location.x<=5){
       if(v.x<0){
         v.x=1;
       }
       if(a.x<0){
         a.x*=-2;
       }
    }
    else if(location.x>=1275){
      if(v.x>0){
        v.x=-1;
      }
      if(a.x>0){
        a.x*=-2;
      }
    }
    if(location.y<=5){
       if(v.y<0){
         v.y=1;
       }
       if(a.y<0){
         a.y*=-2;
       }
    }
    else if(location.y>=700){
      if(v.y>0){
        v.y=-1;
      }
      if(a.y>0){
        a.y*=-2;
      }
    }
    constrain(v.x,-0.75,0.75);
    constrain(v.y,-0.75,0.75);
}
}

void setup() {
  for (int i=0;i<segNum;i++) {
  x[i]=0;
  y[i]=0;
}
 // size(1280,720);
  fullScreen();
  video=new Capture(this,1280,720);
  video.start();
  track=color(0,0,0);
  strokeWeight(19);
  stroke(205,51,51);
  //stroke(255,22);
  textSize(32);
   frameRate(60);
  systemdemo=new Movie(this,"systemdemo.mov");
  appdemo=new Movie(this,"appdemo.mov");
  myworm=new worm();
  garbages=new ArrayList<garbage>();
  int randomnum=(int)random(1,10);
  for(int i=0;i<randomnum;i++){
    garbages.add(new garbage());
  }
}

void captureEvent(Capture video){
  video.read();
}

void movieEvent(Movie m){
  m.read();
}

void draw() {
  if(keyPressed==true){
    if(key=='1'){
      systemdemo.stop();
      mode=1;
    }
    else if(key=='2'){
      appdemo.stop();
      mode=2;
    }
    else if(key=='0'){
      appdemo.stop();
      systemdemo.stop();
      mode=0;
    }
  }
  switch(mode){
    case 1:{
      image(appdemo,0,0,width,height);
      appdemo.loop();
      break;
    }
    case 2:{
      image(systemdemo,0,0,width,height);
      systemdemo.loop();
      break;
    }
    case 0:{
  tint(255, 127);
  background(0);
  pushMatrix();
  translate(width,0);
  scale(-1,1);
  // tint(255, 127);
  if(keyPressed==true){
    if(key=='w'){
      yesback=1;
    }
    else if(key=='s'){
      yesback=0;
    }
    else if(key=='t'){
        stop=0;
        istrack="Track On";
        print("track");
        println();
      }
      else if(key=='f'){
        stop=1;
        istrack="Track Off";
        num=0;
        print("stop");
        println();
      }
    }
  video.loadPixels();
  if(yesback==1){
  image(video,0,0);
  }
  if(stop==0){
 int closestx=600;
 int closesty=300;
 float record=99999;
 for(int x=0;x<video.width;x++){
   for(int y=0;y<video.height;y++){
     int loc=x+y*video.width;
     color current=video.pixels[loc];
     float r1=red(current);
     float g1=green(current);
     float b1=blue(current);
     float r2=red(track);
     float g2=green(track);
     float b2=blue(current);
     float d=dist(r1,g1,b1,r2,b2,g2);
     if(d<record){
       record=d;
       closestx=x;
       closesty=y;
     }
   }
 }
 if(record<50&&abs(closestx-nowx)<=120&&abs(closesty-nowy)<=120){
   nowx=closestx;
   nowy=closesty;
 }
 else{
   nowx+=random(-5,5);
   nowy+=random(-5,5);
  }
  myworm.rendertrack(nowx,nowy);
    for(int i=0;i<garbages.size();i++){
      garbage one=garbages.get(i);
      one.update_killed(nowx,nowy);
      one.render();
      if(one.isdead()){
        garbages.remove(i);
        int addnum=(int)random(1,max-garbages.size());
        for(int j=1;j<addnum;j++){
        garbages.add(new garbage());
        }
      }
    }
  }
  else if(stop==1){
    myworm.render();
  }
 // }
  popMatrix();
  fill(0,102,153);
  text(istrack,10,10,150,50);
   text(count+num,1000,10,1200,50);
  break;
    }
  }
}
void dragworm(int i,float xin,float yin) {
  float dx=xin-x[i];
  float dy=yin-y[i];
  float angle=atan2(dy,dx);
  x[i]=xin-cos(angle)*segLength;
  y[i]=yin-sin(angle)*segLength;
  segment(x[i],y[i],angle);
}

void segment(float x,float y,float a) {
  pushMatrix();
  translate(x,y);
  rotate(a);
  line(0,0,segLength,0);
  popMatrix();
}

void mousePressed(){
  int xx=domousex();
  int yy=domousey();
  int loc=xx+yy*video.width;
  track=video.pixels[loc];
  nowx=xx;
  nowy=yy;
}

int domousex(){
  int dox=1280-mouseX;
  return dox;
}

int domousey(){
  int doy=mouseY;
  return doy;
}