/*
 * ProvinceMapBehavior.java
 * Copyright (c) 2000-2009, Lyria-W4.
 * All rights reserved.
 */

package w4hotel.behavior;

import w4hotel.src.W4hotel;
import leon.app.*;
import leon.data.*;
import leon.info.*;
import leon.view.*;
import eu.w4.ae.app.behavior.*;
import eu.w4.ae.control.*;


/**
 * Specific behavior used for the map showing hotels location. In this map, nodes are hotels, they
 * are located depending on their cities coordinates and their representation depends on their
 * category.
 *
 * @author Lyria S.A.
 */
public class ProvinceMapBehavior extends LyMapBehavior
{

	/** Indicates if the map is initialized or not. */
	boolean _initialized = false;

	/**
	 * Updates a node status: the hotel location depending on its city coordinates and the image
	 * representing the hotel depending on its category.
	 *
	 * @param nodeObject the node object corresponding to the hotel
	 * @param mapNode    the node representing the hotel on the map
	 * @param controller current LyMapController instance
	 */
	public void updateNode(LyObject nodeObject, LyMapNode mapNode, LyMapController controller)
	{
		// Update the node by the generic method
		super.updateNode(nodeObject, mapNode, controller);

		LyApplication app = controller.getApplication();
		LySession     session = controller.getSession();

		// Gets the hotel city's coordinates
		LyClassInfo   cityClass = app.getClassInfo(W4hotel.CLS_CITY);
		LyObject	  city = nodeObject.getList(session, cityClass).getObject(0);
		LyFieldInfo   xField = cityClass.getFieldInfo(_useGoogleMap ? W4hotel.FLD_CITY_LONGITUDE : W4hotel.FLD_CITY_X);
		LyFieldInfo   yField = cityClass.getFieldInfo(_useGoogleMap ? W4hotel.FLD_CITY_LATITUDE : W4hotel.FLD_CITY_Y);
		Object		  x = city.getValue(xField);
		Object		  y = city.getValue(yField);

		// Gets the hotel category
		LyChoiceValue category = nodeObject.getChoiceValue(W4hotel.FLD_ESTABLISHMENT_CATEGORY);

		// Set the map node position and image with these values
		mapNode.setX(Float.parseFloat(x.toString()));
		mapNode.setY(Float.parseFloat(y.toString()));
		mapNode.setViewerStyle(LyMapNode.Style.IMAGE);
		mapNode.setImage(category.getString());
		mapNode.setMovable(true);

		if (_useGoogleMap)
		{
			LyFileValue   picture = nodeObject.getFileValue(W4hotel.FLD_ESTABLISHMENT_PICTURE);
			LyNumberValue roomsNumber = nodeObject.getNumberValue(W4hotel.FLD_ESTABLISHMENT_ROOMS_NUMBER);
			String		  picturePath = picture.getString();
			
			picturePath = picturePath.replace("\\", "/");

			mapNode.setTooltip("<table border='0' width='220px' height='80px'><tr><td><img border='1' src='./images/establishments/" + picturePath + "' height='60'/></td>" +
					"<td align='center' nowrap='yes'><b>" +
					nodeObject.getName() + "</b><br /><br />" + controller.getEnvironment().translate(category.getName()) + "<br />" +
					roomsNumber.intValue() + " " + controller.getEnvironment().translate("NAME_ESTABLISHMENT_ROOMS").toLowerCase() + "</td></tr></table>");
		}
	}

	/**
	 * The selected hotels have been moved on the map, this method updates their cities coordinates.
	 *
	 * @param controller current mapController instance
	 */
	public void selectionMoved(LyMapController controller)
	{
		// Update the city x and y when a node is moved on the map
		LyApplication app = controller.getApplication();
		LySession     session = controller.getSession();
		LyClassInfo   cityClass = app.getClassInfo(W4hotel.CLS_CITY);
		LyFieldInfo   xField = cityClass.getFieldInfo(W4hotel.FLD_CITY_X);
		LyFieldInfo   yField = cityClass.getFieldInfo(W4hotel.FLD_CITY_Y);
		LyObjectList  selection = controller.getSelection();
		LyObject	  establishment, city;
		LyMapNode     node;
		int			  i, n = (selection == null ? 0 : selection.getSize());

		controller.getMapComponent().setIdle(true);

		for (i = 0; i < n; i++)
		{
			establishment = selection.getObject(i);
			city = establishment.getList(session, cityClass).getObject(0);
			node = (LyMapNode)controller.getObjectAssoc(establishment);

			if (node != null)
			{
				city.setValue(xField, new Integer((int)node.getX()));
				city.setValue(yField, new Integer((int)node.getY()));
				city.set();
			}
		}
		
		controller.getMapComponent().setIdle(false);
	}
	
	/**
	 * Complete the map. A geographic layout is used instead of the generic layout (matrix layout),
	 * the viewer is removed, a background is used and an image is added.
	 *
	 * @param controller current mapController instance
	 */
	public void completeMap(LyMapController controller)
	{
		if (!_initialized)
		{
			IMAGE_HEIGHT = 32;
			
			// Create a geographic layout
			LyMap     map = controller.getMapComponent();
			LyLayout  layout = new LyLayout();

			map.setStyle(_useGoogleMap ? LyMap.Style.TERRAIN : LyMap.Style.STANDARD);
			layout.setStyle(LyLayout.Style.GEOGRAPHIC);
			map.setLayout(layout);

			if (!_useGoogleMap)
			{
				LyMapNode france = new LyMapNode();

				france.setId("france_node");
				france.setImage("france256.gif");
				france.setStyle(LyMapNode.Style.IMAGE);
				france.setViewerStyle(LyMapNode.Style.IMAGE);
				france.setLayer(0);
				france.setResizable(true);
				france.setSensitive(false);
				map.addMapNode(france);
			}
			else
			{
				map.setLongitude("2.704004");
				map.setLatitude("46.348813");
			}

			map.setViewer(true);
			map.setZoom(true);
			map.setTranslation(true);
			map.setZoomFactor(_useGoogleMap ? 5 : 1);
			map.setWidth(550);
			map.setHeight(575);

			_initialized = true;
		}
	}
} // end class ProvinceMapBehavior
