/*
 * HotelSessionBehavior.java
 * Copyright (c) 2000-2009, Lyria-W4.
 * All rights reserved.
 */

package w4hotel.behavior;

import w4hotel.src.W4hotel;
import leon.app.*;
import leon.app.behavior.*;
import leon.control.*;
import leon.data.*;
import leon.info.*;
import leon.misc.*;
import leon.view.*;


/**
 * This class implements the session behavior.
 *
 * @author Lyria S.A.
 */
public class SessionBehavior extends LySessionBehavior
{
	/**
	 * Invoke an action that has no controller. Implements the "Reserve room" action and the "Show
	 * user manual" action.
	 *
	 * @param  session   the current session
	 * @param  order     the source controller
	 * @param  action    the action to execute
	 * @param  classInfo class on which the action applies
	 * @param  objects   list of objects on which the action applies
	 * @param  show      indicates if the action must be shown or not
	 * @return true if the action was handled by this behavior, false otherwise.
	 * @see    leon.app.behaviorinterface.LySessionBehaviorInterface#invokeExtraAction
	 */
	public boolean invokeExtraAction(LySession session, LyController order, LyAction action,
		LyClassInfo classInfo, LyObjectList objects, boolean show)
	{
		// Implementation of action 'reserve_room'
		if (W4hotel.ACT_ESTABLISHMENT_RESERVE_ROOM.equals(action.getId())
			|| W4hotel.ACT_ROOM_RESERVE_ROOMS.equals(action.getId()))
		{
			LyApplication	    app = session.getApplication();
			LyClassInfo		    reservationCls = app.getClassInfo(W4hotel.CLS_RESERVATION);
			LyRelationFieldInfo etabFieldInfo = (LyRelationFieldInfo)reservationCls.getFieldInfo(
					W4hotel.FLD_RESERVATION_ESTABLISHMENT);
			LyRelationFieldInfo roomFieldInfo = (LyRelationFieldInfo)reservationCls.getFieldInfo(
					W4hotel.FLD_RESERVATION_ROOMS);
			LyAction		    create = reservationCls.getActionWithId(LyAction.ID_CREATE);
			LyCreateController  controller = (LyCreateController)session.invokeAction(order, create,
					reservationCls, null, false);
			LyObject		    context = objects.getObject(0);
			LyClassInfo		    contextClass = context.getClassInfo();
			LyRelationValue     value;

			// If the context is an establishment
			if (W4hotel.CLS_ESTABLISHMENT.equals(contextClass.getId()))
			{
				value = new LyRelationValue(etabFieldInfo, objects);
				controller.setFieldValue(etabFieldInfo, value, true);
			}
			// If the context is a room (or several rooms)
			else
			{
				LyClassInfo  etabCls = app.getClassInfo(W4hotel.CLS_ESTABLISHMENT);
				LyObjectList establishments = context.getList(session, etabCls);

				value = new LyRelationValue(etabFieldInfo, establishments);
				controller.setFieldValue(etabFieldInfo, value, true);
				value = new LyRelationValue(roomFieldInfo, objects);
				controller.setFieldValue(roomFieldInfo, value, true);
			}

			controller.showView();

			return true;
		}
		// Implementation of action 'User Manual'
		else if (W4hotel.ACT_USER_MANUAL.equals(action.getId()))
		{
			LyEnvironment env = session.getEnvironment();
			LyViewManager viewManager = session.getViewManager();
			String		  url = (String)action.getParameter("_url");
			String		  javawebstart = env.getEnv("LY_USE_JAVAWEBSTART");
			String		  path;
			String		  viewerType = env.getEnv("LY_VIEWER_TYPE");

			if ((javawebstart != null)
				&& javawebstart.equalsIgnoreCase("true"))
			{
				String userManualPath = env.getEnv("LY_USER_MANUAL_ADDRESS");

				if (userManualPath != null)
				{
					if (viewerType.equalsIgnoreCase("SWT"))
						path = "http://" + userManualPath;
					else
						path = "http:///" + userManualPath;
				}
				else
					path = env.getFile(url);
				
			}
			else
			{
				path = env.getFile(url);
				path = env.getString().expand(path);
				path = path.replaceAll("\\\\\\\\", "\\\\");
			}

			if (viewerType.equalsIgnoreCase("WEB2")
					|| viewerType.equalsIgnoreCase("JQUERY"))
				viewManager.showLocation(null, path, false);
			else
				viewManager.showLocation(null, path, true);

			return true;
		}

		return super.invokeExtraAction(session, order, action, classInfo, objects, show);
	} // end method invokeExtraAction
	
	/**
	 * Enable an action on a list of objects for the given controller. <br />
	 * Overridden to check if the print pdf action is enable with the current version of LEONARDI.
	 * @param session the current session
	 * @param action the action to enable
	 * @param controller the controller for this action
	 * @param objects list of objects on which the action has to be enabled
	 * @param showError report an error if the action is not enabled
	 * @return true if the action is enabled, false otherwise.
	 */
	public boolean enableAction(LySession session, LyAction action, LyController controller, LyObjectList objects, boolean showError)
	{
		String actionId = action.getId();
		
		if (actionId.equals(W4hotel.ACT_MANAGER_PRINT_XSLFO_FORM))
		{
			ClassLoader classLoader = getClass().getClassLoader();
			
			if (classLoader != null)
			{
				try 
				{
					String actionControllerClassName = action.getControllerClassName();
					classLoader.loadClass(actionControllerClassName);
				}
				catch (ClassNotFoundException e)
				{
					if (showError)
					{
						LyEnvironment env = session.getEnvironment();
						controller.showError(env.getString("PDF_NOT_IMPL_LEON_FREE"));
						return false;
					}
				}
			}
		}
		
		return super.enableAction(session, action, controller, objects, showError);
	}

	public boolean validateAction(LySession session, LyAction action,
			LyController controller)
	{
		if ("create_sticker".equals(action.getId()))
			return session.getViewManager().hasProperty("MANAGE_STICKERS");
		
		return super.validateAction(session, action, controller);
	}
}// end class HotelSessionBehavior
