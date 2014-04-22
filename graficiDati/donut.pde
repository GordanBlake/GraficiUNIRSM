float contDiam; // diametro contestuale basato su pieRadiusOn() and pieRadiusOff()
int spessorePie = 18;

void pieChart(int posX, int posY, int diametro) {
  totDati = sommaValori(sorgDati);
  lastValue = false;
  
  pushStyle();
  pushMatrix();
  translate(posX, posY);
  strokeWeight(spessorePie);
  strokeCap(SQUARE);
  ellipseMode(RADIUS); // così possiamo passare i valori al raggio e non al diametro nonostante sia ellipseMode funziona anche sugli arc
  rotate(-HALF_PI); // così parte dalle ore 12, perchè lo zero radiale è ad ore 3
  for (int i = 0; i < sorgDati.length; i++) {
  if(!brightnessMode && totDati == 100 && i==sorgDati.length-1) { lastValue = true; }
  if(!brightnessMode) { bright = varyRandom(); if(i==0){ firstBright = bright; } } else { bright = mapCol(sorgDati[i]); }
    if(!hole) { noStroke(); fill(colore, 100, bright); } else { stroke(colore, 100, bright); }
    if(varRadius){ contDiam = diametro+sorgDati[i]; } else { contDiam = diametro; }
    arc(0, 0, contDiam, contDiam, lastAng, lastAng+radians(sorgDati[i]*3.6)); // moltiplica per 3.6 per fare un intero da 100 a 360 (percentuale > gradi)
    lastAng += radians(sorgDati[i]*3.6); // posiziona il valore di inizio del nuovo arco dove finiva quello precedente
    if(allValues) { allValuesText(i, lastAng); } // tacche coi valori intermedi
  }
  if (totDati < 100) { // se la somma dei dati non arriva a 100% riempie il resto di grigio
    if(!hole) { noStroke(); fill(fGround, 8); } else { stroke(fGround, 8); }
    arc(0, 0, diametro, diametro, lastAng, lastAng+radians(360-totDati*3.6) );
  }  
  popMatrix();
  popStyle();


  // testo interno diagramma //////////////////////////////////////////////////////////////////////
  innerText(posX, posY, diametro);

  // resetta il valore delle var così ad ogni chiamata parte dallo stesso punto ///////////////////
  lastAng=0;
  totDati=0;

  // debugging ////////////////////////////////////////////////////////////////////////////////////
  //println("ultimoangolo " + lastAng);
  //println("totale " + totDati);
  //println("angolo a caso " + dati[6]);
}






void innerText(float posX, float posY, int diametro) {
  pushStyle();
  pushMatrix();
  fill(fGround);
  if(hole) { translate(posX, posY); } // sposts la scritta col totale in base al tipo di torta
  if(!hole && ! varRadius) { translate(posX, posY+diametro+40); }
  else if(!hole && varRadius) { translate(posX, posY+diametro+50); }
  textAlign(RIGHT); 
  textFont(myFont, 55); 
  text((int)totDati, 15, 15);
  textAlign(LEFT); 
  textFont(myFont, 40); 
  text("%", 18, 15);
  fill(fGround, 40);
  textAlign(CENTER); 
  textFont(myFont, 18); 
  text("TOTAL", 0, 35);
  popMatrix();
  popStyle();
}


void allValuesText(int i, float lastAng) {
  int x = 0; // per allineare meglio quando ruota
  int y = -5;
  pushStyle();
  pushMatrix();
  rotate(radians(-0.3)); // allinea i trattini al terminale del segmento altrimenti eccedono
  stroke(colore, 100, bright);
  fill(fGround);
  strokeWeight(1);
  rotate(lastAng);
  textAlign(RIGHT);
  textFont(myFont, 18);
  line(contDiam, 0, contDiam+spessorePie+12, 0);
  translate(contDiam+spessorePie+10, 0);
  if(lastAng > radians(180)) { rotate(PI); textAlign(LEFT); x = -2; y = 17; } // ruota di 180 il testo così è leggibile anche quando passa le ore 6
  text((int)sorgDati[i], x, y);
  popMatrix();
  popStyle();
}
