float zoff=0.0;
void setup(){
  size(800,800);
}
void draw(){
  float red=noise(zoff)*255;
 loadPixels();
 float xoff=0.0;
 for(int x=0;x<width;x++){
   float yoff=0.0;
   for(int y=0;y<height;y++){
     //float bright=random(255);
    float bright = map(noise(xoff,yoff,zoff),0,1,0,255);
    float dis=sqrt((mouseX-width/2)*(mouseX-width/2)+(mouseY-height/2)*(mouseY-height/2));
    float center=map(dis,0,sqrt((width/2)*(width/2)+(height/2)*(height/2)),0,255);
     pixels[x+y*width]=color(red,bright,center);
     yoff+=0.01;
   }
   xoff+=0.01;
 }
 updatePixels();
 zoff+=0.03;
}