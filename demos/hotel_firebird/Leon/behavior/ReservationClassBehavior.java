/*
 * ReservationClassBehavior.java
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


/**
 * This Class implements the behavior used when a reservation is made.
 *
 * @author Lyria S.A.
 */
public class ReservationClassBehavior extends LyClassBehavior
{
	/**
	 * This method updates the reservation number of days on the reservation form, depending on
	 * check in and check out dates.
	 *
	 * @param set      the current LySetController instance
	 * @param newValue field info value change to propagate. If the field is the reservation check
	 *                 in or check out, then tries to update the reservation number of days.
	 */
	public void propagate(LySetController set, LyFieldInfoValue newValue)
	{
		LyFieldInfo fieldInfo = newValue.getFieldInfo();

		// Update the number of days with check in and check out dates
		if ((W4hotel.FLD_RESERVATION_CHECK_IN.equals(fieldInfo.getId()))
			|| (W4hotel.FLD_RESERVATION_CHECK_OUT.equals(fieldInfo.getId())))
		{
			LyDateValue checkIn = (LyDateValue)set.getFieldValue(W4hotel.FLD_RESERVATION_CHECK_IN);
			LyDateValue checkOut = (LyDateValue)set.getFieldValue(W4hotel.FLD_RESERVATION_CHECK_OUT);
			Long	    checkInTime = checkIn.getLongValue();
			Long	    checkOutTime = checkOut.getLongValue();
			int		    nbDaysTime = -1;

			if ((checkInTime != null) && (checkOutTime != null))
				nbDaysTime = (int)((checkOutTime.longValue() - checkInTime.longValue())
							/ (24 * 3600 * 1000));

			LyApplication app = set.getApplication();
			LyFieldInfo   daysField = (LyFieldInfo)app.getInfo(W4hotel.FLD_RESERVATION_NIGHTS);

			if (nbDaysTime > 0)
				set.setFieldValue(daysField, new Integer(nbDaysTime));
			else
				set.setFieldValue(daysField, null);
		}

		super.propagate(set, newValue);
	} // end method propagate
} // end class ReservationClassBehavior
