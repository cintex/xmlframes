/*
 * LyJFormat.java
 * Copyright (c) 2000-2009, Lyria-W4.
 * All rights reserved.
 */

package leon.view.win.swing.text;

import java.util.*;
import leon.misc.*;


/**
 * This class implements a mask format.<br>
 * The format is : '[' number '-' number ']' ( sep '[' number '-' number ']' )* where variable
 * number is a positive number and sep is String that can be "".
 *
 * @version $Id: LyJFormat.java 16172 2009-01-06 11:04:44Z jls $
 * @author  Lyria
 * @see     leon.view.win.swing.component.LyJFormattedInput LyFormattedField
 */
public class LyJFormat
{
	public static final String __VERSION =
		"$Id: LyJFormat.java 16172 2009-01-06 11:04:44Z jls $";

	/** Define the empty character. */
	public char				   EMPTY_CHAR;

	/** Vector of Interval.<br>
	 * Used to stock the compiled representation of an interval. */
	protected Vector		   _intervals;

	/** Vector of String.<br>
	 * Used to store separators. */
	protected Vector		   _separators;

	/**
	 * Constructor. Initializes class attributes with null or default values.
	 */
	public LyJFormat()
	{
		_intervals = new Vector();
		_separators = new Vector();
		EMPTY_CHAR = '_';
	}

	/**
	 * Constructor. Call the constructor without parameters {@link #LyJFormat()} and parses the
	 * given format ({@link #parseString(String)}).
	 *
	 * @param  format the String that defines the format
	 * @throws LyJBadFormatException
	 */
	public LyJFormat(String format)
		throws LyJBadFormatException
	{
		this();
		parseString(format);
	}

	/**
	 * Sets the given format. Only call {@link #parseString(String)}.
	 *
	 * @param  format the String that defines the format
	 * @throws LyJBadFormatException
	 * @see    #parseString(String)
	 */
	public void setFormatString(String format)
		throws LyJBadFormatException
	{
		parseString(format);
	}

	/**
	 * Parses the String that defines the format and build the compiled version of the format.
	 *
	 * @param  format the String to parse
	 * @throws LyJBadFormatException
	 */
	public void parseString(String format)
		throws LyJBadFormatException
	{
		int start, end, firstInterval = 0;
		int size = format.length();

		start = format.indexOf("[");
		end = format.indexOf("]");

		boolean beginBySep = false;

		// if first char is separator
		if (start != 0)
		{
			parseSeparator(format, 0, start - 1);
			beginBySep = true;
			firstInterval = start;
		}

		// first interval
		parseInterval(format, start, end);
		start = end + 1;
		end = format.indexOf("[", start) - 1;

		while ((end > 0) && (end < size))
		{
			parseSeparator(format, start, end);
			start = end + 1;
			end = format.indexOf("]", start);
			parseInterval(format, start, end);
			start = end + 1;
			end = format.indexOf("[", start) - 1;
		}

		// we may have a separator at the end
		if ((end < 0) && (start < size))
			parseSeparator(format, start, size - 1);

		// Sets the offset of all the builded intervals
		int i, n = _intervals.size(), j;
		int offset = firstInterval;

		for (i = 0; i < n; i++)
		{
			// if first char is a separator, index is incremented.
			j = i;
			if (beginBySep)
				j = i + 1;

			getInterval(i).setOffset(offset);
			offset += getInterval(i).getMaxCharCount();
			offset += (i < (n - 1)) ? (getSeparator(j).length()) : (0);
		}
	} // end method parseString

	/**
	 * Parses a region of the format's String identified as an interval.
	 *
	 * @param  format the String to parse
	 * @param  start  the index where the interval region begin
	 * @param  end    the index where the interval region end
	 * @throws LyJBadFormatException
	 */
	protected void parseInterval(String format, int start, int end)
		throws LyJBadFormatException
	{
		int    min, max;
		int    pos;
		String str;

		if (start < end)
		{
			str = format.substring(start + 1, end);
			try
			{
				pos = str.indexOf("-");
				min = Integer.parseInt(str.substring(0, pos));
				max = Integer.parseInt(str.substring(pos + 1));
			}
			catch (Exception e)
			{
				throw new LyJBadFormatException("Leonardi : parseInterval1", format, end);
			}
			if (min <= max)
				_intervals.add(new Interval(min, max));
			else
				throw new LyJBadFormatException("Leonardi : parseInterval2", format, end);
		}
		else
			throw new LyJBadFormatException("Leonardi : parseInterval3", format, end);
	}

	/**
	 * Parses a region of the format's String identified as a separator.
	 *
	 * @param  format the String to parse
	 * @param  start  the index where the separator region begin
	 * @param  end    the index where the separator region end
	 * @throws LyJBadFormatException
	 */
	protected void parseSeparator(String format, int start, int end)
		throws LyJBadFormatException
	{
		if (start <= (end + 1))
		{
			String   str = format.substring(start, end + 1);
            
			_separators.add(str);
		}
		else
			throw new LyJBadFormatException("Leonardi : parseSeparator", format, end);
	}

	/**
	 * Gets the interval at the given index.
	 *
	 * @param  i the index of the wanted interval
	 * @return the Interval at position i
	 */
	public Interval getInterval(int i)
	{
		return _intervals.get(i);
	}

	/**
	 * Gets the separator at the given index.
	 *
	 * @param  i the index of the wanted separator
	 * @return the separator at position i
	 */
	public String getSeparator(int i)
	{
		return _separators.get(i);
	}

	/**
	 * Gets the number of intervals. The number of separators = getIntervalsCount - 1.
	 *
	 * @return the number of Intervals
	 */
	public int getIntervalsCount()
	{
		return _intervals.size();
	}

	/**
	 * Gets the index of the last interval that contains the position of the given offset in the
	 * textField.
	 *
	 * @param  offset the offset
	 * @return the index of the interval that contains the position offset in the textField
	 */
	public int getIndexIntervalFromOffset(int offset)
	{
		int result = -1;
		int i, n = getIntervalsCount();

		for (i = 0; i < n; i++)
		{
			if ((offset >= getInterval(i).getStartOffset())
					&& (offset <= getInterval(i).getEndOffset()))
				result = i;
		}
		return result;
	}

	/**
	 * Gets the index of the last separator that contains the position of the given offset in the
	 * textFieldt.
	 *
	 * @param  offset the offset
	 * @return the index of the separator that contains the position offset in the textField
	 */
	public int getIndexSeparatorFromOffset(int offset)
	{
		int result = -1;
		int i, n = getIntervalsCount() - 1;

		for (i = 0; i < n; i++)
		{
			if ((offset > getInterval(i).getEndOffset())
					&& (offset < getInterval(i + 1).getStartOffset()))
				result = i;
		}
		return result;
	}

	/**
	 * Indicates that the char at the given position offset can be removed.
	 *
	 * @param  offset the offset
	 * @return true if the char at position offset in the textField can be removed, false otherwise
	 */
	public boolean isCharDeletionValid(int offset)
	{
		int index = getIndexIntervalFromOffset(offset);

		if (index == -1)
			return false;
		return true;
	}

	/**
	 * Indicates that the given character can be inserted at the given position. offset.<br>
	 * Verifies that the value is coherent with the format.
	 *
	 * @param  c      the character to insert
	 * @param  offset the offset
	 * @return true if the char c can be inserted at position offset, false otherwise
	 */
	public boolean isCharInsertionValid(char c, int offset)
	{
		if (!Character.isDigit(c))
			return false;

		int index = getIndexIntervalFromOffset(offset);

		if (index == -1)
			return false;
		Interval     inter = getInterval(index);
		int			 startOffset = inter.getStartOffset();
		int			 relOffset = offset - startOffset;

		StringBuffer minBuf = new StringBuffer(inter.getMinCompletedString());
		StringBuffer maxBuf = new StringBuffer(inter.getMaxCompletedString());

		minBuf.setCharAt(relOffset, c);
		maxBuf.setCharAt(relOffset, c);

		String minText = minBuf.toString();
		String maxText = maxBuf.toString();

		int    minValue;
		int    maxValue;

		try
		{
			minValue = Integer.parseInt(minText);
			maxValue = Integer.parseInt(maxText);
		}
		catch (NumberFormatException e)
		{
			return false;
		}

		if ((minValue <= inter.getMaximum()) && (maxValue >= inter.getMinimum()))
			return true;
		return false;
	} // end method isCharInsertionValid

	/**
	 * Finds the Interval that contains the given position offset and replace the character at that
	 * position by the given one.
	 *
	 * @param  offset the offset
	 * @param  c      the character
	 * @return the index of the next separator or offset + 1
	 */
	public int replaceChar(int offset, char c)
	{
		int index;

		index = getIndexIntervalFromOffset(offset);
		Interval inter = getInterval(index);
		int		 relOffset = offset - inter.getStartOffset();

		inter.replaceChar(relOffset, c);
		if (relOffset == (inter.getMaxCharCount() - 1))
			return ((index < _separators.size()) ? (offset + getSeparator(index).length() + 1)
												 : (offset + 1));
		return offset + 1;
	}

	/**
	 * Gets the String to display in the text field. The editing and edited value are not always the
	 * same.
	 *
	 * @param  hasFocus is true if the textField has the focus
	 * @return the String to display in the textField
	 */
	public String getDisplayableString(boolean hasFocus)
	{
		String text = "";
		int    i, j, n = getIntervalsCount();

		if (hasFocus || isAllEmpty())
			hasFocus = true;

		text = "";

		// add first separator, if first char is beginning by a separator.
		boolean beginBySep = false;

		beginBySep = ((n == 0) ? false : (getInterval(0).getStartOffset() != 0));

		if (beginBySep)
			text += getSeparator(0);

		for (i = 0; i < n; i++)
		{
			j = i;

			if (beginBySep)
				j = i + 1;

			text += (hasFocus) ? (getInterval(i).getEditingDisplayableString())
							   : (getInterval(i).getEditedDisplayableString());
			// text += (i<n-1)?(getSeparator(j)):("");

			if (j < _separators.size())
				text += getSeparator(j);
		}

		return text;
	} // end method getDisplayableString

	/**
	 * Indicates that all intervals are empty or not.
	 *
	 * @return true if all intervals are empty, false otherwise
	 */
	public boolean isAllEmpty()
	{
		int i, n = getIntervalsCount();

		for (i = 0; i < n; i++)
		{
			if (!getInterval(i).isEmpty())
				return false;
		}
		return true;
	}

	/**
	 * Gets the value at the given position offset as an int.
	 *
	 * @param  offset the pos of the caret used to determine which interval is the current interval
	 * @return the value at pos offset in the TextComponent as an int
	 * @see    #setIntValue(int, int)
	 */
	public int getIntValue(int offset)
	{
		if (getIntervalsCount() == 0)
			return 0;

		int interIndex = getIndexIntervalFromOffset(offset);
		int sepIndex = getIndexSeparatorFromOffset(offset);

		if (interIndex != -1)
			return getInterval(interIndex).getIntValue();
		else if (sepIndex != -1)
			return getInterval(sepIndex).getIntValue();
		else
		{
			int count = getIntervalsCount();
			int index = ((count - 1) >= 0) ? (count - 1) : (0);

			return getInterval(index).getIntValue();
		}
	}

	/**
	 * Sets the value at the given position offset of the textComponent.
	 *
	 * @param offset the pos of the caret used to determine which interval is the current interval
	 * @param value  the value to set
	 * @see   #getIntValue(int)
	 */
	public void setIntValue(int offset, int value)
	{
		if (getIntervalsCount() == 0)
			return;

		int interIndex = getIndexIntervalFromOffset(offset);
		int sepIndex = getIndexSeparatorFromOffset(offset);

		if (interIndex != -1)
			getInterval(interIndex).setIntValue(value);
		else if (sepIndex != -1)
			getInterval(sepIndex).setIntValue(value);
		else
			getInterval(getIntervalsCount() - 1).setIntValue(value);
	}

	/**
	 * Gets the minimum value at the given position offset.
	 *
	 * @param  offset the pos of the caret used to determine which interval is the current interval
	 * @return the minimum value at pos offset
	 */
	public int getMinIntValue(int offset)
	{
		if (getIntervalsCount() == 0)
			return 0;

		int interIndex = getIndexIntervalFromOffset(offset);
		int sepIndex = getIndexSeparatorFromOffset(offset);

		if (interIndex != -1)
			return getInterval(interIndex).getMinimum();
		else if (sepIndex != -1)
			return getInterval(sepIndex).getMinimum();
		else
			return getInterval(getIntervalsCount() - 1).getMinimum();
	}

	/**
	 * Gets the maximum value at the given position offset.
	 *
	 * @return the maximum value at pos offset
	 * @param  offset the pos of the caret used to determine which interval is the current interval
	 */
	public int getMaxIntValue(int offset)
	{
		if (getIntervalsCount() == 0)
			return 0;

		int interIndex = getIndexIntervalFromOffset(offset);
		int sepIndex = getIndexSeparatorFromOffset(offset);

		if (interIndex != -1)
			return getInterval(interIndex).getMaximum();
		else if (sepIndex != -1)
			return getInterval(sepIndex).getMaximum();
		else
			return getInterval(getIntervalsCount() - 1).getMaximum();
	}

	/**
	 * Sets the value of this format.
	 *
	 * @param value the new value of the format
	 */
	public void setValue(String value)
	{
		int i, n = getIntervalsCount();
		int start, end, subVal;

		for (i = 0; i < n; i++)
		{
			start = getInterval(i).getStartOffset();
			end = getInterval(i).getEndOffset();

			try
			{
				subVal = Integer.parseInt(value.substring(start, end + 1));
				getInterval(i).setIntValue(subVal);
			}
			catch (NumberFormatException e)
			{
			}
		}
	}

	/**
	 * Clears the content.
	 */
	public void clear()
	{
		int i, n = getIntervalsCount();

		for (i = 0; i < n; i++)
			getInterval(i).clear();
	}

	/**
	 * This class implements a representation of an interval with min and max values.<br>
	 * An Interval can store a String representing the value that is edited in the textField. An
	 * Interval knows where it begins and ends in its corresponding textField.
	 */
	public class Interval
	{

		/** The min value. */
		protected int    _min;

		/** The max value. */
		protected int    _max;

		/** The start offset in the textField. */
		protected int    _startOffset;

		/** The end offset in the textField. */
		protected int    _endOffset;

		/** The String edited by a user in the textField. */
		protected String _content;

		/**
		 * Constructor. Stes the minimum and the maximum with the given values then reset the
		 * content.
		 *
		 * @param minimum the minimum of the interval
		 * @param maximum the maximum of the interval
		 */
		public Interval(int minimum, int maximum)
		{
			_min = minimum;
			_max = maximum;
			clear();
		}

		/**
		 * Gets the minimum of the interval.
		 *
		 * @return the min value
		 */
		public int getMinimum()
		{
			return _min;
		}

		/**
		 * Gets the maximum of the interval.
		 *
		 * @return the max value
		 */
		public int getMaximum()
		{
			return _max;
		}

		/**
		 * Gets the maximum number of characters needed to display the value.
		 *
		 * @return the max number of characters
		 */
		public int getMaxCharCount()
		{
			return String.valueOf(_max).length();
		}

		/**
		 * Sets the start and end offsets.<br>
		 * <code>end offset = start offset + max number of character - 1.</code>
		 *
		 * @param offset the start offset
		 */
		public void setOffset(int offset)
		{
			_startOffset = offset;
			_endOffset = offset + getMaxCharCount() - 1;
		}

		/**
		 * Gets the start offset.
		 *
		 * @return the start offset
		 */
		public int getStartOffset()
		{
			return _startOffset;
		}

		/**
		 * Gets the end offset.
		 *
		 * @return the end offset
		 */
		public int getEndOffset()
		{
			return _endOffset;
		}

		/**
		 * Replaces the char found at position offset in this interval by the given character.
		 *
		 * @param offset the offset
		 * @param c      the replacment character
		 */
		public void replaceChar(int offset, char c)
		{
			_content = _content.substring(0, offset) + c + _content.substring(offset + 1);
		}

		/**
		 * Indicates if the interval is empty or not.
		 *
		 * @return true if this Interval contains no value, false otherwise
		 */
		public boolean isEmpty()
		{
			int i = 0, length = _content.length();

			while (i < length)
			{
				if (_content.charAt(i) != EMPTY_CHAR)
					return false;
				i++;
			}
			return true;
		}

		/**
		 * Gets the interval content.
		 *
		 * @return the interval content
		 */
		public String getContent()
		{
			return _content;
		}

		/**
		 * Gets the value to display during edition processus.
		 *
		 * @return the content of the interval
		 */
		public String getEditingDisplayableString()
		{
			return _content;
		}

		/**
		 * Gets the value to display in non-edition mode.
		 *
		 * @return the value
		 */
		public String getEditedDisplayableString()
		{
			String contentWithBlank = _content.replace(EMPTY_CHAR, ' ');

			// no value
			String tmp = contentWithBlank.trim();

			if (tmp.length() == 0)
			{
				try
				{
					tmp = String.valueOf(getMinimum());
				}
				catch (NumberFormatException e)
				{
				}
			}

			// check Min and Max
			int value = LyTools.intFromString(tmp);

			if (value < getMinimum())
				value = getMinimum();
			if (value > getMaximum())
				value = getMaximum();

			try
			{
				tmp = String.valueOf(value);
			}
			catch (NumberFormatException e)
			{
				return _content;
			}
			StringBuffer resu = new StringBuffer();

			for (int i = tmp.length(); i < _content.length(); i++)
				resu.append('0');

			resu.append(tmp);
			return (resu.toString());
		} // end method getEditedDisplayableString

		/**
		 * Gets a copy of the content where the EMPTY_CHAR is replaced by the maximum possible value
		 * ('9').
		 *
		 * @return the built string
		 */
		public String getMaxCompletedString()
		{
			StringBuffer tmp = new StringBuffer(_content);

			char		 filledWithChar = '9';

			int			 i = 0;

			while ((i < tmp.length()) && (tmp.charAt(i) == EMPTY_CHAR))
			{
				tmp.setCharAt(i, filledWithChar);
				i++;
			}

			i = tmp.toString().indexOf(EMPTY_CHAR);
			if (i == -1)
			{
				try
				{
					Integer.parseInt(tmp.toString());
					return tmp.toString();
				}
				catch (NumberFormatException e)
				{
					return "";
				}
			}
			while ((i < tmp.length()) && (tmp.charAt(i) == EMPTY_CHAR))
			{
				tmp.setCharAt(i, filledWithChar);
				i++;
			}
			try
			{
				Integer.parseInt(tmp.toString());
				return tmp.toString();
			}
			catch (NumberFormatException e)
			{
				return "";
			}
		} // end method getMaxCompletedString

		/**
		 * Gets a copy of the content where the EMPTY_CHAR is replaced by the minimum possible value
		 * ('0').
		 *
		 * @return the built string
		 */
		public String getMinCompletedString()
		{
			StringBuffer tmp = new StringBuffer(_content);

			int			 i = 0;

			while ((i < tmp.length()) && (tmp.charAt(i) == EMPTY_CHAR))
			{
				tmp.setCharAt(i, '0');
				i++;
			}

			i = tmp.toString().indexOf(EMPTY_CHAR);
			if (i == -1)
			{
				try
				{
					Integer.parseInt(tmp.toString());
					return tmp.toString();
				}
				catch (NumberFormatException e)
				{
					return "";
				}
			}
			while ((i < tmp.length()) && (tmp.charAt(i) == EMPTY_CHAR))
			{
				tmp.setCharAt(i, '0');
				i++;
			}
			try
			{
				Integer.parseInt(tmp.toString());
				return tmp.toString();
			}
			catch (NumberFormatException e)
			{
				return "";
			}
		} // end method getMinCompletedString

		/**
		 * Gets the value of this interval as an int.
		 *
		 * @return the value of this interval as an int
		 * @see    #setIntValue(int)
		 */
		public int getIntValue()
		{
			return Integer.parseInt(getEditedDisplayableString());
		}

		/**
		 * Sets the int value of this interval.
		 *
		 * @param value the value to set
		 * @see   #getIntValue()
		 */
		public void setIntValue(int value)
		{
			if ((value >= _min) && (value <= _max))
			{
				String str = String.valueOf(value);
				int    max = getMaxCharCount();

				if (str.length() < max)
				{
					int i, n = max - str.length();

					for (i = 0; i < n; i++)
						str = "0" + str;
				}
				_content = str;
			}
		}

		/**
		 * Gets the current possible value between the min and the max.
		 *
		 * @return always ""
		 */
		public String getCurrentPossibleValue()
		{
			return "";
		}

		/**
		 * Resets the content.
		 */
		public void clear()
		{
			_content = "";
			int i, n = getMaxCharCount();

			for (i = 0; i < n; i++)
				_content += String.valueOf(EMPTY_CHAR);
		}
	} // end class Interval
} // end class LyJFormat
