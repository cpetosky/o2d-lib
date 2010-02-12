package net.petosky.util {
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * @author Cory Petosky
	 */
	public dynamic class NumberProtector extends Proxy {

		private var _salts:Object = {};
		private var _diffs:Object = {};
		
		override flash_proxy function getProperty(name:*):* {
			if (flash_proxy::hasProperty(name))
				return _salts[name] + _diffs[name];
			else
				return undefined;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var salt:uint = NumberUtils.randInt(value);
			_salts[name] = salt;
			_diffs[name] = value - salt;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return (_salts[name] != undefined);
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			if (flash_proxy::hasProperty(name)) {
				delete _salts[name];
				delete _diffs[name];
				return true;
			} else {
				return false;
			}
		}
	}
}
