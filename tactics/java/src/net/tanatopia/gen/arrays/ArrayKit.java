package net.tanatopia.gen.arrays;

/**
 A collection of static methods used to manipulate arrays.

 @author Cory Petosky
 @version 1.0, 07/10/2004

*/
public class ArrayKit {
	/**
	 Sorts (via an insertion sort) an array of Comparables.

	 @param 	x	the array to sort
	*/
	public static void sort(Comparable[] x) {
		boolean found;
		Comparable insert;
		int j;

		for (int i = 1; i < x.length; i++) {
			found = false;
			j = i;
			insert = x[i];
			while (!found && (j > 0)) {
				if (insert.compareTo(x[j - 1]) < 0) {
					x[j] = x[j - 1];
					j--;
				}
				else {
					found = true;
				}
			}
			x[j] = insert;
		}
	}

	/**
	 Searches (via a binary search) an array of Comparables for a specific key.

	 @param		data	the array to search
	 @param		key		the key to search for

	 @return	position of key, if key is found, or -1
	*/
	public static int search(Comparable[] data, Comparable key) {
		int low = 0;
		int high = data.length - 1;

		while(high >= low) {
			int middle = (low + high) / 2;
			if(data[middle].compareTo(key) == 0)
				return middle;
			else if(data[middle].compareTo(key) < 0)
				low = middle + 1;
			else if(data[middle].compareTo(key) > 0)
				high = middle - 1;
		}
		return -1;
	}
}