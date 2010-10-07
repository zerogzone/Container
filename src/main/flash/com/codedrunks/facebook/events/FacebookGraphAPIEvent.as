package com.codedrunks.facebook.events
{
	import flash.events.Event;
	
	public class FacebookGraphAPIEvent extends Event
	{
		public var name:String;
		public var picture:String;
		
		public static const FB_API_INITIALIZED:String = "fbApiInitialized";
		public static const FB_API_INITIALIZATION_FAILED:String = "fbApiInitializationFailed";
		
		public static const USER_INFO_SUCCESS:String = "userInfoSuccess";
		public static const USER_INFO_FAIL:String = "userInfoFail";
		
		public var userName:String;
		public var userPic:String;
		public var userId:String;
		
		public function FacebookGraphAPIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}