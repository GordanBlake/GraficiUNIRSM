void column(float posX, float posY, int altezza, int spessore, float axisY, int segmenti) {
  float piccoMax = max(sorgDati); // trova il valore massimo tra quelli nell'array coi dati
  float piccoMin = min(sorgDati);
  float padding = 2.3;
  float margin = (spessore*padding/2-spessore/2)*2;

  pushMatrix();
  pushStyle();
  
  translate(posX, posY+min(0,piccoMin)); // così lo allinea al punto + basso
  textAlign(CENTER);
  textFont(myFont, spessore-2);
  //fill(0,0,100); noStroke(); ellipse(0,0,6,6); //controllo l'origine, da togliere

   // griglie di riferimento
   strokeWeight(1);
   if (gridCol == true) {
     for(int i=0; i < axisY*altezza; i+=segmenti*altezza) {    // min(0,piccoMin*altezza)
       stroke(fGround, 15);
       line(0, i*-1, sorgDati.length*(spessore*padding)+margin, i*-1);
       if (min(0,piccoMin*altezza) < 0 ) {
       line(0, i, sorgDati.length*(spessore*padding)+margin, i);
       }
     }
   }
 
  // tacche disegnate solo se la booleana è vera se due si sovrappongono l'alpha si somma e vengono le righe + piene dovrebbe disegnarle solo se prima non ci sono valori uguali
  if(taccheCol) {
    for (int i=0; i < sorgDati.length; i++) {
      // tacchie lunghe
      stroke(colore, 100, 100, abs(sorgDati[i]*2));
      line(0, sorgDati[i]*-altezza, sorgDati.length*(spessore*padding)+margin, sorgDati[i]*-altezza);
      
      // tacchie corte
      //stroke(colore, 100, abs(sorgDati[i])*8); // colorate
      //stroke(colore, 0, 100); // bianche
      //line(0, sorgDati[i]*-altezza, 5, sorgDati[i]*-altezza);
    }
  }
  
  // colonne grafico
  noStroke();
  for (int i=0; i < sorgDati.length; i++) {
    fill(colore, 100, abs(map(sorgDati[i], 0, max(sorgDati), 15, 100))); // rendo assoluti altrimenti i valori col negativo non vanno

    rect(i*spessore*padding+margin, 0, spessore, sorgDati[i]*-altezza);

    fill(fGround);
    if (sorgDati[i] >= 0) { text((int)sorgDati[i], i*(spessore*padding)+spessore/2+margin, sorgDati[i]*-altezza-spessore/5); } // nf gestisce i numeri pre e post virgola (int) cionca i decimali nf(sorgDati[i],0,1)
    else { text((int)sorgDati[i], i*(spessore*padding)+spessore/2+margin, sorgDati[i]*-altezza+spessore/1.2); }
    //println(sorgDati[i]*altezza*-1);
  }
  
  
  // acisse e ordinate ////////////////////////////////////////////////////////////////////////////
  strokeWeight(axisWeight); // valori inferiori a 1 fanno l'effetto dell'alpha e poi su JS non si vedono
  stroke(fGround);  
  line(0, 0, sorgDati.length*(spessore*padding)+margin, 0); // orizzontale - ascisse
  //if (taccheCol) { line(0, min(0, piccoMin)*-altezza, 0, piccoMax*-altezza); } // verticale - ordinate
  
  popStyle();
  popMatrix();
}
