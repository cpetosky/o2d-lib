using System;
using System.Collections.Generic;
using System.Text;

namespace o2d {
    public class Resource {
        private ResourceType type;
        private int quantity;

        public Resource(ResourceType type) : this(type, 0) { }

        public Resource(ResourceType type, int quantity) {
            this.type = type;
            this.quantity = quantity;
        }

        public ResourceType Type {
            get { return type; }
        }

        public int Quantity {
            get { return quantity; }
        }
    }
}