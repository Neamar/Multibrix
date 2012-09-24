//----------- Menu Principal ------------
Cube.Menu_Principal.addButton("Jouer", 0, -100, 1, Jouer);
Cube.Menu_Principal.addButton("High Scores", 0, 100, 1, Cube.gotoHighScoreFromMenu);
//Cube.Menu_Principal.addButton("Options", Global.WIDTH / 2, 500, 1, Cube.gotoOptions);

function Jouer():void {
	if (Jeu.JeuActuel == null) {
		Cube.gotoJeu();
		new Jeu();
	}
}

//------------ Menu Pause -------------
Cube.Menu_Pause.addButton("Reprendre", Global.WIDTH / 2, 150, 1, Reprendre);
Cube.Menu_Pause.addButton("Recommencer", Global.WIDTH / 2, 300, 1, Recommencer);
Cube.Menu_Pause.addButton("Menu Principal", Global.WIDTH / 2, 450, 1, RetourMenuPrincipal);

function Reprendre():void {
    Jeu.JeuActuel.Pause = false;
}

function Recommencer():void {
    Cube.Menu_Pause.Close();
    Jeu.JeuActuel.Destroy();
    new Jeu();
}

function RetourMenuPrincipal():void {
    Jeu.JeuActuel.Destroy();
    Cube.Menu_Pause.Close();
    //Cube.Menu_Principal.Show();
    Cube.gotoMenu();
}

