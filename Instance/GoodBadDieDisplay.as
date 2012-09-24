package Instance
{
    import com.greensock.TweenMax;
    import flash.display.Sprite;

    /**
     * Un bloc bien ou pas bien, amenant des bonus ou malus au niveau.
     * @author Neamar
     */
    public class GoodBadDieDisplay extends Brick
    {
        /**
         * S'agit-il d'un bonus ou d'un malus ?
         */
        public var IsGoodie:Boolean;

        /**
         * La colonne qui contient l'objet
         */
        protected var Container:Vector.<Brick>;

        /**
         * Constructeur de l'objet
         * @param Parent L'objet conteneur.
         * @param Coordonnée x
         * @param Coordonnée y
         * @param IsGoodie Détermine s'il s'agit d'un bonus ou d'un malus.
         */
        public function GoodBadDieDisplay(Parent:Sprite,x:int, y:int,Container:Vector.<Brick>, IsGoodie:Boolean)
        {
            this.Container = Container;


            this.IsGoodie = IsGoodie;
            super(Parent, x, y);
			
			this.graphics.clear();
			this.graphics.lineStyle(1, IsGoodie ? Global.GREEN : Global.RED);
			this.graphics.beginFill(Global.BLACK);
            this.graphics.drawRoundRect(0, 0, Global.CaseTaille, Global.CaseTaille,10,10);

        }

        /**
         * Détruit l'objet, appelle automatiquement removeChild()
         * @param Rapide Si true, aucune animation n'est effectuée.
         */
        public override function destroy(Rapide:Boolean=true):void
        {
            //Si le mode rapide est activé, la colonne peut ne plus exister, ou la brique est hors écran et ne nécessite donc pas d'animation.
            if (Rapide)
                super.destroy();
            else
            {
                Container[Container.indexOf(this)] = null;
                Container = null;
                TweenMax.to(this, .5, { scaleX:.1, scaleY:.1, x:this.x + Global.CaseTaille / 2, y:this.y + Global.CaseTaille / 2, onComplete:super.destroy } );
            }
        }
    }

}
