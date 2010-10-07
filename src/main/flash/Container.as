package
{
	import com.hurlant.util.Base64;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class Container extends Sprite
	{
		private var preloader:MovieClip;
		private var app:MovieClip;
		
		public function Container()
		{
			var parameters:Object = this.loaderInfo.parameters;
			trace("debug --> INIT CONTAINER", this.loaderInfo.parameters);
			for (var i:String in parameters)
			{
				trace("debug --> flashvars - i :: ", i, ", parameters[i] :: ", parameters[i]);
			}
			/* *
			var signedRequest:String = parameters.signed_request as String;
			var authToken:String = parseSignedRequest(signedRequest);
			/* */
			
			loadPreloader();
		}
		
		/**
		@ parse signed_request	
				 	 
		@ method dispose (private)
		@ params signedRequest:String.
		@ usage <code></code>
		@ return String
		private function parseSignedRequest(signedRequest:String):String
		{
			var tmpArr:Array = signedRequest.split(".");
			var encodedSig:String = tmpArr[0];
			var sig:String = Base64.decode(encodedSig);
			trace("debug --> encodedSig :: ", encodedSig);
			trace("debug --> sig :: ", sig);
			return sig;
			//var payload:String = tmpArr[1];
		}
		*/
		
		/**
		@ loads the preloader	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function loadPreloader():void
		{
			var url:String = "assets/preloader/ContainerPreloader.swf";
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handlePreloaderLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlePreloaderLoadIOError);
			loader.load(new URLRequest(url));
		}
		
		/**
		@ handles preloader load complete event	
				 	 
		@ method dispose (private)
		@ params event:Event.
		@ usage <code>usage</code>
		@ return void
		*/
		private function handlePreloaderLoadComplete(event:Event):void
		{
			trace("debug --> PRELOADER LOADED");
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, handlePreloaderLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlePreloaderLoadIOError);
			
			preloader = loaderInfo.content as MovieClip;
			preloader.x = (stage.stageWidth - preloader.width)/2;
			preloader.y = (stage.stageHeight - preloader.height)/2;
			
			this.addChild(preloader);
			
			loadApp();
		}
		
		/**
		@ handle preloader Load IO Error	
				 	 
		@ method dispose (private)
		@ params event:IOErrorEvent.
		@ usage <code>usage</code>
		@ return void
		*/
		private function handlePreloaderLoadIOError(event:IOErrorEvent):void
		{
			event.target.removeEventListener(Event.COMPLETE, handlePreloaderLoadComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, handlePreloaderLoadIOError);
			trace("Error --> PRELOADER LOAD FAILED");
		}
		
		/**
		@ loads the actual application	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function loadApp():void
		{
			var url:String = "Template.swf";
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleAppLoadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleAppLoadProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleAppLoadIOError);
			loader.load(new URLRequest(url));
		}
		
		/**
		@ handles the load progress	
				 	 
		@ method dispose (private)
		@ params event:ProgressEvent.
		@ usage <code></code>
		@ return void
		*/
		private function handleAppLoadProgress(event:ProgressEvent):void
		{
			var progress:int = event.bytesLoaded*100/event.bytesTotal;
			if(preloader.setLoadProgress)
			{
				preloader.setLoadProgress(progress, "Loading .. ", "%");
			}
		}
		
		/**
		@ handles the application load complete	
				 	 
		@ method dispose (private)
		@ params event:Event.
		@ usage <code></code>
		@ return void
		*/
		private function handleAppLoadComplete(event:Event):void
		{
			preloader.visible = false;
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			app = loaderInfo.content as MovieClip;
			
			if(app.setFlashvars)
			{
				app.setFlashvars(this.loaderInfo.parameters);
			}
			
			trace("debug --> APP LOAD COMPLETE", app);
			this.addChild(app);
		}
		
		/**
		@ handles app load io error	
				 	 
		@ method dispose (private)
		@ params event:IOErrorEvent.
		@ usage <code></code>
		@ return void
		*/
		private function handleAppLoadIOError(event:IOErrorEvent):void
		{
			trace("debug --> APP LOAD ERROR", this);	
		}
		
	}
}