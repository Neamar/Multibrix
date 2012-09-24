package Instance
{
    //import com.greensock.data.GlowFilterVars;
	import flash.display.GradientType;
	import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
	import flash.geom.Matrix;
    import flash.geom.Point;
    import com.greensock.TweenMax;
    /**
     * Un niveau parmi les autres.
     * Peut être redimensionné à l'aide des méthodes width et heigth (ne pas toucher à scaleX et scaleY qui n'auront pas le résultat escompté).
     * Implémente une propriété cadence pour accélerer ou ralentir le défilement.
     * @author Neamar
     */
    public class Level extends Sprite
    {
        public static const EVENT_UP:String = "up";
        public static const EVENT_DOWN:String = "down";
        public static const EVENT_ITERATE:String = "iterate";
        public static const EVENT_LOST:String = "lost";
        public static const EVENT_TERMINATE:String = "terminate";
        public static const EVENT_KILL:String = "kill";
        public static const EVENT_GOT_GOODIE:String = "got_goodie";
        public static const EVENT_GOT_BADIE:String = "got_baddie";
        public static const EVENT_FRAME:String = "frame";
		
		 /**
         * La densité de briques à l'intérieur du level, entre 0 et 1 (0 : une brique maximum, 1 : NombreLignes-1 briques minimum)
         */
        public var Densite:Number = Global.Densite;

        /**
         * Le nombre de colonnes que contient le niveau. Attention, le vecteur contenant les obstacles peut avoir plus d'items car dans certains cas, il a de l'avance.
         */
        public var NombreColonnes:int;

        /**
         * Densité de bonus dans le niveau
         */
        public var GoodieDensity:Number = Global.GOOD_DENSITY;

        /**
         * Densité de malus dans le niveau
         */
        public var BadieDensity:Number = Global.BAD_DENSITY;
		
		/**
		 * Un helper pour activer et désactiver facilement les goodie badies sur le niveau.
		 */
		public var GBHandler:GoodBadieHandler;

		/**
		 * Si true, toutes les briques sont négligées et le terrain est vu comme vide.
		 */
		public var PasseMuraille:Boolean = false;
        /**
         * Le ObstaclesContainer qui contient réellement le niveau.
         */
        private var ObstaclesContainer:Sprite = new Sprite();

        /**
         * La balle du jeu
         */
        public var Balle:Sprite = new Sprite();     

        /**
         * La liste des obstacles qui composent le niveau
         */
        private var Obstacles:Vector.<Vector.<Brick> >;

        /**
         * Nombre de colonnes qui sont déjà passées
         */
        private var Offset:int = 0;

        /**
         * Variable interne pour compter le nombre de frames depuis la dernière action
         */
        private var DerniereAction:Number = 0;

        /**
         * Le y de la balle une fois qu'elle aura fini son déplacement
         */
        private var Balle_y:int;

        /**
         * True si le level a été détruit et ne doit donc plus être appelé.
         */
        private var estDetruit:Boolean = false;
		
		/**
		 * True si le level est en TERMINATE
		 */
		private var estTerminate:Boolean = false;		

        /**
         * Constructeur du niveau. Initialise la variable ObstaclesContainer et demande la première génération des obstacles.
         */
        public function Level(hauteurInitiale:int = 100)
        {
			//Le handler des goodbadies :
			GBHandler = new GoodBadieHandler(this);
			
			//Définition du terrain
            NombreColonnes = Math.floor(Global.WIDTH / Global.CaseTaille);       
			//height = Global.HEIGHT / Global.NOMBRE_NIVEAUX;			
            Obstacles = new Vector.<Vector.<Brick> >();
            majTerrain();

            addChild(ObstaclesContainer);

			//Bordure			
			this.graphics.lineStyle(1, Global.RED);
			this.graphics.drawRect(0, 0, Global.WIDTH, height);
			

			//Dessin de la balle
			//var Dessin:Shape = new Shape();
			var matr:Matrix = new Matrix(); matr.createGradientBox(Global.CaseTaille, Global.CaseTaille, 0, -Global.CaseTaille/2, -Global.CaseTaille/2);
			Balle.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, 0x000000], [1, 0], [50, 255], matr);
			Balle.graphics.drawCircle(0 , 0, Global.CaseTaille/2);
			
			
			addChild(Balle);
			
			//Par défaut, la bille est placée à trois colonnes du départ
            Balle.x = 3 * Global.CaseTaille + Global.CaseTaille / 2;
            Balle.y = Balle_y = (Math.round(Global.NOMBRE_ETAGES_NIVEAU / 2) + .5) * Global.CaseTaille;
			Balle.graphics.lineStyle(2,Global.BLUE);
            //Balle.graphics.moveTo(0, 0);
            //Balle.graphics.lineTo(20, 0);

			
            Global.stage.addEventListener(Level.EVENT_ITERATE, ajouterFrame);

            this.addEventListener(Level.EVENT_KILL, destroy);//Forcer le Kill du niveau
            this.addEventListener(Level.EVENT_TERMINATE,prepareDestroy);//Préparer le kill
            this.addEventListener(Level.EVENT_UP, deplacerBalleHaut);//Mouvement vers le haut
            this.addEventListener(Level.EVENT_DOWN, deplacerBalleBas);//Mouvement vers le bas
			this.addEventListener(Level.EVENT_FRAME, decalerNiveau);//Décaler le niveau vers la gauche
            this.addEventListener(Level.EVENT_FRAME, majTerrain);//Rajouter des obstacles si nécessaires
            this.addEventListener(Level.EVENT_FRAME, deplacerBalle);//Déplacer la balle
			
        }

        /**
         * Détruit le niveau et tente de laisser une mémoire relativement propre.
         * Appelé sur le dispatch de EVENT_KILL
         */
        private function destroy(e:Event):void
        {
            //Éviter les destructions multiples d'un même objet
            if (estDetruit)
            {
                trace("Destruction d'un Level déjà supprimé");
                return;
            }
            else
                estDetruit = true;

            //Supprimer les listeners :
            Global.stage.removeEventListener(Level.EVENT_ITERATE, ajouterFrame);
            this.removeEventListener(Level.EVENT_KILL, destroy);
            this.removeEventListener(Level.EVENT_TERMINATE, prepareDestroy);
            this.removeEventListener(Level.EVENT_UP, deplacerBalleHaut);
            this.removeEventListener(Level.EVENT_DOWN, deplacerBalleBas);
			this.removeEventListener(Level.EVENT_FRAME,decalerNiveau);
			this.removeEventListener(Level.EVENT_FRAME,majTerrain);
            this.removeEventListener(Level.EVENT_FRAME, deplacerBalle);

            //Nettoyage des sprites
            this.graphics.clear();
            Balle.graphics.clear();

            //Suppression des childs
            ObstaclesContainer.graphics.clear();
            while (ObstaclesContainer.numChildren != 0)
            {
                if (ObstaclesContainer.getChildAt(0) is Brick)
                    (ObstaclesContainer.getChildAt(0) as Brick).destroy();
                else
                    ObstaclesContainer.removeChildAt(0);
            }
            while (this.numChildren != 0)
                removeChild(this.getChildAt(0));
            parent.removeChild(this);
        }

        /**
         * Prépare à la destruction du level en faisant quelques animations et en supprimant les blocs inutiles
         * Appélé sur le dispatch de EVENT_TERMINATE
         */
        private function prepareDestroy(e:Event):void
        {
            //Arrêter d'écouter le mouvement et le TERMINATE
            Global.stage.removeEventListener(Level.EVENT_ITERATE, ajouterFrame);
            this.removeEventListener(Level.EVENT_TERMINATE, prepareDestroy);

            while (Obstacles.length > Math.floor(NombreColonnes / 2) + 2)
                nettoyerColonne(Obstacles.pop());

			this.graphics.clear();
			estTerminate = true;
        }


///////////////////////////////////////////////////////////////////////////////////////////////
        //GESTION DE LA TAILLE DU NIVEAU

        /**
         * Récupérer le premier bloc dans la colonne passée en paramètre, utile pour connaitre ses coordonnées x.
         */
        private function GetAnItemIn(Colonne:Vector.<Brick>):Brick
        {
            for each(var Obj:Brick in Colonne)
            {
                if(Obj!=null)
                    return Obj;
            }

            //Normalement impossible, car chaque colonne possède au moins un bloc.
            trace("Erreur, aucun élément à renvoyer.");
            return new Brick(new Sprite(),0, 0);
        }

        /**
         * Permet de mettre à jour le calcul du terrain, pour rajouter des blocs si nécessaires et éviter d'avoir un espace vide.
         * Supprime les blocs sortis de l'écran par la gauche.
         */
        private function majTerrain(e:Event=null):void
        {

            //Étape 1 :
            //Supprimer les élements qui n'ont plus rien à faire là
            if (Obstacles.length != 0)
            {
                while (GetAnItemIn(Obstacles[0]).toGlobal().x <= -Global.CaseTaille)
                {
                    nettoyerColonne(Obstacles.shift());
                    Offset++;
                }
            }


            //Étape 2 :
            //Vérifier que la taille du tableau est suffisante. La limite est fixée à NombreColonnes/2 (une colonne sur deux peut être remplie) +1 pour s'assurer qu'on a de l'avance.
            var i:int = 0;

            while(Obstacles.length < Math.floor(NombreColonnes/2) + 2 && Obstacles.length<33)
            {
                var NouvelleColonne:Vector.<Brick> = new Vector.<Brick>(Global.NOMBRE_ETAGES_NIVEAU, true);//Nouvelle colonne, avec NombreLignes items : pas plus, pas moins.
                Obstacles.push(NouvelleColonne);//Le pousser dans les obstacles.
                i = 0;
                while (i==0 || Math.random() < Densite && i < Global.NOMBRE_ETAGES_NIVEAU-1)
                {
                    //Rajouter un item bloquant.
                    var y:int = Math.floor(Global.NOMBRE_ETAGES_NIVEAU * Math.random());
                    if (NouvelleColonne[y] == null)//Si la colonne est vide
                    {
                        i++;
                        NouvelleColonne[y] = new Brick(this.ObstaclesContainer, (Obstacles.length + Offset) * Global.CaseTaille * 2, y * Global.CaseTaille);
                    }
                }

                if (Math.random() < GoodieDensity)
                {
                    i = Math.floor(Global.NOMBRE_ETAGES_NIVEAU * Math.random());
                    while (NouvelleColonne[i] != null) { i = Math.floor(Global.NOMBRE_ETAGES_NIVEAU * Math.random()); }

                    NouvelleColonne[i] = new GoodBadDieDisplay(this.ObstaclesContainer, (Obstacles.length + Offset) * Global.CaseTaille * 2, i * Global.CaseTaille,NouvelleColonne,Global.GOODIE);
                }
                else if (Math.random() < BadieDensity)
                {
                    i = Math.floor(Global.NOMBRE_ETAGES_NIVEAU * Math.random());
                    while (NouvelleColonne[i] != null) { i = Math.floor(Global.NOMBRE_ETAGES_NIVEAU* Math.random()); }

                    NouvelleColonne[i] = new GoodBadDieDisplay(this.ObstaclesContainer, (Obstacles.length + Offset) * Global.CaseTaille * 2, i * Global.CaseTaille, NouvelleColonne, Global.BADIE);
                }
            }
        }

        private function nettoyerColonne(Colonne:Vector.<Brick>):void
        {
            //Supprimer les objets de la colonne
            for each(var Obj:Brick in Colonne)
            {
                if(Obj!=null)
                    Obj.destroy();
            }
        }

///////////////////////////////////////////////////////////////////////////////////////////////
        //GESTION DE LA BALLE

        /**
         * Récupère le bloc approprié par rapport aux coordonnées données.
         * @param X dans le repère global
         * @param Y dans le repère global
         */
        private function getBrick(Gx:int, Gy:int):Brick
        {
			//Récupérer le numéro de colonne sur lequel se trouve le point.
            var i:int = (Gx - (ObstaclesContainer.x + GetAnItemIn(Obstacles[0]).x)) / Global.CaseTaille;
            if (PasseMuraille || i % 2 == 1)
                return null;
            else if (i >= 0 && Gy > 0 && Gy < Global.NOMBRE_ETAGES_NIVEAU * Global.CaseTaille)
            {
                var Devant:Brick = Obstacles[i / 2][Math.floor(Gy / Global.CaseTaille)];
				
				//On vient de prendre un goodie/badie.
				if (Devant != null && Devant is GoodBadDieDisplay)
				{
					if ((Devant as GoodBadDieDisplay).IsGoodie)
						this.dispatchEvent(new Event(Level.EVENT_GOT_GOODIE));
					else
						this.dispatchEvent(new Event(Level.EVENT_GOT_BADIE));
					Devant.destroy(Brick.DESTROY_WITH_ANIMATION);
					Devant = null;
				}
                return Devant;
            }
            else
                return null;
        }
		 /**
         * Idem que la fonction getBrick, mais renvoie null pour les goodies badies
         * @param X dans le repère global
         * @param Y dans le repère global
         */
        private function getOnlyBrick(Gx:int, Gy:int):Brick
        {
            var B:Brick = getBrick(Gx, Gy);
			if (B is GoodBadDieDisplay)
				B = null;
			return B;
        }

        /**
         * Déplace la balle sur l'axe horizontal si nécessaire (et si possible !).
         */
        private function deplacerBalle(e:Event=null):void
        {
            //Le x sur lequel la balle reste au repos
            var PositionEquilibre:int = (NombreColonnes / 2)*Global.CaseTaille;
            var Devant:Brick = getBrick(Balle.x + (Global.CaseTaille / 2 - 1), Balle.y);

            if (Devant != null)
            {
                if (Balle.x + (Global.CaseTaille / 2 - 1) - (ObstaclesContainer.x + Devant.x) > 0 )
                {//Si cette condition est validée, on a "pénétré" un bloc, il faut donc en sortir.
                    Balle.x--;
                }
                Balle.x--;
            }
            else if (Balle.x < PositionEquilibre)//Sinon, rattraper du retard.
                Balle.x++;

			//Dommage, you die !
            if (Balle.x <= 0)
				this.dispatchEvent(new Event(EVENT_LOST));
        }

        /**
         * Monter d'un cran la balle
         * @param L'event Level.UP
         */
        public function deplacerBalleHaut(e:Event):void
        {
			var QuasiDerriereDessus:Brick = getBrick(Balle.x - (Global.CaseTaille / 2 - Global.DELTA_ERR), Balle_y - Global.CaseTaille);
			var QuasiDevantDessus:Brick = getBrick(Balle.x + (Global.CaseTaille / 2 - Global.DELTA_ERR), Balle_y - Global.CaseTaille);
            if (Balle_y > Global.CaseTaille
            && getBrick(Balle.x - (Global.CaseTaille / 2 - Global.DELTA_ERR), Balle_y - Global.CaseTaille) == null
            && getBrick(Balle.x + (Global.CaseTaille / 2 - Global.DELTA_ERR), Balle_y - Global.CaseTaille) == null)
            {
                Balle_y -= Global.CaseTaille;
                TweenMax.to(Balle, Global.TEMPS_DEPLACEMENT / Math.min(5, Jeu.JeuActuel.Vitesse), { y:Balle_y } );
            }
        }

        /**
         * Monter d'un cran la balle
         * @param L'event Level.DOWN
         */
        public function deplacerBalleBas(e:Event):void
        {
            //Si :
            //-on n'est pas tout en bas
            //-devant, c'est libre
            //-derrière, c'est libre (ne pas descendre quand on est dans un goulet)
            if (Balle_y < (Global.NOMBRE_ETAGES_NIVEAU - 1) * Global.CaseTaille
            && getBrick(Balle.x - (Global.CaseTaille / 2 - Global.DELTA_ERR), Balle_y + Global.CaseTaille) == null
            && getBrick(Balle.x + (Global.CaseTaille/2 - Global.DELTA_ERR), Balle_y + Global.CaseTaille) == null)
            {
                Balle_y += Global.CaseTaille;
                TweenMax.to(Balle, Global.TEMPS_DEPLACEMENT / Math.min(5, Jeu.JeuActuel.Vitesse), { y:Balle_y } );
            }
        }

///////////////////////////////////////////////////////////////////////////////////////////////
        //GESTION DES DÉPLACEMENTS

		/**
		 * Décaler le niveau d'un cran pour le jeu.
		 */
		private function decalerNiveau(e:Event):void
		{
			ObstaclesContainer.x--;
		}
		
        /**
         * Appelé sur l'envoi sur stage de Level.EVENT_ITERATE, fait défiler le niveau si la cadence correspond.
         * @param L'event Level.ITERATE
         */
        public function ajouterFrame(e:Event):void
        {
			
			
            DerniereAction++;
            //Par défaut, ne rien faire sauf si on atteint la cadence nécessaire
            for (var i:int = 0; i < Jeu.JeuActuel.Vitesse; i++ )
            {
				//Envoyer un évenement pour faire les màj de niveau
				dispatchEvent(new Event(Level.EVENT_FRAME));
				
				//Jeu perdu :(
				if (Jeu.JeuActuel == null)
					break;
            }
        }
    }
}

