/*
 * ReservationClassBehavior.java
 * Copyright (c) 2000-2009, Lyria-W4.
 * All rights reserved.
 */

package w4hotel.behavior;

import java.util.*;

import w4hotel.src.W4hotel;

import leon.app.*;
import leon.control.*;
import leon.data.*;
import leon.info.*;
import leon.view.*;
import eu.w4.ae.app.behavior.*;
import eu.w4.ae.control.*;


/**
 * This class implements the reservation gantt behavior.
 *
 * @author Lyria S.A.
 */
public class ReservationGanttBehavior extends LyGanttBehavior
	implements LyWorkSpaceListener
{

	/** The reservation gantt controller. */
	LyGanttController _ganttController;

	LyClassWorkSpace _reservations;
	
	/**
	 * Starts an action for the given controller. Initializes the current {@link #_ganttController
	 * gantt controller} with the given area controller.
	 *
	 * @param  areaController the current LyAreaController instance
	 * @param  action         the action that will be executed
	 * @return true if the action starts correctly, false otherwise.
	 */
	public boolean startAction(LyAreaController areaController, LyAction action)
	{
		LySession		 session = areaController.getSession();
		LyApplication    app = session.getApplication();
		LyClassInfo		 reservationClass = app.getClassInfo(W4hotel.CLS_CURRENT_RESERVATION);
		
		_reservations = new LyClassWorkSpace(session, reservationClass, true);
		_ganttController = (LyGanttController)areaController;
		_reservations.addListener(this);
		
		return true;
	}
	
	/**
	 * Completes the Gantt view in order to make it ready to be shown.<br />
	 * <i>The default implementation</i> sets the Gantt date format and if it has not ever been
	 * initialized, sets gantt scale and special days. Then, sets the gantt following attributes
	 * with the following values:
	 *
	 * <ul>
	 *   <li>'allowElementHiding' with {@link #allowElementHiding(LyGanttController)}</li>
	 *   <li>'allowInternalDivision' with {@link #allowIntervalDivision(LyGanttController)}</li>
	 *   <li>'allowSplit' with {@link #allowSplit(LyGanttController)}</li>
	 *   <li>'displayTimeSelector' with {@link #displayTimeSelector(LyGanttController)}</li>
	 *   <li>'currentDateRefreshPeriod' with {@link #getCurrentDateRefreshPeriod(LyGanttController)}
	 *   </li>
	 *   <li>'dateSelectorBean' with {@link LyGanttController#getDateSelectorBean()}</li>
	 * </ul>
	 *
	 * @param controller current LyGanttController instance
	 * @see   #allowElementHiding(LyGanttController)
	 * @see   #allowIntervalDivision(LyGanttController)
	 * @see   #allowSplit(LyGanttController)
	 * @see   #displayTimeSelector(LyGanttController)
	 * @see   #getCurrentDateRefreshPeriod(LyGanttController)
	 * @see   LyGanttController#getDateSelectorBean()
	 */
	public void completeGantt(LyGanttController controller)
	{
		if (!_initialized)
		{
			// Open first line only to avoid getting a too high planning
			LyGantt		gantt = controller.getGanttComponent();
			
			if (gantt.getLineCount() > 0)
				gantt.getLine(0).setOpen(true);
		}
		
		super.completeGantt(controller);
	}
	
	/**
	 * Builds a view object instance from the application object Line status (colors, labels, ...).
	 * Overriden to sets specific properties to true to the built line such as 'superLineHidden' and
	 * 'open'.
	 *
	 * @param  controller current LyGanttController instance
	 * @param  lineObject the line instance
	 * @param  level      the current level of the Gantt, as declared in the metamodel
	 * @return the built line
	 */
	public LyLine buildLine(LyGanttController controller, LyObject lineObject, String level)
	{
		LyLine line = super.buildLine(controller, lineObject, level);

		line.setSuperLineHidden(true);
		line.setOpen(false);

		return line;
	}

	/**
	 * Updates the object view status (color, label ...). This method is invoked when the given
	 * lineObject is modified.
	 *
	 * @param controller current LyGanttController instance
	 * @param object     the application object (reference)
	 * @param line       the object view (needs update)
	 * @param level      the current level of the Gantt, as declared in the metamodel
	 */
	public void updateLine(LyGanttController controller, LyObject object, LyLine line, String level)
	{
		super.updateLine(controller, object, line, level);

		LyClassInfo objectClass = object.getClassInfo();

		// Deletion of all the intervals of the line
		int		    i, n = line.getComponentCount();
		LyComponent comp;
		LyInterval  interval;

		for (i = n - 1; i >= 0; i--)
		{
			comp = line.getComponent(i);

			if (comp instanceof LyInterval)
				line.removeInterval((LyInterval)comp);
		}

		if (W4hotel.CLS_ROOM.equals(objectClass.getId()))
		{
			// Creation of all the intervals for the reservations
			LySession     session = controller.getSession();
			LyApplication app = session.getApplication();
			LyClassInfo   reservationClass = app.getClassInfo(W4hotel.CLS_CURRENT_RESERVATION);
			LyObjectList  reservations = object.getList(session, reservationClass, false);
			LyObject	  reservation;
			String		  beginDate, endDate;
			LyChoiceValue stateValue;

			n = reservations.getSize();

			for (i = 0; i < n; i++)
			{
				reservation = reservations.getObject(i);
				beginDate = getBeginDate(reservation, level, controller);
				endDate = getEndDate(reservation, level, controller);
				interval = new LyInterval();
				interval.setId(object.getId() + LyGanttController.SEP_ID + object.getId());
				interval.setBeginDate(beginDate);
				interval.setEndDate(endDate);
				interval.setMovable(false);
				interval.setLeftResizable(false);
				interval.setRightResizable(false);

				stateValue = reservation.getChoiceValue(W4hotel.FLD_RESERVATION_STATE);

				if (stateValue.isSelected(W4hotel.OPT_RESERVATION_STATE_WAITING))
					interval.setColor("RESERVATION_STATE_WAITING");
				else if (stateValue.isSelected(W4hotel.OPT_RESERVATION_STATE_CONFIRMED))
					interval.setColor("RESERVATION_STATE_CONFIRMED");

				line.addInterval(interval);
			}

			// Update the last modification time.
			controller.setLastModified(System.currentTimeMillis());
			controller.setRefreshTime(System.currentTimeMillis());
		}
	} // end method updateLine

	/**
	 * This method is invoked when an Interval Object is modified. Overridden to do nothing.
	 */
	public void updateIntervals(LyGanttController controller, LyObject object,
        Vector<LyInterval> intervals, String level)
	{
	}

	/**
	 * Updates the Gantt view when a reservation is added. Calls {@link #updateChambre(LyObject)
	 * updateChambre(event.getObject())}.
	 *
	 * @param event event notifying object adds.
	 * @see   #updateChambre(LyObject)
	 */
	public boolean objectAdded(LyWorkSpaceEvent event)
	{
		updateRoom(event.getObject());
		return true;
	}

	/**
	 * Updates the Gantt view when a reservation is changed. Calls {@link #updateChambre(LyObject)
	 * updateChambre(event.getObject())}.
	 *
	 * @param event event notifying object adds.
	 * @see   #updateChambre(LyObject)
	 */
	public boolean objectChanged(LyWorkSpaceEvent event)
	{
		updateRoom(event.getObject());
		return true;
	}

	/**
	 * Updates the Gantt view when a reservation is removed. Calls {@link #updateChambre(LyObject)
	 * updateChambre(event.getObject())}.
	 *
	 * @param event event notifying object adds.
	 * @see   #updateChambre(LyObject)
	 */
	public boolean objectRemoved(LyWorkSpaceEvent event)
	{
		updateRoom(event.getObject());
		return true;
	}

	/**
	 * Updates the Gantt line associated to the given reservation.
	 *
	 * @param reservation the reservation object whose view must be updated
	 */
	protected void updateRoom(LyObject reservation)
	{
		LyObject	  room;
		LySession     session = _ganttController.getSession();
		LyApplication app = session.getApplication();
		LyClassInfo   roomClass = app.getClassInfo(W4hotel.CLS_ROOM);
		LyObjectList  rooms = reservation.getList(session, roomClass, false);
		LyGantt		  gantt = _ganttController.getGanttComponent();
		LyLine		  line;
		int			  i, n = rooms.getSize();

		for (i = 0; i < n; i++)
		{
			room = rooms.getObject(i);
			line = (LyLine)gantt.getComponentByLabel(room.getName());
			updateLine(_ganttController, room, line, "1");
		}
	}
	
	public void free()
	{
		super.free();
		_reservations.free(this);
	}
	
} // end class ReservationGanttBehavior
