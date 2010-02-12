package net.petosky.spelling {

	/**
	 * @author Cory
	 */
	public class StandardSpellchecker extends Spellchecker {
		
		public function StandardSpellchecker()  {
			addWords(STRING_1.split(","));
			addWords(STRING_2.split(","));
			addWords(STRING_3.split(","));
			addWords(STRING_4.split(","));
			addWords(STRING_5.split(","));
			addWords(STRING_6.split(","));
		}
	}
}
