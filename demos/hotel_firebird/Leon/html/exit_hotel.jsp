<%@ page import="leon.app.*,leon.misc.*"%> <!-- Usage of leonardi code is optional -->
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%
	String language = request.getParameter("_language");
	String title = null, message = null, informations = null, or = null, support = null;
	
	if ("en".equals(language))
	{
		title = "Good bye";
		message = "Thank you for using the Hotel reservation application";
	}
	else
	{
		title = "Au revoir";
		message = "Merci d'avoir utilisé l'application de réservation hôtelière";
	}
%>

<HTML>
<head>
  <title><%=title%></title>

  <style type="text/css">
		<!--
			body {background-attachment:fixed;
					background-image:url(../images/login_background.gif);
					background-position:center;
					background-repeat:no-repeat;}
			center.title {font-family:Arial;
						font-size:25px;
						font-weight:bold;
						color:#FFFFFF;}
			td.field {font-family:Arial;
						font-size:13px;
						font-weight:bold;
						color:#202A65;}
			td.info {font-family:Arial;
						font-size:15px;
						font-weight:bold;
						color:#202A65;}
		-->
		</style>
	</head>

<BODY bgcolor='#073499'>


<table width='100%' height='100%' border='0'>
 <tr valign='top' height='33%'>
   <td ><img src="../images/appli.gif" border="0"/></td>
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
