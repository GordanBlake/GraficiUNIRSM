void area(float posX, float posY, int spessore) {
  float picco = max(sorgDati); // trova il valore massimo tra quelli nell'array coi dati
  int largMolti = 40;
  
  pushMatrix();
  pushStyle();
  
  translate(posX, posY);
  //ellipse(0,0,10,10); //controllo l'origine, utile al debug
  
  //strokeCap(SQUARE);
  textAlign(CENTER);

  translate(spessore, 0);
  strokeWeight(spessore);
  



  // outline superiore
  noFill();
  stroke(colore, 100, 100);
  beginShape();
  for (int i=0; i < sorgDati.length; i++) {
    vertex(i*largMolti, sorgDati[(int)i]*-5); // quando i è a 0 la moltiplicazione da problemi logicamente
  }
  endShape();

  // riempimento, fatto a parte per evitare uno stroke che avrebbe delimitato anche il fondo ed i lati
  beginShape();
  fill(colore, 100, 100, 10);
  noStroke();
  vertex(0, 0);
  for (int i=0; i < sorgDati.length; i++) {
    vertex(i*largMolti, sorgDati[(int)i]*-5); // quando i è a 0 la moltiplicazione da problemi logicamente
  }
  vertex(largMolti*(sorgDati.length-1), 0);
  endShape();




  translate(-spessore, 0);
  strokeWeight(axisWeight);
  stroke(fGround);
  line(0, 0, 0, picco*-5);  // verticale - ordinate
  line(0, 0, sorgDati.length*largMolti, 0); // orizzontale - ascisse

  //picco = 0; // azzero il picco massimo
  popStyle();
  popMatrix();
}
