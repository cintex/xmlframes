<%@ page import="leon.app.*,leon.misc.*,leon.view.web.*,leon.view.web.jquery.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%
	String language = request.getParameter(LyWebConstants.LANGUAGE);
	String cookieTheme = request.getParameter(LyJQConstants.COOKIE_THEME);
	String title = null, message = null, informations = null, or = null, support = null, direction = "";
	
	if (cookieTheme == null)
		cookieTheme = LyJQConstants.DEFAULT_JQUERY_VIEWER_SKIN;

	if ("en".equals(language))
	{
		title = "Good bye";
		message = "Thank you for using the Hotel reservation application";
	}
	else if ("ar".equals(language))
	{
		title = "إلى اللقاء";
		message ="شكراً لإستخدامكم تطبيق الحجوزات الفندقية";
		direction = "rtl";
	}
	else
	{
		title = "Au revoir";
		message = "Merci d'avoir utilis&eacute; l'application de r&eacute;servation h&ocirc;teli&egrave;re";
	}
%>

<HTML dir="<%=direction%>">
<head>
  <title><%=title%></title>
	<script type="text/javascript" src="./leon/scripts/jquery/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="./leon/scripts/jquery/jquery/ui/jquery-ui.min.js"></script> 
	<script type="text/javascript" src="./leon/scripts/jquery/LyJQUtils.js"></script>  
	<script type="text/javascript" src="./leon/scripts/jquery/jquery/ui.themeselect/ui.themeselect.js"></script>
	<link rel="stylesheet" href="./leon/css/login/login-style.css" type="text/css" media="all"/>
	<link rel="stylesheet" type="text/css" href="./leon/css/jquery-ui/themes/<%=cookieTheme%>/jquery-ui.css"/>
	<script>
	$(document).ready(function() {
		initThemeRoller(false,"");
	});
	</script>
</head>

<BODY class="ui-widget-content ui-widget-header">

<div id='themeselector' style='display:none;'></div>

<table width='100%' height='100%' border='0'>
 <tr valign='top' height='33%'>
   <td ><img src="./images/appli.gif" border="0"/></td>
  </tr>
 <tr>
  <td align='center' valign='top'>
   <table width='50%' border='0'>

    <tr>
     <td ><center class='title'><%=message%></center></td>
    </tr>
    <tr>
	 <td align='center'> <hr color="#0257E5"/> </td>
    </tr>
   </table>
  </td>
 </tr>
</table>
</BODY>
</HTML>
