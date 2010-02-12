package net.petosky.o2d.script {

	/**
	 * @author Cory
	 */
	public class ScriptSyntaxError extends Error {
		public function ScriptSyntaxError(script:String, handler:String, line:String, message:String) {
			super("[" + script + ":" + handler + "] " + message + "\n\tat: " + line);
		}
	}
}
