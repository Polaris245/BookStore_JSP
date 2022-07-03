<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>书城首页</title>

	<%@ include file="/pages/common/head.jsp"%>
	<link type="text/css" rel="stylesheet" href="static/css/index.css">
	<script type="text/javascript">
		$(function () {
			<c:if test="${not empty sessionScope.cart.items}">
			$("#itemName").html("您刚刚将<span style=\"color: red\">" + "《${sessionScope.lastName}》" + "</span>添加到了购物车");
			$("#cartEmpty").text("您的购物车中有 ${sessionScope.cart.totalCount} 件商品");
			</c:if>
			<c:if test="${empty sessionScope.cart.items}">
			$("#itemName").hide();
			$("#cartEmpty").text("您的购物车是空的");
			</c:if>
			$(".addToCart").click(function () {
				var bookId = $(this).attr("bookId");
				//使用Ajax请求动态更新页面
				$.getJSON("${basePath}cart", "action=add&id=" + bookId, function (data) {
					if (data.totalCount != 0) {
						$("#cartEmpty").text("您的购物车中有 " + data.totalCount + " 件商品");
						// $("#cartEmpty").hide();
						$("#itemName").show();
						// $("#cartCount").html("您的购物车中有 " + data.totalCount + " 件商品");
						$("#itemName").html("您刚刚将<span style=\"color: red\">" + "《"+data.lastName +"》"+ "</span>添加到了购物车");
					}
				});
			});
		});
		function show_detail(id){
			$(location).attr("href", "client/book?action=bookDetail&id=" + id);
		}
		function confirm(){
			var check_double = /^\d+(\.\d+)?$/;
			if (check_double.test($(".price1").val()) && check_double.test($(".price2").val()))
				return true;
			else
			{
				$("#page_error_info").modal("toggle");
				return false;
			}
		}
	</script>
</head>
<body>
<%@ include file="/pages/common/header.jsp"%>
<div id="main">
	<div id="book">
		<div class="book_cond">
			<div>
				<form action="client/book" method="get">
					<input type="hidden" name="action" value="pageByName">
					输入您想查找的书名：
					<input type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm" id="name" name="name" value="${param.name}">
					<button type="submit" class="btn btn-outline-success">查询</button>
				</form>
			</div>
			<div>
				<form action="client/book" method="get" onsubmit="return confirm()">
					<input type="hidden" name="action" value="pageByPrice">
					<label>价格：</label><input type="text" class="form-control price1" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm" id="min" name="min" value="${param.min}"> <label> 元 -</label>
					<input type="text" class="form-control price2" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm" id="max" name="max" value="${param.max}"> <label> 元</label>
					<button type="submit" class="btn btn-outline-success">查询</button>
				</form>
			</div>
		</div>
		<div style="text-align: center;">
			<div class="alert alert-success" role="alert" id="cartEmpty" style="width: fit-content; padding: 10px;">
				您的购物车是空的
			</div>
			<%--购物车非空的输出--%>
            <div class="alert alert-success" role="alert" id="itemName" style="width: fit-content; padding: 10px;">
            </div>
		</div>
		<div id="list_container">
			<c:forEach items="${requestScope.page.items}" var="book">
				<div class="b_list">
					<div class="img_div" onclick="show_detail(${book.id})">
						<img class="book_img" alt="" src="${book.img_path}" />
					</div>
					<div class="book_info">
						<div class="book_name">
							<span class="sp1">书名:${book.name}</span>
							<span class="sp2"></span>
						</div>
						<div class="book_author">
							<span class="sp1">作者:${book.author}</span>
							<span class="sp2"></span>
						</div>
						<div class="book_price">
							<span class="sp1">价格:￥${book.price}</span>
							<span class="sp2"></span>
						</div>
						<div class="book_sales">
							<span class="sp1">销量:${book.sales}</span>
							<span class="sp2"></span>
						</div>
						<div class="book_amount">
							<span class="sp1">库存:${book.stock}</span>
							<span class="sp2"></span>
						</div>
						<div class="book_add">
							<button bookId="${book.id}" type="button" class="btn btn-outline-success btn-sm addToCart">加入购物车</button>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
	<%@include file="/pages/common/page_nav.jsp"%>
</div>
<script src="static/script/index.js"></script>
</body>
</html>