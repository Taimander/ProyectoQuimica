import controlP5.*;

ControlP5 cp5;
Button loadsimbtn;
Button loadbalbtn;

PImage logoUACH;

void setup() {
  size(800,600,P3D);
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  loadsimbtn = cp5.addButton("abrir simulador").setSize(100,40).setPosition(500,300);
  loadbalbtn = cp5.addButton("abrir balanceador").setSize(100,40).setPosition(150,300);
  simPreview = new Simulador3D(this,20,width,height,true);
  simPreview.draw();
  simPreviewImg = simPreview.graphics.copy();
  simPreviewImg.resize(200,150);
  balPreview = new Balanceador(this,width,height);
  balPreview.draw();
  balPreviewImg = balPreview.graphics.copy();
  balPreviewImg.resize(200,150);
  sim = new Simulador3D(this,50,width,height,false);
  bal = new Balanceador(this,width,height);
  logoUACH = loadImage("logo_uach.png");
  logoUACH.resize(130,136);
}

Simulador3D sim;
Balanceador bal;

int state = 0;

void draw() {
  background(0xFF181818);
  switch(state) {
    case 0: drawMenu(); break;
    case 1: 
      sim.draw();
      image(sim.graphics,0,0);
      sim.ui.draw();
      break;
    case 2:
      bal.draw();
      image(bal.graphics,0,0);
      bal.ui.draw();
      break;
  }
  
}

Balanceador balPreview;
PImage balPreviewImg;
Simulador3D simPreview;
PImage simPreviewImg;

void drawMenu() {
  textSize(45);
  textAlign(CENTER);
  text("Proyecto de Química",width/2,50);
  textSize(30);
  text("Segundo Parcial",width/2,100);
  image(balPreviewImg,100,150);
  if(frameCount % 2 == 0) {
    simPreview.draw();
    simPreviewImg = simPreview.graphics.copy();
    simPreviewImg.resize(200,150);
  }
  image(simPreviewImg,450,150);
  textSize(25);
  textAlign(LEFT);
  text(" Integrantes:",0,500);
  text(" - Cosimo Vulcano Morris",0,530);
  text(" - Samuel Sánchez Tarango",0,560);
  text(" - Andrea López",0,590);
  image(logoUACH,width-145,height-145);
  cp5.draw();
}

void keyPressed() {
 if(state == 1)
   sim.keyPressed();
 if(state == 2)
   bal.keyPressed();
}

void controlEvent(ControlEvent theEvent) {
  if(state == 1) {
    sim.controlEvent(theEvent);
    return;
  }
  if(state == 2) {
    bal.controlEvent(theEvent);
    return;
  }
  if(theEvent.getController() == loadsimbtn) {
    state = 1;
  }
  if(theEvent.getController() == loadbalbtn) {
    state = 2;
  }
}
