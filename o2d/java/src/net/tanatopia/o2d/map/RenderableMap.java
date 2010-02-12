package net.tanatopia.o2d.map;


/**
 * A RenderableMap is used to display a map in an accelerated environment,
 * such as the game's client.
 * @author Cory Petosky
 *
 */
public class RenderableMap extends Map {
	
	private RenderableLayer[] layers = new RenderableLayer[4];
	
	// Controls map zoom -- 1 is normal view, 0.5 is half out, 2 is double, etc.
	private double zoom = 1;
	
	public RenderableMap(Map map) {
		super(map);
		for (int i = 0; i < LAYERS; ++i) {
			layers[i] = new RenderableLayer(this, i);
		}
	}
	
	/**
	 * Returns the zoom of the map, where 1 is normal, 0.5 is half size, 2 is
	 * double size, etc.
	 * 
	 * @return zoom
	 */
	public double getZoom() {
		return zoom;
	}
	
	/**
	 * Sets the zoom of the map, where 1 is normal, 0.5 is half size, 2 is
	 * double size, etc. Since this is a double value, and because textures
	 * are sized by powers of two, this should only be a (positive or negative)
	 * power of two as well, to assure the map displays correctly.
	 * 
	 * @param zoom The zoom level of the map.
	 */
	public void setZoom(double zoom) {
		this.zoom = zoom;
	}
	
	/**
	 * Returns the layer specified.
	 * @param layer
	 * @return a layer
	 */
	public RenderableLayer getLayer(int layer) {
		return layers[layer];
	}
	
	/**
	 * Returns all layers in a map, from bottom to top.
	 * @return the layers
	 */
	public RenderableLayer[] getLayers() {
		return layers;
	}

}
