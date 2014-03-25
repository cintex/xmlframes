/*
 * EstablishmentComplexListBehavior.java
 * Copyright (c) 2000-2009, Lyria-W4.
 * All rights reserved.
 */

package w4hotel.behavior;

import leon.info.*;
import eu.w4.ae.app.behavior.*;
import eu.w4.ae.control.*;


/**
 * This class implements the behavior for a complex list of etablissements.
 *
 * @author Lyria S.A.
 */
public class EstablishmentComplexListBehavior extends LyComplexTableBehavior
{
	/**
	 * Indicates if there must be a function line for given class info.
	 *
	 * @param  tableController Complex table controller.
	 * @param  classInfo       Class info for which a function line may be required.
	 * @return true if there must be a function line, false otherwise
	 */
	public boolean hasFunctionLine(LyComplexTableController tableController, LyClassInfo classInfo)
	{
		return false;
	}
}