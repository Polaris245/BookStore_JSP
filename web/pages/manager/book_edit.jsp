<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>编辑图书</title>
	<%@ include file="/pages/common/head.jsp"%>
	<style>
		th, td{
			text-align: center;
			vertical-align: middle;
		}
		.form-control{
			text-align: center;
			margin: 0 auto;
		}
		.fileUpload{
			text-align: center;
			margin: 0 auto;
		}
		.fileUpload div{
			margin-left: auto;
			width: 300px;
			text-align: center;
		}
	</style>
	<script>
		function submit_add(){
			var check_int = /^\d+$/, check_double = /^\d+(\.\d+)?$/;
			if ($(".input1").val() == "" || $(".input2").val()== "" || $(".input3").val()== "" || $(".input4").val()== "" || $(".input5").val()== "")
			{
				$("#add_false").modal("toggle");
				return false;
			}
			else if (!check_double.test($(".input2").val()) || !check_int.test($(".input4").val()) || !check_int.test($(".input5").val()))
			{
				$("#add_false").modal("toggle");
				return false;
			}
			else
				return true;
		}
		<c:if test="${not empty requestScope.msg_info}">
		window.onload = function (){
			$("#info").modal("toggle");
		}
		</c:if>
	</script>
</head>
<body>
<div id="header">
	<img class="logo_img" alt="" src="static/img/book3.jpg" style="width: 328px; height: 100px" >
	<span class="wel_word" style="color: #58ab7f">编辑图书</span>
	<div class="nav">
		<li><a href="manager/user?action=userPage">用户管理</a></li>
		<li><a href="manager/book?action=page">图书管理</a></li>
		<li><a href="manager/order?action=managerPage">订单管理</a></li>
		<li><a href="index.jsp">返回首页</a><li>
	</div>
</div>
<hr style="width: 80%; margin: 0 auto 0"/>
		
		<div id="main">
			<form action="manager/book" method="post" onsubmit="return submit_add()">
				<input type="hidden" name="pageNo" value="${param.pageNo}">
				<input type="hidden" name="action" value="${param.method}">
				<input type="hidden" name="id" value="${requestScope.book.id}">
				<table class="table">
					<thead>
					<tr>
						<th scope="col">名称</th>
						<th scope="col">价格</th>
						<th scope="col">作者</th>
						<th scope="col">销量</th>
						<th scope="col">库存</th>
						<th scope="col">操作</th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<th scope="row"><input type="text" name="name" value="${requestScope.book.name}" class="form-control input1" aria-describedby="inputGroup-sizing-sm"></th>
						<td><input type="text" name="price" value="${requestScope.book.price}" class="form-control input2" aria-describedby="inputGroup-sizing-sm"></td>
						<td><input type="text" name="author" value="${requestScope.book.author}" class="form-control input3" aria-describedby="inputGroup-sizing-sm"></td>
						<td><input type="text" name="sales" value="${requestScope.book.sales}" class="form-control input4" aria-describedby="inputGroup-sizing-sm"></td>
						<td><input type="text" name="stock" value="${requestScope.book.stock}" class="form-control input5" aria-describedby="inputGroup-sizing-sm"></td>
						<td><button type="submit" class="btn btn-outline-danger">提交</button></td>
					</tr>
					</tbody>
				</table>
			</form>
			<c:if test="${param.method != 'add'}">
				<div class="fileUpload">
					<img src="${requestScope.book.img_path}" height="200px" width="200px">
					<form action="manager/book?action=uploadFile" method="post" enctype="multipart/form-data" onsubmit="return submit_add()">
						<input type="hidden" name="book_id" value="${requestScope.book.id}">
						<input type="hidden" name="pageNo" value="${param.pageNo}">
						<div>
							<input type="file" name="file" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">
						</div>
						<button type="submit" class="btn btn-outline-success">提交</button> |
						<button type="reset" class="btn btn-outline-warning">重置</button>
					</form>
				</div>
			</c:if>
		</div>
<div class="modal fade" id="add_false" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel4">提示</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body" style="text-align: center">
				别闹，检查一下输入是否正确哦！
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="info" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabelInfo">提示</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body" style="text-align: center">
				${requestScope.msg_info}
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
			</div>
		</div>
	</div>
</div>
<script src="static/script/index.js"></script>
</body>
</html>