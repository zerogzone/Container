package template
{
	import com.codedrunks.components.flash.Image;
	import com.footprints.ShareService;
	
	import flash.display.Loader;
	import flash.display.Sprite;

	public class Share
	{
		public var loader:Loader;
		public var preloader:Image;
		public var gigyaConfig:Object = new Object();
		public var container:Sprite;
		public var movieClip:MovieClip;
		
		private var embedCode:String;
		private var shareService:ShareService;
		
		public function Share()
		{
			
		}
		
		public function initialize():void
		{
			/* *
			try
			{
				if(!shareService)
				{
					shareService = FootprintsUtil.shareService;
					//shareService.setServiceUrl("embedCode.xml"); //set only if the user want to use its own share tracking.
					shareService.setShareConfig(gigyaConfig);
					shareService.addEventListener(EmbedEvent.COMPLETE, handleEmbedLoadComplete);
					shareService.addEventListener(WildfireEvent.CLOSE, handleWildfireEvents);	
					shareService.addEventListener(WildfireEvent.LOAD, handleWildfireEvents);	
					shareService.generateEmbedCode();
				}
			}
			catch(error:Error)
			{
				trace("Error --> :: [", getQualifiedClassName(FootprintsUtil),']', error.getStackTrace());
				embedCode = configProxy.embedCode;
				loadGigya();
			}
			/* */
		}
	}
}