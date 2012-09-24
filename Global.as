package
{
	import flash.display.Sprite;
    import flash.display.Stage;
	import Interface.Cube;
    import Interface.Menu;

    /**
     * Package avec toutes les propriétés globales du jeu. Leur modification permet de changer le gameplay sans recoder les fonctionnalités.
     * @author Neamar
     */
    public class Global
    {
        /**
         * Taille du fichier SWF.
         */
        public static const WIDTH:int = 800;
        public static const HEIGHT:int = 600;


        /**
         * Liste de couleurs
         */
        public static const WHITE:int = 0xFFFFFF;
        public static const BLACK:int = 0x000000;
        public static const RED:int = 0xFF0000;
        public static const GREEN:int = 0x00FF00;
        public static const BLUE:int = 0x0000FF;

        /**
         * Concernant les niveaux :
         */
		public static var NOMBRE_NIVEAUX:int = 3;
        public static var NOMBRE_ETAGES_NIVEAU:int = 3;
        public static var Densite:Number = 0.5;
        
        public static var CaseTaille:int = HEIGHT / (NOMBRE_NIVEAUX * NOMBRE_ETAGES_NIVEAU);
		//public static var CaseTaille:int = CaseTaille;
		
        public static const TEMPS_DEPLACEMENT:Number = .5;
        public static const DELTA_ERR:Number = 2;
        public static var GOOD_DENSITY:Number = 0.05;
        public static var BAD_DENSITY:Number = 0.05;
        public static var GOODIE:Boolean = true;
        public static var BADIE:Boolean = false;


        /**
         * Enregistrer qui est le stage pour pouvoir y accéder depuis toutes les classes
         */
        public static var stage:Stage;
		
		/**
		 * Assets
		 */
		[Embed(source="Assets/IcySun & Neamar Logo.png")]
		public static const Img_Logo:Class;
		
		[Embed(source="Assets/Nuage1.png")]
		public static const Img_Nuage1:Class;
    }
}

