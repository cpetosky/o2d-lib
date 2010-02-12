using System;
using System.Collections.Generic;
using System.Text;

namespace net.tanatopia.collections {
    class PriorityQueue<T> {
        private T[] items;

        private const int DefaultCapacity = 16;
        private int capacity;
        private int numItems;

        private Comparison<T> compareFunc;

        /// <summary>
        /// Initializes a new instance of the PriorityQueue class that is empty,
        /// has the default initial capacity, and uses the default IComparer.
        /// </summary>
        public PriorityQueue()
            : this(DefaultCapacity, Comparer<T>.Default) {
        }

        /// <summary>
        /// Initializes a new instance of the PriorityQueue class that is empty,
        /// has the specified initial capacity, and uses the default IComparer.
        /// </summary>
        /// <param name="initialCapacity">Desired initial capacity.</param>
        public PriorityQueue(Int32 initialCapacity)
            : this(initialCapacity, Comparer<T>.Default) {
        }

        /// <summary>
        /// Initializes a new instance of the PriorityQueue class that is empty,
        /// has the default initial capacity, and uses the specified IComparer.
        /// </summary>
        /// <param name="comparer">An object that implements the IComparer interface
        /// for items of type T.</param>
        public PriorityQueue(IComparer<T> comparer)
            : this(DefaultCapacity, comparer) {
        }

        /// <summary>
        /// Initializes a new instance of the PriorityQueue class that is empty,
        /// has the specified initial capacity, and uses the specified IComparer.
        /// </summary>
        /// <param name="initialCapacity">Desired initial capacity.</param>
        /// <param name="comparer">An object that implements the IComparer interface
        /// for items of type T.</param>
        public PriorityQueue(int initialCapacity, IComparer<T> comparer) {
            Init(initialCapacity, new Comparison<T>(comparer.Compare));
        }

        /// <summary>
        /// Initializes a new instance of the PriorityQueue class that is empty,
        /// has the default initial capacity, and uses the specified comparison
        /// function for comparing items of type T.
        /// </summary>
        /// <param name="comparison">The comparison function.</param>
        public PriorityQueue(Comparison<T> comparison)
            : this(DefaultCapacity, comparison) {
        }

        /// <summary>
        /// Initializes a new instance of the PriorityQueue class that is empty,
        /// has the specified initial capacity, and uses the specified comparison
        /// function for comparing items of type T.
        /// </summary>
        /// <param name="initialCapacity">The desired initial capacity.</param>
        /// <param name="comparison">The comparison function.</param>
        public PriorityQueue(int initialCapacity, Comparison<T> comparison) {
            Init(initialCapacity, comparison);
        }

        // Initializes the queue
        private void Init(int initialCapacity, Comparison<T> comparison) {
            numItems = 0;
            compareFunc = comparison;
            SetCapacity(initialCapacity);
        }

        /// <summary>
        /// Gets the number of items that are currently in the queue.
        /// </summary>
        public int Count {
            get { return numItems; }
        }

        /// <summary>
        /// Gets or sets the queue's capacity.
        /// </summary>
        public int Capacity {
            get { return items.Length; }
            set { SetCapacity(value); }
        }

        // Set the queue's capacity.
        private void SetCapacity(int newCapacity) {
            int newCap = newCapacity;
            if (newCap < DefaultCapacity)
                newCap = DefaultCapacity;

            // throw exception if newCapacity < numItems
            if (newCap < numItems)
                throw new ArgumentOutOfRangeException("newCapacity", "New capacity is less than Count");

            this.capacity = newCap;
            if (items == null) {
                // Initial allocation.
                items = new T[newCap];
                return;
            }

            // Resize the array.
            Array.Resize(ref items, newCap);
        }

        /// <summary>
        /// Adds an object to the queue, in order by priority.
        /// </summary>
        /// <param name="value">The object to be added.</param>
        /// <param name="priority">Priority of the object to be added.</param>
        public void Enqueue(T value) {
            if (numItems == capacity) {
                // need to increase capacity
                // grow by 50 percent
                SetCapacity((3 * Capacity) / 2);
            }

            // Create the new item
            int i = numItems;
            ++numItems;

            // and insert it into the heap.
            while ((i > 0) && (compareFunc(items[i / 2], value) > 0)) {
                items[i] = items[i / 2];
                i /= 2;
            }
            items[i] = value;
        }

        // Remove a node at a particular position in the queue.
        private T RemoveAt(Int32 index) {
            // remove an item from the heap
            T o = items[index];
            T tmp = items[numItems - 1];
            items[--numItems] = default(T);
            if (numItems > 0) {
                int i = index;
                int j = i + 1;
                while (i < Count / 2) {
                    if ((j < Count - 1) && (compareFunc(items[j], items[j + 1]) < 0)) {
                        j++;
                    }
                    if (compareFunc(items[j], tmp) <= 0) {
                        break;
                    }
                    items[i] = items[j];
                    i = j;
                    j *= 2;
                }
                items[i] = tmp;
            }
            return o;
        }

        /// <summary>
        /// Removes and returns the item with the highest priority from the queue.
        /// </summary>
        /// <returns>The object that is removed from the beginning of the queue.</returns>
        public T Dequeue() {
            if (Count == 0)
                throw new InvalidOperationException("The queue is empty");
            return RemoveAt(0);
        }

        /// <summary>
        /// Removes the item with the specified value from the queue.
        /// The passed equality comparison is used.
        /// </summary>
        /// <param name="item">The item to be removed.</param>
        /// <param name="comp">An object that implements the IEqualityComparer interface
        /// for the type of item in the collection.</param>
        public void Remove(T item, IEqualityComparer<T> comparer) {
            // need to find the PriorityQueueItem that has the Data value of o
            for (int index = 0; index < numItems; ++index) {
                if (comparer.Equals(item, items[index])) {
                    RemoveAt(index);
                    return;
                }
            }
            throw new ApplicationException("The specified itemm is not in the queue.");
        }

        /// <summary>
        /// Removes the item with the specified value from the queue.
        /// The default type comparison function is used.
        /// </summary>
        /// <param name="item">The item to be removed.</param>
        public void Remove(T item) {
            Remove(item, EqualityComparer<T>.Default);
        }

        /// <summary>
        /// Returns the object at the beginning of the priority queue without removing it.
        /// </summary>
        /// <returns>The object at the beginning of the queue.</returns>
        public T Peek() {
            if (Count == 0)
                throw new InvalidOperationException("The queue is empty");
            return items[0];
        }

        /// <summary>
        /// Removes all objects from the queue.
        /// </summary>
        public void Clear() {
            numItems = 0;
            TrimExcess();
        }

        /// <summary>
        /// Sets the capacity to the actual number of elements in the Queue,
        /// if that number is less than 90 percent of current capacity. 
        /// </summary>
        public void TrimExcess() {
            if (numItems < (0.9 * capacity))
                SetCapacity(numItems);
        }

        /// <summary>
        /// Determines whether an element is in the queue.
        /// </summary>
        /// <param name="o">The object to locate in the queue.</param>
        /// <returns>True if item found in the queue.  False otherwise.</returns>
        public bool Contains(T item) {
            foreach (T qItem in items) {
                if (qItem.Equals(item))
                    return true;
            }
            return false;
        }

        /// <summary>
        /// Copies the elements of the ICollection to an Array, starting at a particular Array index. 
        /// </summary>
        /// <param name="array">The one-dimensional Array that is the destination of the elements copied from ICollection.
        /// The Array must have zero-based indexing.</param>
        /// <param name="arrayIndex">The zero-based index in array at which copying begins.</param>
        public void CopyTo(T[] array, int arrayIndex) {
            if (array == null)
                throw new ArgumentNullException("array");
            if (arrayIndex < 0)
                throw new ArgumentOutOfRangeException("arrayIndex", "arrayIndex is less than 0.");
            if (array.Rank > 1)
                throw new ArgumentException("array is multidimensional.");
            if (arrayIndex >= array.Length)
                throw new ArgumentException("arrayIndex is equal to or greater than the length of the array.");
            if (numItems > (array.Length - arrayIndex))
                throw new ArgumentException("The number of elements in the source ICollection is greater than the available space from arrayIndex to the end of the destination array.");

            Array.Copy(items, 0, array, arrayIndex, numItems);
        }

        /// <summary>
        /// Copies the queue elements to a new array. 
        /// </summary>
        /// <returns>A new array containing elements copied from the Queue.</returns>
        public T[] ToArray() {
            T[] newItems = new T[numItems];
            Array.Copy(items, newItems, numItems);
            return newItems;
        }
    }
}