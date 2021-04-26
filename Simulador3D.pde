class Simulador3D {
  PGraphics graphics;
  float angle = 0;
  ArrayList<Molecula> moleculas;
  int vel = 1;
  int debugMsgs;
  
  boolean isPreview;
  
  ControlP5 ui;
  
  Button volverBtn;
  Button agregarMoleculaBtn;
  Button quitarMoleculaBtn;
  Button subirVelocidadBtn;
  Button bajarVelocidadBtn;
  
  public Simulador3D(PApplet applet, int cantidad,int w, int h,boolean preview) {
    graphics = createGraphics(w,h,P3D);
    moleculas = new ArrayList<Molecula>(cantidad);
    for(int i = 0; i < cantidad; i++) {
      moleculas.add(new Molecula(((int)random(200))%4));
    }
    isPreview = preview;
    ui = new ControlP5(applet);
    ui.setAutoDraw(false);
    volverBtn = ui.addButton("VOLVER AL MENU").setSize(100,40).setPosition(10,height-50);
    agregarMoleculaBtn = ui.addButton("agregar molecula").setSize(100,40).setPosition(10,100);
    quitarMoleculaBtn = ui.addButton("quitar molecula").setSize(100,40).setPosition(10,150);
    subirVelocidadBtn = ui.addButton("+ velocidad").setSize(100,40).setPosition(10,200);
    bajarVelocidadBtn = ui.addButton("- velocidad").setSize(100,40).setPosition(10,250);
  }
  
  void draw() {
    graphics.beginDraw();
    graphics.background(0xFF181818);
    graphics.stroke(255);
    graphics.fill(255);
    graphics.translate(graphics.width/2,graphics.height/2);
    graphics.pushMatrix();
    graphics.translate(0,10,-10);
    graphics.rotateX(PI/3);
    graphics.rotateZ(angle+=0.005);
    drawBox();
    for(Molecula molecula : moleculas) {
      for(int i = 0; i < vel; i++) {
        molecula.simStep();
      }
      molecula.render();
    }
    graphics.popMatrix();
    graphics.fill(255);
    if(!isPreview){
      debugMsgs = 0;
      graphics.textSize(20);
      printDbg("Numero de atomos: "+moleculas.size());
      printDbg("Velocidad actual: "+vel+"x");
      printDbg("FPS Actuales: "+(int)frameRate+" fps");
    }
    //printDbg("[1] Añadir 1 átomo");
    //printDbg("[2] Quitar 1 átomo");
    //printDbg("[3] Aumentar velocidad de simulación");
    //printDbg("[4] Reducir velocidad de simulación");
    graphics.endDraw();
  }
  
  public void controlEvent(ControlEvent evt) {
    if(evt.getController() == volverBtn) {
      state = 0;
    }
    if(evt.getController() == agregarMoleculaBtn) {
      moleculas.add(new Molecula(((int)random(200))%4));
    }
    if(evt.getController() == quitarMoleculaBtn) {
      if(moleculas.size() > 1)
        moleculas.remove(0);
    }
    if(evt.getController() == subirVelocidadBtn) {
      vel++;
    }
    if(evt.getController() == bajarVelocidadBtn) {
      if(vel > 0) 
        vel--;
    }
  }
  
  void keyPressed() {
  /*
    if(key == '1') {
      moleculas.add(new Molecula(((int)random(200))%4));
    }
    if(key == '2') {
      if(moleculas.size() > 1)
        moleculas.remove(0);
    }
    if(key == '3') {
      vel++;
    }
    if(key == '4') {
      if(vel > 0) 
        vel--;
    }
    */
  }
  
  void printDbg(String msg) {
    graphics.text(msg,-width/2,-height/2 + (21 * ++debugMsgs));
  }

  void drawBox() {
    graphics.noFill();
    graphics.stroke(255);
    graphics.box(250);
  }

  void drawH2O(PVector pos, PVector rot) {
    graphics.pushMatrix();
    graphics.noStroke();
    graphics.fill(0xFFFF0000);
    graphics.translate(pos.x,pos.y,pos.z);
    graphics.rotateX(rot.x);
    graphics.rotateY(rot.y);
    graphics.rotateZ(rot.z);
    graphics.sphere(10);
    graphics.translate(8,8,0);
    graphics.fill(0xFFFFFFFF);
    graphics.sphere(5);
    graphics.translate(-16,0,0);
    graphics.sphere(5);
    graphics.popMatrix();
  }

  void drawH2(PVector pos, PVector rot) {
    graphics.pushMatrix();
    graphics.noStroke();
    graphics.fill(0xFFFFFFFF);
    graphics.translate(pos.x,pos.y,pos.z);
    graphics.rotateX(rot.x);
    graphics.rotateY(rot.y);
    graphics.rotateZ(rot.z);
    graphics.sphere(5);
    graphics.translate(8,0,0);
    graphics.sphere(5);
    graphics.popMatrix();
  }

  void drawN2(PVector pos, PVector rot) {
    graphics.pushMatrix();
    graphics.noStroke();
    graphics.fill(0xFF3A3AD0);
    graphics.translate(pos.x,pos.y,pos.z);
    graphics.rotateX(rot.x);
    graphics.rotateY(rot.y);
    graphics.rotateZ(rot.z);
    graphics.sphere(8);
    graphics.translate(14,0,0);
    graphics.sphere(8);
    graphics.popMatrix();
  }

  void drawCO2(PVector pos, PVector rot) {
    graphics.pushMatrix();
    graphics.noStroke();
    graphics.fill(0xFF252525);
    graphics.translate(pos.x,pos.y,pos.z);
    graphics.rotateX(rot.x);
    graphics.rotateY(rot.y);
    graphics.rotateZ(rot.z);
    graphics.sphere(8);
    graphics.translate(8,0,0);
    graphics.fill(0xFFFFFFFF);
    graphics.sphere(5);
    graphics.translate(-16,0,0);
    graphics.sphere(5);
    graphics.popMatrix();
  }
  void checkCollisions() {
    for(Molecula m1 : moleculas) {
      for(Molecula m2 : moleculas) {
        if(m1 != m2) {
          if(m1.isColliding(m2)) {
            m1.velocidad = m1.velocidad.add(m2.velocidad.copy()).normalize();
          }
        }
      }
    }
  }
  
  class Molecula {

    int tipo;
    PVector posicion;
    PVector velocidad;
  
    PVector rotacion;
    PVector velRotacion;
  
    public Molecula(int tipo) {
      this.tipo = tipo;
      posicion = new PVector(random(120*2)-120,random(120*2)-120,random(120*2)-120);
      velocidad = PVector.random3D().normalize();
      rotacion = PVector.random3D().normalize();
      velRotacion = PVector.random3D().normalize().div(100);
    }
  
    public boolean isColliding(Molecula otro) {
      return posicion.copy().sub(otro.posicion).mag() < 15;
    }
    
    public void simStep() {
      PVector nuevaPos = posicion.copy().add(velocidad);
      rotacion.add(velRotacion);
      if(abs(nuevaPos.x) > 120) {
        velocidad.x *= -1;
      }
      if(abs(nuevaPos.y) > 120) {
        velocidad.y *= -1;
      }
      if(abs(nuevaPos.z) > 120) {
        velocidad.z *= -1;
      }
      if(abs(nuevaPos.x) < 120 && abs(nuevaPos.y) < 120 && abs(nuevaPos.z) < 120) {
        posicion = nuevaPos;
      }
    }
  
    public void render() {
      switch(tipo) {
        case 0: // H20
          drawH2O(posicion,rotacion);
          break;
        case 1: // H2
          drawH2(posicion,rotacion);
          break;
        case 2: // CO2
          drawCO2(posicion,rotacion);
          break;
        case 3: // N2
          drawN2(posicion,rotacion);
          break;
      }
    }
  }
}
