﻿package utils.proxies {	import flash.events.EventDispatcher;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.net.URLLoader;	import flash.net.URLLoaderDataFormat;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	/**	USED TO SEND VARIABLES TO PHP AND FIRE AN EVENT ON SUCCESS / FAIL	 * @author acolling	 */	public class PHPVarsProxy extends EventDispatcher {		public static const SUCCESS : String = "SUCCESS";		public static const FAIL : String = "FAIL";				// changes into urlvars obj		public  function sendVars(url : String, o : Object) : void {			var vars : URLVariables = new URLVariables();			for (var s:String in o) {				var varToSend : String = o[s];				var varName : String = s;				vars[varName] = varToSend;			}			sendData(url, vars);		}		private function sendData(url : String, _vars : URLVariables) : void {			//trace("sending:"+url+_vars.toString());			var request : URLRequest = new URLRequest(url);			var loader : URLLoader = new URLLoader();			loader.dataFormat = URLLoaderDataFormat.VARIABLES;			request.data = _vars;			request.method = URLRequestMethod.POST;			loader.addEventListener(Event.COMPLETE, handleComplete);			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);			loader.load(request);		}		private function handleComplete(event : Event) : void {			var loader : URLLoader = URLLoader(event.target);			var retS:int = loader.data.toString().indexOf("success");			var success:Boolean = retS>-1;			var type:String = (success)? SUCCESS : FAIL;			var e:Event = new Event(type, true);			dispatchEvent(e);		}		private function onIOError(event : IOErrorEvent) : void {			trace("Error loading URL.");			var e:Event = new Event(FAIL, true);			dispatchEvent(e);		}	}}