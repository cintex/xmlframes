<%@ page import="leon.app.*,leon.misc.*,leon.view.web.*,leon.view.web.jquery.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%
	LySession leonardiSession = (LySession)session.getAttribute(LyWebConstants.RA_LY_SESSION);
	LyEnvironment env = leonardiSession.getEnvironment();
	String language = env.getLanguage();
	String background = env.getImageUrl("LY_AREA_BACKGROUND_IMAGE");
	String message1 = null, message2 = null, message3 = null;
	String appLogo = env.getImageUrl("appli.gif");

	String cookieTheme = request.getParameter(LyJQConstants.COOKIE_THEME);
	String title = null, message = null, informations = null, or = null, support = null;
	LyJQViewManager viewManager = (LyJQViewManager)env.getViewManager();
	boolean isRtlMode = viewManager.isRtlMode();
	String	direction = "";

	if (isRtlMode)
		direction = "rtl";
	
	if (cookieTheme == null)
		cookieTheme = LyJQConstants.DEFAULT_JQUERY_VIEWER_SKIN;
	
	if ("en".equals(language))
	{
		message1 = "Welcome to the Hotel reservation application";
		message2 = "To access the different views of the application,";
		message3 = "you have to use the navigation toolbar.";
	}
	else if ("ar".equals(language))
	{
		message1 = "مرحباً بكم في تطبيق الحجوزات الفندقية";
		message2 = "للإطلاع على مختلف واجهات التطبيق،";
		message3 = "يمكنك إستخدام شريط التنقل.";
	}
	else
	{
		message1 = "Bienvenue sur l'application de réservation hôtelière";
		message2 = "Pour accéder aux différentes vues de l'application,";
		message3 = "vous pouvez utiliser la barre de navigation.";
	}
%>

<html dir="<%=direction%>">
	<head>
		<title>Bienvenue</title>
		<script type="text/javascript" src="../leon/scripts/jquery/jquery/jquery.min.js"></script>
		<script type="text/javascript" src="../leon/scripts/jquery/jquery/ui/jquery-ui.min.js"></script> 
		<script type="text/javascript" src="../leon/scripts/jquery/LyJQUtils.js"></script>  
		<script type="text/javascript" src="../leon/scripts/jquery/jquery/ui.themeselect/ui.themeselect.js"></script>
		<link rel="stylesheet" href="../leon/css/login/login-style.css" type="text/css" media="all"/>
		<!--link rel="stylesheet" type="text/css" href="../leon/css/jquery-ui/themes/<%=cookieTheme%>/jquery-ui.css"/-->
	</head>

	<body class="ui-widget-content ui-widget-header">
	<div id='themeselector' ></div>
	
	<table width='100%' height='100%' border='0' class='ui-state-default ly-area-content'>
	 <tr>
	  <td align='center' valign='center'>
	   <table width='50%' border='0'>
	    <tr height='60%'>
	     <td align='center' valign='top' height='60%'>
	      <img src="<%=appLogo%>" border="0"/>
	     </td>
	    </tr>

	    <tr>
	     <td align='center'><span class='ui-state-default ly-area-content'><%=message1%></span></td>
	    </tr>
	    <tr>
		 <td align='center'> <hr color="#0257E5"/> </td>
	    </tr>
	    <tr>
		 <td align='center' class='subInfo'><%=message2%></td>
	    </tr>
	    <tr>
		 <td align='center' class='subInfo'><%=message3%></td>
	    </tr>
	   </table>
	  </td>
	 </tr>
    </table>

	</body>
</html>
