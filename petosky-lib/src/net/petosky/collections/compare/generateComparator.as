package net.petosky.collections.compare {
	/**
	 * @author Cory
	 */
	public function generateComparator(sortProperty:String, ascending:Boolean):Function {
		if (sortProperty != "") {
			if (ascending)
				return function(o1:*, o2:*):Boolean {
					return o1[sortProperty] < o2[sortProperty];
				};
			else
				return function(o1:*, o2:*):Boolean {
					return o1[sortProperty] > o2[sortProperty];
				};
		} else {
			if (ascending)
				return function(o1:*, o2:*):Boolean {
					return o1 < o2;
				};
			else
				return function(o1:*, o2:*):Boolean {
					return o1 > o2;
				};			
		}	
	}
}
