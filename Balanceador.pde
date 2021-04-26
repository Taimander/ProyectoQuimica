class Balanceador {
  String pythonScriptPath = "/balanceador/main.exe";
  PGraphics graphics;
  ControlP5 ui;
  
  Button btnborrar;
  Button btnbalancear;
  Button btnvolver;
  
  String ecuacionActual = "C1O2+H2O=C6H12O6+O2";
  String ecuacionBalanceada = "Sin balancear";
  
  public Balanceador(PApplet applet, int w, int h) {
    graphics = createGraphics(w,h);
    ui = new ControlP5(applet);
    ui.setAutoDraw(false);
    btnborrar = ui.addButton("BORRAR ECUACION").setSize(100,40).setPosition(290,250);
    btnbalancear = ui.addButton("BALANCEAR").setSize(100,40).setPosition(410,250);
    btnvolver = ui.addButton("VOLVER AL MENU").setSize(100,40).setPosition(10,height-50);
  }
  
  public void draw() {
    graphics.beginDraw();
    graphics.background(0xFF181818);
    graphics.fill(0xFFFFFFFF);
    graphics.stroke(0xFFFFFFFF);
    graphics.textAlign(CENTER);
    graphics.textSize(45);
    graphics.text("Balanceador de ecuaciones",width/2,50);
    graphics.textSize(30);
    graphics.text("Ecuación:",width/2,100);
    graphics.text(ecuacionActual.replace("=","\u2192"),width/2,200);
    graphics.text("Ecuación balanceada:",width/2,350);
    graphics.text(ecuacionBalanceada.replace("=","\u2192"),width/2,400);
    graphics.textSize(20);
    graphics.text("Nota:\nDespues de cada átomo, por favor escriba\nel número de átomos que hay, incluyendo\n aquellos que sean 1. Ejemplo: H2O -> H2O1",width/2,450);
    graphics.endDraw();
  }
  
  String validKeys = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ0123456789+=";
  
  public void keyPressed() {
    if(keyCode == BACKSPACE) {
      if(ecuacionActual.length() > 0)
        ecuacionActual = ecuacionActual.substring(0,ecuacionActual.length()-1);
    }else if(validKeys.contains(""+key)) {
      ecuacionActual += key;
    }
  }
  
  public String convertirAFormatoPython(String str) {
    String[] mitades = str.split("=");
    String[] primerosCompuestos = mitades[0].split("\\+");
    String[] segundosCompuestos = mitades[1].split("\\+");
    for(int i = 0; i < primerosCompuestos.length; i++) {
      int k = 0;
      String nuevo = "(";
      boolean lastCharWasDigit = false;
      while(k < primerosCompuestos[i].length()) {
        if(Character.isDigit(primerosCompuestos[i].charAt(k))) {
          if(!lastCharWasDigit) {
            nuevo += ")";
          }
          lastCharWasDigit = true;
          
        }else{
          if(lastCharWasDigit) {
            nuevo += "(";
          }
          lastCharWasDigit = false;
        }
        nuevo += primerosCompuestos[i].charAt(k++);
      }
      if(!Character.isDigit(nuevo.charAt(nuevo.length()-1))) {
        nuevo += ")1";
      }
      primerosCompuestos[i] = nuevo;
    }
    for(int i = 0; i < segundosCompuestos.length; i++) {
      int k = 0;
      String nuevo = "(";
      boolean lastCharWasDigit = false;
      while(k < segundosCompuestos[i].length()) {
        if(Character.isDigit(segundosCompuestos[i].charAt(k))) {
          if(!lastCharWasDigit) {
            nuevo += ")";
          }
          lastCharWasDigit = true;
          
        }else{
          if(lastCharWasDigit) {
            nuevo += "(";
          }
          lastCharWasDigit = false;
        }
        nuevo += segundosCompuestos[i].charAt(k++);
      }
      if(!Character.isDigit(nuevo.charAt(nuevo.length()-1))) {
        nuevo += ")1";
      }
      segundosCompuestos[i] = nuevo;
    }
    String vfinal = primerosCompuestos[0];
    for(int i = 1; i < primerosCompuestos.length; i++) {
      vfinal += " + "+primerosCompuestos[i];
    }
    vfinal += " = "+segundosCompuestos[0];
    for(int i = 1; i < segundosCompuestos.length; i++) {
      vfinal += " + "+segundosCompuestos[i];
    }
    return vfinal;
  }
  
  public void controlEvent(ControlEvent evt) {
    if(evt.getController() == btnborrar) {
      ecuacionActual = "";
    }
    if(evt.getController() == btnbalancear) {
      //balancear
      println(convertirAFormatoPython(ecuacionActual));
      try {
        ecuacionBalanceada = balancear(convertirAFormatoPython(ecuacionActual));
      }catch(Exception e) {
        ecuacionBalanceada = "Error";
      }
    }
    if(evt.getController() == btnvolver) {
      state = 0;
    }
  }
  
  public String balancear(String ecuacion) {
    try{
      Process p = Runtime.getRuntime().exec(sketchPath().toString()+pythonScriptPath);
      java.io.BufferedWriter inputstream = new java.io.BufferedWriter(new java.io.OutputStreamWriter(p.getOutputStream()));
      java.io.BufferedReader outputstream = new java.io.BufferedReader(new java.io.InputStreamReader(p.getInputStream()));
      inputstream.write(ecuacion+"\n");
      inputstream.flush();
      p.waitFor();
      String result = outputstream.readLine();
      if(result == null) {
        throw new IllegalArgumentException();
      }
      println("RESULT: "+result);
      String resultCode = outputstream.readLine();
      println("RESULT CODE: "+resultCode);
      if(resultCode == "INVALID") {
        println("Invalido.");
        throw new IllegalArgumentException();
      }
      return result;
    }catch(IOException e) {
      e.printStackTrace();
      return "Error";
    }catch(InterruptedException e) {
      e.printStackTrace();
      return "Error";
    }
  }
  
}
