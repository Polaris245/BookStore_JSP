<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车</title>

    <%@ include file="/pages/common/head.jsp" %>
    <link type="text/css" rel="stylesheet" href="static/css/cart.css">
    <style>
        th, td{
            text-align: center;
            vertical-align: middle;
        }
        #empty{
            width: fit-content;
            text-align: center;
            margin: auto;
            font-size: 20px;
        }
    </style>
</head>
<body>
<%@ include file="/pages/common/header.jsp"%>
    <script type="text/javascript">
        function send_msg(id, name){
            $("#book_id").val(id);
            $("#book_name").text("《"+name+"》");
        }
        function checkout(){
            $(location).attr("href", "client/order?action=createOrder");
        }
        var name, count, id, obj;
        function setDefault(){
            obj.value = obj.defaultValue;
        }
        $(function (){
            $(".update").change(function (){
                name = $(this).parent().parent().find("td:first").text();
                count = this.value;
                id = $(this).attr("bookId");
                obj = this;
                $("#book_name2").text("《"+name+"》");
                $("#book_count").text(count);
                $("#update").modal('toggle');
            })
            $(".confirm_update").click(function (){
                $("#update").modal('hide');
                $.getJSON("${basePath}cart","action=update&count="+count+"&id="+id,function (data) {
                    if (!data.stockIsEnough)
                    {
                        $("#update_false").modal('toggle');
                        obj.value = obj.defaultValue;
                    }
                    else if (data.flush)
                    {
                        location.href = "${basePath}pages/cart/cart.jsp";
                    }
                     else if (data.msg_info != "" && data.stockIsEnough)
                    {
                        $("#update_msg").modal('toggle');
                        $(".msg").text(data.msg_info);
                        obj.value = obj.defaultValue;
                    }
                    else
                        location.href = "${basePath}pages/cart/cart.jsp";
                });
            })
            $(".confirm_false").click(function (){
                $("#update_false").modal('hide');
            })
            $(".close").click(function (){
                obj.value = obj.defaultValue;
            })
        });
    </script>
<div id="main">
    <c:if test="${empty sessionScope.cart.items}">
        <div class="alert alert-warning" role="alert" id="empty">
            购物车是空的~快去挑选心仪的书吧！
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.cart.items}">
    <table class="table">
        <thead>
            <tr>
                <th scope="col">索引</th>
                <th scope="col">商品名称</th>
                <th scope="col">数量</th>
                <th scope="col">单价</th>
                <th scope="col">金额</th>
                <th scope="col">操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${sessionScope.cart.items}" var="entry" varStatus="entryStatus">
                <tr>
                    <th scope="row">${entryStatus.count}</th>
                    <td>${entry.value.name}</td>
                    <td><input type="text" value="${entry.value.count}" class="form-control update" aria-describedby="inputGroup-sizing-sm" bookId="${entry.value.id}"></td>
                    <td>${entry.value.price}</td>
                    <td>${entry.value.totalPrice}</td>
                    <td><button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#confirm" onclick="send_msg(${entry.value.id}, '${entry.value.name}')">删除</button></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    </c:if>
    <c:if test="${not empty sessionScope.cart.items}">
        <div class="cart_info">
            <button type="button" class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#clear">清空购物车</button>
            <div class="number">
                <div class="alert alert-success" role="alert" style="width: fit-content">
                    购物车中共有${sessionScope.cart.totalCount}件商品，总金额${sessionScope.cart.totalPrice}元
                </div>
            </div>
            <button type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#check_confirm">去结账</button>
        </div>
    </c:if>
</div>
<div class="modal fade" id="confirm" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="get" action="cart">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="" id="book_id">
                <div class="modal-body" style="text-align: center">
                    您确定要从购物车删除<span id="book_name" style="color: #dc3545"></span>这本书吗？
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary confirm_btn">确定删除</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="clear" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel2">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="get" action="cart">
                <input type="hidden" name="action" value="clear">
                <div class="modal-body" style="text-align: center">
                    您确定要清空购物车吗？
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary confirm_btn">确定清空</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="update" tabindex="-1" data-bs-backdrop="static" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel3">提示</h5>
                <button type="button" class="btn-close close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="text-align: center">
                您确定要将<span id="book_name2" style="color: #dc3545"></span>的数量修改为<span id="book_count" style="color: #dc3545"></span>吗？
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary close" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary confirm_update">确定修改</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="update_false" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel4">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="text-align: center">
                修改失败，商品库存不足
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary confirm_false">确定</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="check_confirm" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="example">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="text-align: center">
                您确定要结算购物车吗
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary close" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary checkout" onclick="checkout()">确定结算</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="update_msg" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel5">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body msg" style="text-align: center">

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