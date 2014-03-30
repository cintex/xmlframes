<%@ page import="leon.app.*, leon.misc.*, java.util.*, leon.view.web.*, leon.view.web.struts.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%!
	public String getLanguages(LySession leonardiSession, String fieldName)
	{
		LyApplication application = leonardiSession.getApplication();
		LyEnvironment environment = application.getEnvironment();
		String[][] languages = application.getSupportedLanguages();

		int size = languages.length;
		if (size > 1)
		{
			Locale	appLocale = environment.getLocale();
			String result = new String();
			result ="<SELECT name=\""+fieldName+"\">\n";

			for (int i=0; i < size; i++)
			{
				result += "<option value='" + languages[i][0] +"' ";
				if (languages[i][0].equals(appLocale.getLanguage()))
					result += "selected='true'";

				result += ">" + environment.translate(languages[i][1]) + "</option>\n";
			}
			result +="</SELECT>\n";

			return result;
		}
		else
			return "";
	}

	public String getTranslatedString(LySession leonardiSession, String value)
	{
		LyEnvironment environment = leonardiSession.getEnvironment();

		return environment.translate(value);
	}
%>

<%
	// Servlet Page
	String 		servletRootURL = (String)request.getAttribute(LyWebConstants.RA_LY_ROOT_URL);
	// Base for leonardi resources like images
	String 		leonardiRootURL = (String)request.getAttribute(LyWebConstants.RA_LY_LEON_DOC_URL);
	// Base for application resources like images
	String 		appRootURL = (String)request.getAttribute(LyWebConstants.RA_LY_APP_DOC_URL);
	// Base for skin dependant resources
	String		skinRootURL = (String)request.getAttribute(LyWebConstants.RA_LY_SKIN_URL);
	// Current user session
	LySession	leonardiSession = (LySession)request.getAttribute(LyWebConstants.RA_LY_SESSION);
	LyStrutsViewManager	viewManager = (LyStrutsViewManager)leonardiSession.getViewManager();
	String		scripts = viewManager.generateScriptsInclusion();
	String		actionUrl = viewManager.getActionURL(LyStrutsConstants.PATH_ACTION_COMMAND);
	String		homeUrl = viewManager.getActionURL(LyStrutsConstants.PATH_ACTION_HOME);
	LyEnvironment		environment = leonardiSession.getEnvironment();
	String		utilsPage = environment.getUrl("LY_UTILS_PAGE");

	// Content images
	String leftContentImage = environment.getImageUrl("LY_CONTENT_LEFT");
	String topContentImage = environment.getImageUrl("LY_CONTENT_TOP");
	String rightContentImage = environment.getImageUrl("LY_CONTENT_RIGHT");
	String bottomContentImage = environment.getImageUrl("LY_CONTENT_BOTTOM");
	String bottomLeftContentImage = environment.getImageUrl("LY_CONTENT_BOTTOM_LEFT");
	String bottomRightContentImage = environment.getImageUrl("LY_CONTENT_BOTTOM_RIGHT");
	String topLeftContentImage = environment.getImageUrl("LY_CONTENT_TOP_LEFT");
	String topRightContentImage = environment.getImageUrl("LY_CONTENT_TOP_RIGHT");

	// Command images
	String leftCommandImage = environment.getImageUrl("LY_COMMAND_LEFT");
	String leftOverCommandImage = environment.getImageUrl("LY_COMMAND_LEFT_OVER");
	String centerCommandImage = environment.getImageUrl("LY_COMMAND_CENTER");
	String centerOverCommandImage = environment.getImageUrl("LY_COMMAND_CENTER_OVER");
	String rightCommandImage = environment.getImageUrl("LY_COMMAND_RIGHT");
	String rightOverCommandImage = environment.getImageUrl("LY_COMMAND_RIGHT_OVER");
	String closeImage = environment.getImageUrl("LY_CLOSE_WINDOW");
	String closeImageOver = environment.getImageUrl("LY_CLOSE_WINDOW_OVER");

	// Others
	String appName = getTranslatedString(leonardiSession, "LY_APPLICATION");
	String appLogo = environment.getImageUrl("appli.gif");
	String englishFlag = environment.getImageUrl("LY_ENGLISH_FLAG");
	String frenchFlag = environment.getImageUrl("LY_FRENCH_FLAG");
%>

<html>
<head>
<title><%=getTranslatedString(leonardiSession, "ACT_NAME_DASHBOARD")%></title>

		<%= scripts %>

		<style type='text/css' media='screen'>
			@import url('<%=skinRootURL%>');
		</style>
<style type="text/css">
		<!--
			body {background-attachment:fixed;
				background:none;
				background-position:center;
				background-repeat:no-repeat;
				background-color:#073499;}
			center.title {font-family:Arial;
						font-size:20px;
						font-weight:bold;
						color:#053498;}
			td.field {font-family:Arial;
						font-size:13px;
						font-weight:bold;
						color:#202A65;}
			td.info {font-family:Arial;
						font-size:11px;
						font-weight:bold;
						color:#FFFFFF;}
			span.infologingras{font-family:Arial;
						font-size:11px;
						font-weight:bold;
						color:#FFFFFF;}
			span.infologin {font-family:Arial;
						font-size:11px;
						color:#FFFFFF;}
			td.title {font-family:Arial;
						font-size:30px;
						font-weight:bold;
						color:#FFFFFF;}
			a.bouton {font-family:Arial;
					font-size:13px;
					color:#ffffff;
					text-decoration:none;}
			td.command_out {background-image: url('<%=centerCommandImage%>');}
			td.command_over {background-image: url('<%=centerOverCommandImage%>');}

		-->
		</style>
		<script language="JavaScript">
		<!--
		function MM_preloadImages()
		{
		  var d=document;
		  if(d.images)
		  {
		  	if(!d.MM_p)
		  		d.MM_p=new Array();
		    var i,j=0,a=MM_preloadImages.arguments;
		    for(i=0; i<a.length; i++)
		    {
	    		d.MM_p[j] = new Image();
	    		d.MM_p[j++].src = +a[i];
		    }
		  }
		}
		-->
		</script>
</head>
<body onLoad="javascript:FocusOnLogin();MM_preloadImages('command_left_over.gif','command_center_over.gif','command_right_over.gif')"
	style='overflow:hidden' onResize='javascript:ShowMessageWindowShadow(false);'>

<script>

	var _rootUrl = '<%=servletRootURL%>';

	function FocusOnLogin()
	{
		document.forms[0].elements["_login"].focus();
	}

	function SubmitForm(source)
	{
		document.forms[0].elements["_source"].value = source;
		SendAjaxRequest(document.forms[0], '<%=actionUrl%>');
	}

	function checkKey(event)
	{
		if (event.keyCode == 10 || event.keyCode == 13)
			SubmitForm('_validate');
	}
</script>
	<table border='0' width='100%' height='100%' >
		<tr height='10%'>
			<td width='10%'>
				<img src="<%=appLogo%>" alt="<%=appName%>"/>
			</td>
			<td class='title' align='middle'><%=getTranslatedString(leonardiSession, "ACT_NAME_DASHBOARD")%></td>
			<td width='10%'>&nbsp;</td>
		</tr>

		<tr align='center'>
			<td colspan='3'>
				<table width='80%' border='0'>
					<tr>
						<td width='20%'>&nbsp;</td>
						<td width='60%' align='center'>
							<form name='my_form' method='post' action='<%=servletRootURL%>' target="hidden_frame">
								<input type='hidden' name='_controller' value='LOGIN_CONTROLLER'/>
								<input type='hidden' name='_source' value=''/>
								<input type='hidden' name='_hidden' value='true'/>
								<table width='10%' height='100%' border='0' cellspacing='0' cellpadding='0'>
									<tr>
										<td></td>
										<td align='center'>
											<a href='<%=servletRootURL + homeUrl%>?_language=en'><img src='<%=englishFlag%>' border='0' alt='English version' title='English version'/></a>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<a href='<%=servletRootURL + homeUrl%>?_language=fr'><img src='<%=frenchFlag%>' border='0' alt='Version française' title='Version française'/></td>
										<td></td>
									</tr>
									<tr>
										<td colspan='3'>&nbsp;</td>
									</tr>
									<tr>
										<td><img src='<%=topLeftContentImage%>'/></td>
										<td style='background:url(<%=topContentImage%>)'></td>
										<td><img src='<%=topRightContentImage%>'/></td>
									</tr>
									<tr>
										<td style='background:url(<%=leftContentImage%>);'/>
										<td width='100%'>
											<table border='0' cellpadding='10' bgcolor="#ECE9D8">
												<tr>
													<td>
														<table border='0' width='100%'>
															<tr>
															   <td class='field' nowrap='true'><%=getTranslatedString(leonardiSession,"LY_LOGIN_USER") %> : </td>
															   <td><input name='_login' size='30' value="" onkeydown="javascript:checkKey(event)"/></td>
															</tr>
															<tr>
															   <td class='field' nowrap='true'><%=getTranslatedString(leonardiSession,"LY_LOGIN_PASSWORD") %> : </td>
															   <td><input name='_password' size='30' type='password' value="" onkeydown="javascript:checkKey(event)"/></td>
															</tr>

															<% if (getLanguages(leonardiSession, "_language").length() > 0) {%>
															<tr>
																<td class='field' nowrap='true'><%=getTranslatedString(leonardiSession,"LY_LOGIN_LANGUAGE") %> : </td>
																<td><%=getLanguages(leonardiSession, "_language")%></td>
															</tr>
															<%}%>
															<!-- DEMO SKIN BEGIN -->

															<tr>
																<td colspan='2'>&nbsp</td>
															</tr>
														</table>
														<table border='0' width='100%'>
															<tr valign='middle' >
																<td align='right' valign='top'>

																	<table border='0' cellspacing='0' cellpadding='0'>
																		<tr>
																			<td align='right' nowrap='true'><img src='<%=leftCommandImage%>' name="imageLeft1"/></td>
																			<td nowrap='true' background='<%=centerCommandImage%>' id="bg1">
																				<table border='0' cellspacing='0' cellpadding='0'>
																					<tr>
																						<td nowrap='true'>
																							<a class='bouton' href="javascript:SubmitForm('_validate');"  onMouseOut="javascript:changeLineBg(bg1,'', '<%=centerCommandImage%>');javascript:rollout(imageLeft1,'','<%=leftCommandImage%>');javascript:rollout(imageRight1,'','<%=rightCommandImage%>');bg1.className='command_out';" onMouseOver="javascript:changeLineBg(bg1,'', '<%=centerOverCommandImage%>');javascript:rollover(imageLeft1,'','<%=leftOverCommandImage%>');javascript:rollover(imageRight1,'','<%=rightOverCommandImage%>');window.status='<%=getTranslatedString(leonardiSession,"LY_VALIDATE") %>';bg1.className='command_over';return true"><font class='commandLabel'><%=getTranslatedString(leonardiSession,"LY_VALIDATE") %></font></a></td>
																						</td>
																					</tr>
																				</table>
																			</td>
																			<td align='left' nowrap='true'><img src='<%=rightCommandImage%>' name="imageRight1"/></td>
																		</tr>
																	</table>
																</td>
																<td align='left' valign='top'>
																	<table border='0' cellspacing='0' cellpadding='0'>
																		<tr>
																			<td align='right' nowrap='true'><img src='<%=leftCommandImage%>' name="imageLeft2"/></td>
																			<td nowrap='true' background='<%=centerCommandImage%>' id="bg2">
																				<table border='0' cellspacing='0' cellpadding='0'>
																					<tr>
																						<td nowrap='true'>
																							<a class='bouton' href="javascript:SubmitForm('_close');"  onMouseOut="javascript:changeLineBg(bg2,'', '<%=centerCommandImage%>');javascript:rollout(imageLeft2,'','<%=leftCommandImage%>');javascript:rollout(imageRight2,'','<%=rightCommandImage%>');bg2.className='command_out';" onMouseOver="javascript:changeLineBg(bg2,'', '<%=centerOverCommandImage%>');javascript:rollover(imageLeft2,'','<%=leftOverCommandImage%>');javascript:rollover(imageRight2,'','<%=rightOverCommandImage%>');window.status='<%=getTranslatedString(leonardiSession,"LY_CANCEL") %>';bg2.className='command_over';return true"><font class='commandLabel'><%=getTranslatedString(leonardiSession,"LY_CANCEL") %></font></a></td>
																						</td>
																					</tr>
																				</table>
																			</td>
																			<td align='left' nowrap='true'><img src='<%=rightCommandImage%>' name="imageRight2"/></td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>
										</td>
										<td style='background:url(<%=rightContentImage%>);'/>
									</tr>
									<tr>
										<td><img src='<%=bottomLeftContentImage%>'/></td>
										<td width='100%' style='background:url(<%=bottomContentImage%>)'></td>
										<td><img src='<%=bottomRightContentImage%>'/></td>
									</tr>
								</table>
							</form>
						</td>
						<td width='20%'>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan='1'><hr color="#0257E5" /> </td>
					</tr>
					<tr>
						<td width='20'>&nbsp;</td>
						<td>
							<span class="infologingras"><%=getTranslatedString(leonardiSession,"HOTEL_LOGIN_INFO")%><br /></span>
							<span class="infologin">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=getTranslatedString(leonardiSession,"LY_LOGIN_USER") %> = <%=getTranslatedString(leonardiSession,"HOTEL_LOGIN_USER_VALUE") %><br /></span>
							<span class="infologin">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=getTranslatedString(leonardiSession,"LY_LOGIN_PASSWORD") %> = <%=getTranslatedString(leonardiSession,"HOTEL_LOGIN_PASSWORD_VALUE") %></span>
						</td>

					</tr>
					<tr class="info">
						<td width="20">&nbsp;</td>
						<td class='info'>
							<%=environment.getMessage("LY_LOGIN_MESSAGE1")%>
							<br />
							<%=environment.getMessage("LY_LOGIN_MESSAGE2")%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

		<jsp:include page="<%= utilsPage %>" />

</body>
</html>
