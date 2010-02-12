package net.petosky.dungeon.party {

	/**
	 * @author Cory Petosky
	 */
	public class JobManager {
		private static var __instance:JobManager;
		
		public static function get instance():JobManager {
			if (!__instance)
				__instance = new JobManager(new SingletonEnforcer());
			return __instance;
		}
		
		private var _jobsByName:Object = {};
		private var _jobsByID:Array = [];
		
		public function JobManager(enforcer:SingletonEnforcer) {
			var baseJob:Job = new Job(0, "Jobless");
			_jobsByName["Jobless"] = baseJob;
			_jobsByID[0] = baseJob;
			
		}
		
		public function getJobByName(name:String):Job {
			return _jobsByName[name];
		}
		
		public function getJobByID(id:int):Job {
			return _jobsByID[id];
		}
		
		public function get defaultJob():Job {
			return _jobsByName["Jobless"];
		}
	}
}

class SingletonEnforcer { }