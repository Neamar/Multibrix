package Interface {
    import com.greensock.easing.Bounce;
    import com.greensock.events.TweenEvent;
    import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
	import flash.text.TextField;
    import Interface.Face;
    import mochi.as3.MochiScores;

    /**
     * ...
     * @author Nicolas BARRET
     */
    public class Cube extends Sprite
    {
        /**
         * La variable privée qui contient l'unique instance de cube à utiliser.
         */
        private static var TheCube:Cube = null;

        /**
         * Les différentes faces du cube
         */
        public static var Menu_Principal:Menu = new Menu();
		public static var Menu_Pause:Menu = new Menu();
        public static var JeuConteneur:Sprite = new Sprite();
        public static var HighScore:MovieClip = new MovieClip();
        public static var Options:Sprite = new Sprite();

        /**
         * Variables pour l'affichage des highscores mochiads
         */
        private static var o:Object = { n: [13, 13, 9, 7, 5, 4, 5, 6, 6, 1, 8, 1, 4, 0, 5, 6], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
        private static var boardID:String = o.f(0, "");


        private var Faces_Tab:Vector.<Face> = new Vector.<Face>;

        public function Cube(stage:Stage)
        {
            //Ne pas autoriser la double initalisation d'un cube.
            if (TheCube != null)
                return;


            //Face0 : Pub
			var img_cont:Sprite = new Sprite();
			img_cont.addChild(new Global.Img_Logo());
			
            var Face0:Face = new Face(0xFFFFFF, img_cont);

            var mat3D:Matrix3D = new Matrix3D();
            mat3D.appendRotation(90, Vector3D.Y_AXIS);
            mat3D.appendTranslation(-Global.WIDTH / 2, 0, 0);
            Face0.transform.matrix3D = mat3D;

            //Face1 : Menu Principal
			var face_Menu_Principal:Sprite = new Sprite();
			face_Menu_Principal.addChild(Cube.Menu_Principal);
			var credits:TextField = new TextField();
			credits.text = "Designed by Neamar and IcySun Studio\n© 2010";
			credits.selectable = false;
			credits.width = 300;
			credits.height = 40;
			credits.y = Global.HEIGHT - credits.height;
			face_Menu_Principal.addChild(credits);
			
			
			var Face1:Face = new Face(0xFFFFFF, face_Menu_Principal);
            Cube.Menu_Principal.Cont = Face1;

            mat3D = new Matrix3D();
            mat3D.appendTranslation( 0, 0, -Global.WIDTH / 2);
            Face1.transform.matrix3D = mat3D;

            //Face2 : Jeu
            var Face2:Face = new Face(0xFFFFFF, Cube.JeuConteneur);
            Cube.Menu_Pause.x = -Global.WIDTH / 2;
            Cube.Menu_Pause.y = -Global.HEIGHT / 2;
            Cube.Menu_Pause.Cont = Face2;

            mat3D = new Matrix3D();
            mat3D.appendRotation(-90, Vector3D.Y_AXIS);
            mat3D.appendTranslation(Global.WIDTH / 2, 0, 0);
            Face2.transform.matrix3D = mat3D;

            //Dessus : HighScore
            var Dessus:Face = new Face(0xFFFFFF, Cube.HighScore, true);

            mat3D = new Matrix3D();
            mat3D.appendRotation(-90, Vector3D.X_AXIS);
            mat3D.appendTranslation(0, -Global.HEIGHT / 2, 0);
            Dessus.transform.matrix3D = mat3D;

            //Dessous : Options
            /*var Dessous:Face = new Face(0xFFFFFF, Cube.Options, true);

            mat3D = new Matrix3D();
            mat3D.appendRotation(90, Vector3D.X_AXIS);
            mat3D.appendTranslation(0, Global.HEIGHT / 2, 0);
            Dessous.transform.matrix3D = mat3D;*/

            //addChild
            //addChild(Dessous);
            addChild(Dessus);
            addChild(Face2);
            addChild(Face1);
            addChild(Face0);
            Faces_Tab.push(Face0, Face1, Face2, Dessus)//, Dessous);

            //Fin
            Cube.TheCube = this;
            x = Global.WIDTH / 2;
            y = Global.HEIGHT / 2;
            z = Global.WIDTH / 2;
            rotationY = -90;
            stage.addChild(this);

        }

        public static function gotoJeu():void {
            TweenMax.to(TheCube, 1, { rotationY:90, ease:Bounce.easeOut } );
            TweenMax.delayedCall(0.2, zOrder, [2]);
        }

        public static function gotoHighScoreFromMenu():void {
            TweenMax.to(TheCube, 1, { rotationX:90, ease:Bounce.easeOut } );
            TweenMax.delayedCall(0.2, zOrder, [3]);

            MochiScores.showLeaderboard( { boardID: boardID, onClose: gotoMenu, res:"800x600" } );
        }

        public static function gotoHighScoreFromJeu(score:int):void {
            TweenMax.to(TheCube, 1, { rotationY:0, rotationX:90, ease:Bounce.easeOut } );
            TweenMax.delayedCall(0.2, zOrder, [3]);

            MochiScores.showLeaderboard( { boardID: boardID, onClose: gotoMenu, score:score, res:"800x600" } );
        }

        /*public static function gotoOptions():void {
            TweenMax.to(TheCube, 1, { rotationX:-90, ease:Bounce.easeOut } );
            TweenMax.delayedCall(0.2, zOrder, [4]);
        }*/

        public static function gotoMenu():void {
            TweenMax.to(TheCube, 1, { rotationY:0, rotationX:0, ease:Bounce.easeOut } );
            TweenMax.delayedCall(0.2, zOrder, [1]);
        }

        private static function zOrder(face:int):void{
            TheCube.setChildIndex(Cube.TheCube.Faces_Tab[face], TheCube.numChildren - 1);
        }
    }
}

