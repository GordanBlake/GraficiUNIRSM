// interazione da tastiera ////////////////////////////////////////////////////////////////////////
void keyPressed() {

  // i tasti sono verificati sia maiuscoli che minuscoli nell'eventualità di un caps lock attivo
  // premendo s salviamo una img dell'attuale schermata
  if(key == 's' || key == 'S') {
    save(fileName + ".png");
    println("Immagine salvata!");
  }

  // premento p salviamo il pdf dell'attuale schermata
  if(key == 'p' || key == 'P') {
    record = true;
    println("PDF salvato!");
    redraw(); // ridisegnamo per innescare il record
  }

  // con q si aumenta di una unità il valore del seed creando una nuova serie randomica per i colori dei grafici
  if(key == 'q' || key == 'Q') {
    redraw();
    seed++;
    println("Seed: " + seed);
  }

  // premendo a si diminuisce di una unità il valore del seed
  if(key == 'a' || key == 'A') {
    redraw();
    seed--;
    println("Seed: " + seed);
  }

}