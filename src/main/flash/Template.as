package
{
	import com.adobe.serialization.json.JSON;
	import com.codedrunks.components.flash.Image;
	import com.codedrunks.facebook.FacebookGraphAPI;
	import com.codedrunks.facebook.events.FacebookGraphAPIEvent;
	import com.codedrunks.socnet.SocnetAPI;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserInfoEvent;
	//import com.codedrunks.util.FootprintsUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
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
			socnetAPI = SocnetAPI.getInstance();
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			socnetAPI.initialize(flashvars, applicationID, secretKey, scope, redirectURI);
			
			addToFacebookBtn.addEventListener(MouseEvent.CLICK, handleAddToFacebookBtnClick);
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
	}
}