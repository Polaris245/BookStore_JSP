<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()
            + "://"
            + request.getServerName()
            + ":"
            + request.getServerPort()
            + request.getContextPath()
            + "/";
%>

<!--写base标签，永远固定相对路径跳转的结果-->
<base href="<%=basePath%>">
<link type="text/css" rel="stylesheet" href="static/css/bootstrap.min.css" >
<link type="text/css" rel="stylesheet" href="static/css/navigation.css" >
<script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>
<script type="text/javascript" src="static/script/bootstrap.bundle.min.js"></script>
<link rel="shortcut icon" href="static/img/book.svg">