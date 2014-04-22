// import delle librerie necessarie ///////////////////////////////////////////////////////////////

import processing.pdf.*;








// dichiarazione delle variabili globali //////////////////////////////////////////////////////////

// array di sorgente dati (per ora compilati a mano per dimostrazione)
float[] dati = { 15,5,20,9,8,3,10 };
float[] dati2 = { 10,23,10,14,8,3,10,5,2 };
float[] dati3 = { 10,-23,30,-14,8,3,15,5,2 };
float[] dati4 = { 15,5,20,9,20,8,8,15 };
float[] dati5 = { 20,5,25,10,12,4,8,16 };

// variabili specifiche per i vari grafici
boolean taccheCol;          // tacche sui valori del grafico column
boolean gridCol;            // griglie fisse di riferimento del grafico column
boolean hole;               // booleana che regola se i grafici a torta sono bucati (donut)
boolean varRadius;          // regola se il raggio degli spicchi sia variabile o fisso
boolean allValues;          // se attiva mostra tutte le tacche con i valori intermedi
float lastAng;              // ultimo angolo da cui partire per il grafico a torta
float totDati;              // totale dei dati
float bright;               // brightness
boolean brightnessMode;     // se vera la luminosità degli spicchi è proporzionale, altrimenti è casuale
float firstBright;          // tiene conto del primo valore di luminosità per fare in modo che l'ultimo non sia troppo simile
float[] sorgDati;           // la sorgente dei dati dai vari grafici, assegnata di volta in volta
int colore;                 // valore di tonalità dei grafici
float axisWeight = 1;       // spessore delle assi di riferimento dei grafici
int seed = -20;             // seed random di partenza

int fGround = color(55);    // colore primo piano. dichiarato come int invece che color per evitare problemi in eclipse (valori in rgb)
int bGround = color(250);   // colore di fondo

PFont myFont;               // il riferimento al font che useremo nei grafici

boolean record;             // se vera "registra" il pdf
String fileName;





// funzione di setup //////////////////////////////////////////////////////////////////////////////

void setup() {
  size(1250, 950);
  strokeCap(SQUARE);
  smooth();
  noFill();
  randomSeed(seed);

  myFont = createFont("League Gothic Regular", 55);
  textFont(myFont);
  
  println("Premere Q per aumentare il seed, A per diminuirlo. Premere S per uno screenshot.");

  noLoop();
}








// funzione ciclica di disegno ////////////////////////////////////////////////////////////////////

void draw() {

  randomSeed(seed);

  fileName = "img/GRAFICI seed " + seed; // diamo un nome al file comprensivo di valore di seed per evitare doppioni
  if(record) { beginRecord(PDF, fileName + ".pdf"); } // se record è vera inizia a "registrare" il pdf
  
  background(bGround);

  colorMode(HSB, 360, 100, 100, 100); // imposta i colori in HSB. spostato nel draw dal setup altrimenti il pdf non lo leggeva

    
  // x, y, diametro
  allValuesOn();
  pieRadiusOff();
  brightnessProportional();
  dataSource(dati);
  holeOn();
  setTone(330);
  pieChart(150, 150, 90);

  allValuesOff();
  brightnessRandom();
  dataSource(dati2);
  sortData();
  setTone(150);
  pieChart(400, 250, 75);

  brightnessProportional();
  dataSource(dati2);
  holeOff();
  pieRadiusOn();
  setTone(180);
  pieChart(620, 150, 80);
  
  brightnessProportional();
  dataSource(dati5);
  holeOff();
  pieRadiusOn();
  sortData();
  setTone(100);
  pieChart(860, 250, 80);

  brightnessRandom();
  dataSource(dati4);
  holeOff();
  pieRadiusOff();
  setTone(20);
  pieChart(1100, 150, 90);

  // x, y, altezza, spessore, piccoY, valSegmento
  colNotchOff();
  colGridOn();
  setTone(180);
  column(50, height-300, 5, 15, 30, 5);
  
  colNotchOn();
  colGridOff();
  dataSource(dati);
  setTone(330);
  column(750, height-300, 8, 15, 20, 5);
  
  dataSource(dati3);
  setTone(150);
  sortData();
  column(50, height-100, 3, 15, 40, 5);

  // x, y, spessore
  dataSource(dati2);
  setTone(100);
  area(750, height-100, 3);
  

  if(record) { endRecord(); record = false; } // finisce di "registrare" il pdf quando ha finito tutte le funzioni di disegno
  //savePdf();
}








// funzioni sugli array dati //////////////////////////////////////////////////////////////////////

float sommaValori(float[] arrDati) {
  for (int i=0; i<arrDati.length; i++) {
    totDati += arrDati[i];
  }
  return totDati;
}

// sorgente dati
float[] dataSource(float[] source) {
  sorgDati = source;
  return source;
}

// ordina i dati in modo decrescente
float[] sortData() {
  sorgDati = reverse(sort(sorgDati));
  return sorgDati;
}








// funzioni sul colore ////////////////////////////////////////////////////////////////////////////
// setta la dominante di hue del colore
int setTone(int tone) {
  colore = tone;
  return tone;
}

// regola se la brightness hsb è proporzionale al valore dei dati o random
boolean brightnessProportional() {
  return brightnessMode = true;
}
boolean brightnessRandom() {
  return brightnessMode = false;
}

// mappo la brightness ai valori dell'array
float mapCol(float source) {
  float thisBright = abs(map(source, 0, max(sorgDati), 5, 100));
  return thisBright;
}

// avoid sequential random color to be too similiar *this function may be totally stupid*
boolean lastValue;
float varyRandom() {
  float threshold = 20;  // higher the value highter the time to display > 40 is inacceptable fot a graph
  float tempBright = random(threshold, 100);
  float calculus = max(bright, tempBright) - min(bright, tempBright);
  float calculus2 = max(firstBright, tempBright) - min(firstBright, tempBright);
  // loops until the new tempBright is different enough from the previous bright value
  if(!lastValue) {
    while(calculus < threshold) {
      tempBright = random(threshold, 100);
      calculus = max(bright, tempBright) - min(bright, tempBright);
    }
  } else {
    while(calculus < threshold || calculus2 < threshold) {
      tempBright = random(threshold, 100);
      calculus = max(bright, tempBright) - min(bright, tempBright);
      calculus2 = max(firstBright, tempBright) - min(firstBright, tempBright);
    }
  }
  return tempBright;
}








// funzioni per il grafico a colonna //////////////////////////////////////////////////////////////
// tacche grafico a colonna
boolean colNotchOn() {
  return taccheCol = true;
}
boolean colNotchOff() {
  return taccheCol = false;
}

// griglie fisse grafico a colonna
boolean colGridOn() {
  return gridCol = true;
}
boolean colGridOff() {
  return gridCol = false;
}








// funzioni per il grafico a torta ////////////////////////////////////////////////////////////////
// buco grafico a torta
boolean holeOn() {
  return hole = true;
}
boolean holeOff() {
  return hole = false;
}

// diametro variabile grafico torta
boolean pieRadiusOn() {
  return varRadius = true;
}
boolean pieRadiusOff() {
  return varRadius = false;
}

// tacche con tutti i valori
boolean allValuesOn() {
  return allValues = true;
}
boolean allValuesOff() {
  return allValues = false;
}