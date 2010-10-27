package
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import com.codedrunks.components.flash.Image;
	import com.codedrunks.components.flash.Share;
	import com.codedrunks.components.flash.Twitter;
	import com.codedrunks.facebook.FacebookGraphAPI;
	import com.codedrunks.facebook.events.FacebookGraphAPIEvent;
	import com.codedrunks.socnet.SocnetAPI;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserInfoEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	import flash.utils.ByteArray;
	
	import sk.yoz.events.FacebookOAuthGraphEvent;
	import sk.yoz.net.FacebookOAuthGraph;
	
	public class Template extends MovieClip
	{
		private var flashvars:Object;
		private var applicationID:String = "155442984483491";
		private var secretKey:String = "94e365d702169396f836222cfa166fed";
		private var scope:String = "publish_stream,user_photos";
		private var redirectURI:String = "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/callback.html";
		
		private var socnetAPI:SocnetAPI;
		private var profilePicLoader:Loader;
		
		private var twitter:Twitter;
		private var share:Share;
		private var embedCode:String;
		private var wildfireUIConfig:String;
		
		private var memberId:String;
		
		//private var footprintsUrl:FootprintsUtil;
		
		public function Template()
		{
			super();
		}
		
		public function setFlashvars(parameters:Object):void
		{
			flashvars = parameters;
			init();
		}
		
		private function init():void
		{
			loadConfig();
				
			addToFacebookBtn.addEventListener(MouseEvent.CLICK, handleAddToFacebookBtnClick);
			shareBtn.addEventListener(MouseEvent.CLICK, handleShareBtnClick);
			twitterBtn.addEventListener(MouseEvent.CLICK, handleTwitterBtnClick);
		}
		
		/**
		@ loads the config xml	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code></code>
		@ return void
		*/
		private function loadConfig():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleConfigLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleConfigLoadIOError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleConfigLoadSecurityError);
			urlLoader.load(new URLRequest(flashvars.configUrl));
		}
		
		/**
		@ handles the load IO error event	
				 	 
		@ method dispose (private)
		@ params event:IOErrorEvent.
		@ usage <code></code>
		@ return void
		*/			
		private function handleConfigLoadIOError(event:IOErrorEvent):void
		{
			trace("Error --> Failed loading 'url' due to IO Error.");
		}
		
		/**
		@ handles the load security error	event
				 	 
		@ method dispose (private)
		@ params event:SecurityErrorEvent.
		@ usage <code></code>
		@ return void
		*/			
		private function handleConfigLoadSecurityError(event:SecurityErrorEvent):void
		{
			trace("Error --> Failed loading 'url' due to security reasons.");
		}
		
		/**
		@ handles the load complete event	
				 	 
		@ method dispose (private)
		@ params event:Event.
		@ usage <code></code>
		@ return void
		*/			
		private function handleConfigLoadComplete(event:Event):void
		{
			var xml:XML = XML(event.target.data);
			
			embedCode = xml.embedCode;
			wildfireUIConfig = xml.wildfireConfig;
			
			var tokens:XMLList = xml..token;
			for each (var token:XML in tokens) {
				var tokenValue:String = flashvars[token.@name];
				
				if (tokenValue == null) {
					tokenValue = token.@value;
				}
				/* *
				if (!httpRe.test(tokenValue as String) && urlTokens[token.@name] == true) {
					tokenValue = baseUrl + tokenValue;	
				}
				/* */
				
				flashvars[token.@name] = tokenValue;
			}
			
			initSocnet();
		}
		
		private function initSocnet():void
		{
			socnetAPI = SocnetAPI.getInstance();
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			socnetAPI.initialize(flashvars, applicationID, secretKey, scope, redirectURI);
		}
		
		private function handleSocnetInitializeFail(event:SocnetAPIEvent):void
		{
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
		}
		
		private function handleSocnetInitialize(event:SocnetAPIEvent):void
		{
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			
			fetchAuthorProfile();
		}
		
		private function fetchAuthorProfile():void
		{
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
			socnetAPI.getProfileInfo();			
		}
		
		
		private function handleProfileInfoFetch(event:SocnetUserInfoEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
			
			profileMc.profileName.text = event.userName;
			var image:Image = new Image();
			image.source = event.userPic;
			image.width = profileMc.profilePic.width;
			image.height = profileMc.profilePic.height;
			
			profileMc.profilePic.addChild(image);
		}
		
		private function handleProfileInfoFail(event:SocnetUserInfoEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
		}
		
		private function handleAddToFacebookBtnClick(event:MouseEvent):void
		{
			socnetAPI.publishToFeed("This is a test message", null, "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/assets/images/cover.png", "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/index.html", "Container Test", "FB Container and Template", "This is to test the FB Container and the Template application", "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/Container.swf");
		}
		
		private function handleShareBtnClick(event:MouseEvent):void
		{
			if(!share)
			{
				embedCode = StringUtil.replace(embedCode, "|userId|", memberId);
				share = new Share();
				share.addEventListener(Share.CLOSE_EVENT, handleShareClose);
				share.configure(embedCode, wildfireUIConfig, 400, 400);
				share.x = 0;
				share.y = 0;
			
				this.addChild(share);
			}
			share.visible = true;
		}
		
		private function handleShareClose(event:Event):void
		{
			share.visible = false;
		}
		
		private function handleTwitterBtnClick(event:MouseEvent):void
		{
			if(!twitter)
			{
				var tweetrProxy:String = flashvars.twitterProxy;
				var tweetrUserName:String = flashvars.twitterUserName;
				
				twitter = new Twitter();
				twitter.addEventListener(Twitter.CLOSE_EVENT, handleTwitterClose);
				twitter.configure(tweetrUserName, tweetrProxy);
				this.addChild(twitter);
			}
			twitter.visible = true;
		}
		
		private function handleTwitterClose(event:Event):void
		{
			twitter.visible = false;			
		}
		
	}
}