package Instance
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Une brique dans un niveau.
     * @author Neamar
     */
    public class Brick extends Sprite
    {
        /**
         * Paramètre de la fonction destroy pour fair eune animation sur la destruction.
         */
        public static var DESTROY_WITH_ANIMATION:Boolean = false;

        /**
         * Crée une nouvelle brique qui sera affichée dans le niveau
         * @param Le niveau conteneur, ou plus préciséement le Sprtie dans lequel la brique doit être affichée
         * @param Coordonnée x
         * @param Coordonnée y
         */
        public function Brick(Parent:Sprite,x:int,y:int)
        {

            Parent.addChild(this);
            this.graphics.lineStyle(1, Global.WHITE);
			this.graphics.beginFill(Global.BLACK);
            this.graphics.drawRect(0, 0, Global.CaseTaille, Global.CaseTaille);
			//trace(Global.CaseTaille, Global.CaseTaille);
			//var img_nuage:Bitmap = new Global.Img_Nuage1();
			//addChild(img_nuage);
			

            this.x = x;
            this.y = y;
        }

        /**
         * Détruit l'objet, appelle automatiquement removeChild()
         * @param Rapide Si true, aucune animation n'est effectuée. Inutile sur Brick, utilisé sur les classes qui en héritent.
         */
        public function destroy(Rapide:Boolean=true):void
        {
            if (parent != null)
                parent.removeChild(this);
        }

        public function toGlobal():Point
        {
            return new Point(this.x + parent.x/this.parent.scaleX, this.y + this.parent.y/parent.scaleY);
        }
    }
}
