package net.tanatopia.o2d.xml;

import org.jdom.Document;

/**
 * An interface that specifies a model that can be serialized into XML.
 * @author Cory Petosky
 *
 */
public interface XMLReady {
	public Document getXML();
}
