/*
 * PrintReservationBehavior.java
 * Copyright (c) 2000-2009, Lyria-W4.
 * All rights reserved.
 */

package w4hotel.behavior;

import java.io.*;
import leon.app.*;
import leon.app.behavior.*;
import leon.control.*;
import leon.info.*;
import leon.misc.*;
import leon.view.web.*;


/**
 * This class implements the default behavior for a LyPrintModelController. It is used to print a
 * reservation within the hotel application.
 *
 * @author Lyria S.A.
 */
public class PrintReservationBehavior extends LyPrintModelBehavior
{

	/** The url of the reservation file to print. */
	String SAVE_URL;

	/** The name of the reservation file to print. */
	String SAVE_NAME;

	/** The path of the reservation file to print. */
	String SAVE_PATH;

	/** The reservation model file name (without path). */
	String _modelName;

	/**
	 * Gets the output file name of the reservation to print.
	 *
	 * @param  printer current LyPrintModelController instance
	 * @return the reservation file name
	 */
	public String getOutput(LyPrintModelController printer)
	{
		String result = super.getOutput(printer);
		int    pos = result.lastIndexOf('.');

		if (pos > 0)
			result = result.substring(0, pos) + "_" + System.currentTimeMillis()
				+ result.substring(pos);

		pos = result.lastIndexOf("\\");
		SAVE_NAME = result.substring(pos + 1);
		String javawebstart = printer.getEnvironment().getEnv("LY_USE_JAVAWEBSTART");

		if ((javawebstart != null) && javawebstart.equalsIgnoreCase("true"))
			SAVE_PATH = System.getProperty("java.io.tmpdir");
		else
			SAVE_PATH = result.substring(0, pos) + "\\";

		String reservation_file = SAVE_PATH + SAVE_NAME;

		return reservation_file;
	}

	/**
	 * Gets the resource name of the model file. The resource name is the one attempt to be found
	 * int the application jar.
	 *
	 * @param  modelParameter the model definition as defined in the metamodel
	 * @param  application    the current application
	 * @return the name of the resource to search in order to find the model file
	 */
	public String getModelResourceName(String modelParameter, LyApplication application)
	{
		String applicationId = application.getId();
		String applicationPath = applicationId.replace('.', '/');

		String modelFile = modelParameter;

		int    pos = modelParameter.indexOf("$LY_APP_DOC_DIR$");

		if (pos >= 0)
		{
			String beg = modelParameter.substring(0, pos);
			String end = modelParameter.substring(pos + 16);

			if (beg.length() == 0)
				modelFile = applicationPath + end;
			else
				modelFile = beg + applicationPath + end;
		}

		return modelFile;
	}

	/**
	 * Gets a file name from the given string representation of the path and file name.
	 *
	 * @param  fileAndPathName the String representation of the path + file name
	 * @return the file name
	 */
	public String getFileName(String fileAndPathName)
	{
		int pos = fileAndPathName.lastIndexOf('.');

		pos = fileAndPathName.lastIndexOf("/");
		_modelName = fileAndPathName.substring(pos + 1);

		return _modelName;
	}

	/**
	 * Get the model file from the action. Overriden to get the model from hotel jar.
	 *
	 * @param  printer current LyPrintModelController instance
	 * @return the model file, by default the _model parameter of the action
	 */
	public String getModel(LyPrintModelController printer)
	{
		LyAction action = printer.getAction();
		String   result = (String)action.getParameter("_model");

		String   modelFile = null;

		getFileName(result);

		String javawebstart = printer.getEnvironment().getEnv("LY_USE_JAVAWEBSTART");

		if ((javawebstart != null) && javawebstart.equalsIgnoreCase("true"))
		{
			String	    modelResource = getModelResourceName(result, printer.getApplication());

			InputStream modelStream = getResourceAsStream(modelResource);

			modelFile = System.getProperty("java.io.tmpdir") + _modelName;

			if (modelStream != null)
				createTempModelFile(modelStream, modelFile);
			else
				modelFile = result;
		}
		else
			modelFile = result;

		if (modelFile != null)
			modelFile = printer.getEnvironment().getString().expand(modelFile);

		return modelFile;
	} // end method getModel

	/**
	 * This method is called when the application is running with JavaWebStart. It copy the
	 * reservation model given as an input stream into the given model file.
	 *
	 * @param  modelStream the content of the model
	 * @param  modelFile   the new model file
	 * @return true if the file is created without errors, false otherwise
	 */
	private boolean createTempModelFile(InputStream modelStream, String modelFile)
	{
		try
		{
			FileOutputStream outFile;

			outFile = new FileOutputStream(modelFile);

			byte[] buffer = new byte[1024];
			int    c;

			modelStream.read(buffer, 0, 1024);
			outFile.write(buffer, 0, 1024);
			while ((c = modelStream.read()) != -1)
				outFile.write(c);
			modelStream.close();
			outFile.close();
			return true;
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
			return false;
		}
		catch (IOException e)
		{
			e.printStackTrace();
			return false;
		}
	} // end method createTempModelFile

	/**
	 * Gets the given resource as Stream.
	 *
	 * @param  modelResource the resource name
	 * @return the associated input stream if it is found, null otherwise.
	 */
	private InputStream getResourceAsStream(String modelResource)
	{
		String	    modelFileTmp = modelResource.replace('\\', '/');
		ClassLoader clsLoader = this.getClass().getClassLoader();

		if (clsLoader != null)
		{
			InputStream modelStream = clsLoader.getResourceAsStream(modelFileTmp);

			return modelStream;
		}
		else
			return null;
	}

	/**
	 * Gets the command string from the action.
	 *
	 * @param  printer current LyPrintModelController instance
	 * @return null for a web viewer, the string representation of the command to execute otherwise
	 */
	public String getCommand(LyPrintModelController printer)
	{
		LyEnvironment env = printer.getEnvironment();

		// V3.1/FFT00303
		String		  viewerType = env.getEnv("LY_VIEWER_TYPE");

		if (viewerType.equalsIgnoreCase("DHTML") || viewerType.equalsIgnoreCase("SVG")
				|| viewerType.equalsIgnoreCase("HTML"))
			return null;

		// generate the command used to open the reservation file
		String cmd = "cmd.exe //c start //d\"" + SAVE_PATH + "\" " + SAVE_NAME;

		//return env.getString().expand("$LY_APP_DOC_DIR$") + "\\print\\printWord.bat %1";
		return cmd;
	}

	/**
	 * Invoked after printing reservation. Overriden to allow Web viewers to show the reservation
	 * within the browser.
	 *
	 * @param  printer current LyPrintModelController instance
	 * @return true if process is done (stop generic behavior) false otherwise
	 */
	public boolean printEnd(LyPrintModelController printer)
	{
		LyEnvironment env = printer.getEnvironment();
		String		  viewerType = env.getEnv("LY_VIEWER_TYPE");

		if (viewerType.equalsIgnoreCase("DHTML")
				|| viewerType.equalsIgnoreCase("SVG")
				|| viewerType.equalsIgnoreCase("HTML"))
		{
			LyWebViewManager viewManager = (LyWebViewManager)printer.getViewManager();
			LyController     parentControl = printer.getParent();

			SAVE_URL = LyWebObject.getRootURL(env) + "/../print/" + SAVE_NAME;
			viewManager.showLocation(parentControl.getComponent(), SAVE_URL, true);
		}

		return true;
	}
} // end class PrintReservationBehavior
