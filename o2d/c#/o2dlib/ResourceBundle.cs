using System;
using System.Collections.Generic;
using System.Text;

namespace o2dlib {
    public enum ResourceType {
        Wood, Hide, Grain, Metal
    }

    public class ResourceBundle : IEnumerable<Resource> {
        private List<Resource> resources = new List<Resource>();

        public ResourceBundle() {
            resources.Add(new Resource(ResourceType.Wood));
            resources.Add(new Resource(ResourceType.Hide));
            resources.Add(new Resource(ResourceType.Grain));
            resources.Add(new Resource(ResourceType.Metal));
        }

        public Resource this[int x] {
            get { return resources[x]; }
        }

        public Resource this[uint x] {
            get { return resources[(int)x]; }
        }

        #region IEnumerable<Resource> Members

        public IEnumerator<Resource> GetEnumerator() {
            return new Enumerator(this);
        }

        private class Enumerator : IEnumerator<Resource> {
            private ResourceBundle bundle;
            private int currentIndex = -1;

            internal Enumerator(ResourceBundle bundle) {
                this.bundle = bundle;
            }

            #region IEnumerator<Resource> Members

            public Resource Current {
                get {
                    if (currentIndex == -1 || currentIndex == bundle.resources.Count)
                        throw new InvalidOperationException();
                    return bundle[currentIndex];
                }
            }

            #endregion

            #region IDisposable Members

            public void Dispose() {
                
            }

            #endregion

            #region IEnumerator Members

            object System.Collections.IEnumerator.Current {
                get {
                    return Current;
                }
            }

            public bool MoveNext() {
                if (currentIndex > bundle.resources.Count)
                    throw new InvalidOperationException();
                return ++currentIndex < bundle.resources.Count;
            }

            public void Reset() {
                currentIndex = -1;
            }

            #endregion
        }

        #endregion

        #region IEnumerable Members

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() {
            return GetEnumerator();
        }

        #endregion
    }
}