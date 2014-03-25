<%@ page import="java.util.*,leon.app.*,leon.misc.*,leon.view.web.*"%> <!-- Usage of leonardi code is optional -->
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%
	String servletRootURL = (String)request.getAttribute(LyWebConstants.RA_LY_ROOT_URL);
	String leonardiRootURL = (String)request.getAttribute(LyWebConstants.RA_LY_LEON_DOC_URL);
	String appRootURL = (String)request.getAttribute(LyWebConstants.RA_LY_APP_DOC_URL);

	LySession leonardiSession = (LySession)request.getAttribute(LyWebConstants.RA_LY_SESSION);
	LyWebViewManager viewManager = (LyWebViewManager)leonardiSession.getViewManager();
	String backLeft = leonardiSession.getEnvironment().getImageUrl("LY_UP_PAGE_LEFT_BACKGROUND");
	String skinHome = (String)request.getAttribute(LyWebConstants.RA_LY_SKIN_URL);

	String appName = leonardiSession.getEnvironment().translate("LY_APPLICATION");
	String logo = leonardiSession.getEnvironment().getImageUrl("LY_COMPANY_LOGO");

	String leonardiAboutUrl = (String)request.getAttribute("leonardiAboutUrl");

	if (leonardiAboutUrl == null)
		leonardiAboutUrl = servletRootURL;

	String leonardiExitUrl = (String)request.getAttribute("leonardiExitUrl");

	if (leonardiExitUrl == null)
		leonardiExitUrl = servletRootURL;

	String tip = leonardiSession.getEnvironment().getImageUrl("LY_UP_PAGE_TIP");
	String tipOver = leonardiSession.getEnvironment().getImageUrl("LY_UP_PAGE_TIP_OVER");
	String exit = leonardiSession.getEnvironment().getImageUrl("LY_UP_PAGE_EXIT");
	String exitOver = leonardiSession.getEnvironment().getImageUrl("LY_UP_PAGE_EXIT_OVER");

	String skin = leonardiSession.getEnvironment().getEnv("LY_SKIN");
	boolean usePoppeiSkin = "poppei".equals(skin);

	String tipButtonName = leonardiSession.getEnvironment().translate("LY_TOOL_ABOUT");
	String exitButtonName = leonardiSession.getEnvironment().translate("LY_TOOL_QUIT");
	String fond = leonardiSession.getEnvironment().getImageUrl("background.gif");
	String logo1 = leonardiSession.getEnvironment().getImageUrl("appli_small.gif");
	String bgRepeat = "background-repeat: repeat-y;";
	int pageHeight = 40;

	String englishFlag = leonardiSession.getEnvironment().getImageUrl("LY_ENGLISH_FLAG");
	String frenchFlag = leonardiSession.getEnvironment().getImageUrl("LY_FRENCH_FLAG");

	String aqualightName = leonardiSession.getEnvironment().translate("HOTEL_CHANGE_SKIN_AQUALIGHT");
	String nautilusName = leonardiSession.getEnvironment().translate("HOTEL_CHANGE_SKIN_NAUTILUS");
	String poppeiName = leonardiSession.getEnvironment().translate("HOTEL_CHANGE_SKIN_POPPEI");
	String verticalSeparator = leonardiSession.getEnvironment().getImageUrl("LY_VERTICAL_SEPARATOR");
	String aqualightImage = leonardiSession.getEnvironment().getImageUrl("skin_aqualight.gif");
	String nautilusImage = leonardiSession.getEnvironment().getImageUrl("skin_nautilus.gif");
	String poppeiImage = leonardiSession.getEnvironment().getImageUrl("skin_poppei.gif");

	if (usePoppeiSkin)
	{
		fond = leonardiSession.getEnvironment().getImageUrl("background_poppei.gif");
		logo1 = leonardiSession.getEnvironment().getImageUrl("left_background_poppei.gif");
		pageHeight = 69;
		bgRepeat = "";
	}
%>

<html>
	<head>
		<title>Logo</title>
		<script src='<%=viewManager.getScriptsDir()%>/LyUtilsScript.js'></script>
		<script src='<%=viewManager.getScriptsDir()%>/LyStringScript.js'></script>
		<script src='<%=viewManager.getScriptsDir()%>/LyActionScript.js'></script>
		<script src='<%=viewManager.getScriptsDir()%>/LyMessageScript.js'></script>
		<script src='<%=viewManager.getScriptsDir()%>/LyPageScript.js'></script>
		<script src="<%=viewManager.getScriptsDir()%>/LyMenuScript.js"></script>
		<script src="<%=viewManager.getScriptsDir()%>/LyMenuEffectScript.js"></script>
		<script>
			var _rootUrl = '<%=servletRootURL%>';
		</script>
		<style type='text/css' media='screen'>
			@import url('<%=skinHome%>');
		</style>
		<style type="text/css">
		<!--
			body
			{
				background:		url(<%=fond%>);
				<%=bgRepeat%>
				background-color:	#FFFFFF;
			}

			font.upTitle
			{
				font-family:	Arial;
				font-size:	20px;
				font-weight:	bold;
				font-style:	italic;
				color:		#FFFFFF;
			}
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
			    		d.MM_p[j]=new Image();
			    		d.MM_p[j++].src=a[i];
				  	 }
				  }
				}

				function ChangeSkin(skin)
				{
					var hiddenFrame = findTarget(null, "hidden_frame");

					hiddenFrame.location = "<%=servletRootURL%>?_skin=" + skin;
					setTimeout("top.location.reload()", 400);
				}

				function ChangeLanguage(language)
				{
					var hiddenFrame = findTarget(null, "hidden_frame");

					hiddenFrame.location = "<%=servletRootURL%>?_language=" + language;
					setTimeout("top.location.reload()", 400);
				}
				-->
		</script>
		</head>

<Body topmargin='0' leftmargin='0'>
<DIV id ="backgroundLeft">
	<TABLE BORDER='0' WIDTH='100%' HEIGHT='<%=pageHeight%>' cellspacing='0' cellpadding='0'>
		<TR VALIGN='20'>
			<TD ALIGN="LEFT" valign='top' HEIGHT='<%=pageHeight%>'>
				<DIV id ="hotel_logo">
				<table border='0' HEIGHT='<%=pageHeight-4%>' cellspacing='0' cellpadding='0'>
				<tr>
					<td valign='top'>
						<img src="<%=logo1%>" border="0" HEIGHT='<%=pageHeight-2%>'>
					</td>
					<td width='285' align='right'>
					<%
						String label1 = leonardiSession.getEnvironment().translate("ACT_NAME_DASHBOARD");
					%>
						<font class='upTitle'><%=label1%></font>
					</td>
				</tr>
				</table>
				</DIV>
			</TD>
			<TD ALIGN="RIGHT" VALIGN="MIDDLE">
			<% if (leonardiSession !=null && leonardiSession.isValid()) { %>
				<DIV id ="commands">
				<table border='0'>
					<tr>
						<td><a href="javascript:SendAjaxRequestParams('<%=leonardiAboutUrl%>','_action=_about');" onMouseOut="SetImageSrc('tip_image', '<%=tip%>');" onMouseOver="SetImageSrc('tip_image', '<%=tipOver%>');;window.status='<%=tipButtonName%>';return true"><img id='tip_image' src='<%=tip%>' border='0' alt='<%=tipButtonName%>'/></a></td>
						<td><a href="javascript:SendAjaxRequestParams('<%=leonardiExitUrl%>','_action=_exit');" onMouseOut="SetImageSrc('exit_image', '<%=exit%>');" onMouseOver="SetImageSrc('exit_image', '<%=exitOver%>');;window.status='<%=exitButtonName%>';return true"><img id='exit_image' src='<%=exit%>' border='0' alt='<%=exitButtonName%>'/></a></td>
					<%
						if (false)
						{
					%>
						<td><img src='<%=verticalSeparator%>'/></td>
						<td><a href="javascript:ChangeLanguage('en')"><img src='<%=englishFlag%>' height='18' border='0' alt='English version' title='English version'/></a></td>
						<td><a href="javascript:ChangeLanguage('fr')"><img src='<%=frenchFlag%>' height='18' border='0' alt='Version française' title='Version française'/></a></td>
					<%
						}
					%>

					</tr>
				</table>
				</DIV>
			<% } %>
			</TD>
		</TR>
	</TABLE>
</DIV>
</Body>
</html>
