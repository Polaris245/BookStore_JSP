<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>图书管理</title>
	<%@ include file="/pages/common/head.jsp"%>
	<style>
		th, td{
			text-align: center;
			vertical-align: middle;
		}
		.modal-footer{
			justify-content: center;
		}
		.delete_btn{
			background-color: #d2515d;
			border-color: #d2515d;
		}
		.delete_btn:hover{
			background-color: #dc3545;
			border-color: #dc3545;
		}
	</style>
	<script type="text/javascript">
		function book_delete(id, pageNo, name){
			$("#book_id").val(id);
			$("#pageNo").val(pageNo);
			$("#book_name").text(name);
		}
		function add_book(pageNo){
			$(location).attr("href","pages/manager/book_edit.jsp?method=add&pageNo=" + pageNo);
		}
		function book_update(id, pageNo){
			$(location).attr("href", "manager/book?action=searchById&id=" + id + "&method=update&pageNo=" + pageNo);
		}
	</script>


</head>
<body>
	<div id="header">
		<img class="logo_img" alt="" src="static/img/book3.jpg" style="width: 328px; height: 100px" >
		<span class="wel_word" style="color: #58ab7f">图书管理</span>
		<div class="nav">
			<li><a href="manager/user?action=userPage">用户管理</a></li>
			<li><a href="manager/order?action=managerPage">订单管理</a></li>
			<li><a href="index.jsp">返回首页</a><li>
		</div>
	</div>
	<hr style="width: 80%; margin: 0 auto 0"/>
	<div id="main">
		<table class="table table-hover">
			<thead>
			<tr>
				<th scope="col">名称</th>
				<th scope="col">价格</th>
				<th scope="col">作者</th>
				<th scope="col">销量</th>
				<th scope="col">库存</th>
				<th scope="col" colspan="2">操作</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${requestScope.page.items}" var="book">
				<tr>
					<th scope="row">${book.name}</th>
					<td>${book.price}</td>
					<td>${book.author}</td>
					<td>${book.sales}</td>
					<td>${book.stock}</td>
					<td><button type="button" class="btn btn-outline-warning" onclick="book_update(${book.id},${requestScope.page.pageNo})">修改</button></td>
					<td><button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#delete" onclick="book_delete(${book.id}, ${requestScope.page.pageNo}, '${book.name}')">删除</button></td>
				</tr>
			</c:forEach>
			<tfoot>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><button type="button" class="btn btn-outline-success" onclick="add_book(${requestScope.page.pageTotal})">添加图书</button></td>
			</tfoot>
			</tbody>
		</table>
		<%@include file="/pages/common/page_nav.jsp"%>
	</div>
	<div class="modal fade" id="delete" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel2">提示</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<form method="get" action="manager/book">
					<input type="hidden" name="action" value="delete">
					<input type="hidden" name="id" value="" id="book_id">
					<input type="hidden" name="pageNo" value="" id="pageNo">
					<div class="modal-body" style="text-align: center">
						您确定要删除<span id="book_name" style="color: #dc3545"></span>这本书吗？
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
						<button type="submit" class="btn btn-primary delete_btn">确定删除</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script src="static/script/index.js"></script>
</body>
</html>