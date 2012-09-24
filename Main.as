package {
	import com.greensock.plugins.BlurFilterPlugin;
    import com.greensock.plugins.ColorTransformPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.greensock.TweenMax;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import Interface.Cube;
    import Interface.Menu;
    import mochi.as3.*;

	[SWF(backgroundColor='#000000', frameRate='27', width='800', height='600')]

    /**
     * ...
     * @author Nicolas BARRET
     */
    public class Main extends Sprite {
        public function Main():void {
            Global.stage = stage;

            TweenPlugin.activate([ColorTransformPlugin, BlurFilterPlugin]);

            include 'Interface/Menus.as';

            new Cube(stage);
            MochiServices.connect("e52a0665955cf6e6", Cube.HighScore);

            //La ligne miracle, que j'en ai chié à trouver la première fois ^^ (j'plaisante).
            //Bizarrement, ça marche pas la première fois, je pense quand il communique avec le serveur pour la première fois.
            //Il faut donc lancer deux fois le flash player, et si la pub ne s'affiche toujours pas,
            //quitter flash ET flashdevelop, puis le relancer. Normalement ça fonctionne :)

            TweenMax.delayedCall(0, startGame);
        }
		
		private function startGame():void {
			Cube.Menu_Principal.Show();
            Cube.gotoMenu();
		}
    }
}