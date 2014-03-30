<%@ page import="leon.app.*,leon.misc.*,leon.view.web.*"%> <!-- Usage of leonardi code is optional -->
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%
	LySession leonardiSession = (LySession)session.getAttribute(LyWebConstants.RA_LY_SESSION);
	LyEnvironment env = leonardiSession.getEnvironment();
	String language = env.getLanguage();
	String background = leonardiSession.getEnvironment().getImageUrl("LY_AREA_BACKGROUND_IMAGE");
	String message1 = null, message2 = null, message3 = null;
	String appLogo = leonardiSession.getEnvironment().getImageUrl("appli.gif");
	String skinHome = (String)session.getAttribute(LyWebConstants.RA_LY_SKIN_URL);

	if ("en".equals(language))
	{
		message1 = "Welcome to the Hotel reservation application";
		message2 = "To access the different views of the application,";
		message3 = "you have to use the navigation toolbar.";
	}
	else
	{
		message1 = "Bienvenue sur l'application de réservation hôtelière";
		message2 = "Pour accéder aux différentes vues de l'application,";
		message3 = "vous pouvez utiliser la barre de navigation.";
	}
%>

<html>
	<head>
		<title>Bienvenue</title>
		<style type='text/css' media='screen'>
			@import url('<%=skinHome%>');
		</style>
	</head>

	<body>
	<table width='100%' height='100%' border='0'>
	 <tr>
	  <td align='center' valign='center'>
	   <table width='50%' border='0'>
	    <tr height='60%'>
	     <td align='center' valign='top' height='60%'>
	      <img src="<%=appLogo%>" border="0"/>
	     </td>
	    </tr>

	    <tr>
	     <td align='center' class='mainInfo'><%=message1%></td>
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
