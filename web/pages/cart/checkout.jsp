<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>结算页面</title>
	<%@ include file="/pages/common/head.jsp" %>
</head>
<body>
<%@ include file="/pages/common/header.jsp"%>
	<div id="main" style="height: 600px; display: flex; justify-content: center; align-items: center">
		<c:if test="${sessionScope.orderId != null}">
			<div class="alert alert-success" role="alert" style="font-size: 20px">
				您的订单已结算，订单号为${sessionScope.orderId}
			</div>
		</c:if>
		<c:if test="${sessionScope.orderId == null}">
			<div class="alert alert-danger" role="alert" style="font-size: 20px">
				下单失败，商品库存不足
			</div>
		</c:if>
	</div>

</body>
</html>