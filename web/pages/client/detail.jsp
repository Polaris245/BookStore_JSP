<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品详情</title>
    <%@ include file="/pages/common/head.jsp"%>
    <style>
        #main{
            display: flex;
            height: 500px;
            justify-content: center;
            align-items: center;
            box-shadow:0 15px 35px rgba(0,0,0,0.1);
        }
        .img_div{
            height: fit-content;
            text-align: center;
            margin:0;
        }
        #info{
            margin: 0 10px;
        }
        .alert{
            height: 300px;
        }
        .book_info{
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 260px;
        }
        .book_img {
            height: 300px;
            width: 200px;
        }
        .book_add{
            display: flex;
            justify-content: center;
        }
        .book_add span{
            font-size: 25px;
        }
        .img_div{
            display: inline-block;
            margin: 0 10px;
            font-size: 30px;
        }
    </style>
    <script>
        $(function (){
            $(".addToCart").click(function () {
                var bookId = $(this).attr("bookId");
                //使用Ajax请求动态更新页面
                $.getJSON("${basePath}cart", "action=add&id=" + bookId, function (data) {
                    if (data.totalCount != 0) {
                        $(location).attr("href", "${basePath}pages/cart/cart.jsp")
                    }
                });
            });
        })
    </script>
</head>
<body>
<%@ include file="/pages/common/header.jsp"%>
<div id="main">
    <div class="img_div">
            <img class="book_img" alt="" src="${requestScope.book.img_path}" />
    </div>
    <div id="info">
        <div class="alert alert-success" role="alert" style="width: fit-content; padding: 10px;">
            <div class="book_info">
                <div class="book_name">
                    <span class="sp1">书名:</span>
                    <span class="sp2">${requestScope.book.name}</span>
                </div>
                <div class="book_author">
                    <span class="sp1">作者:</span>
                    <span class="sp2">${requestScope.book.author}</span>
                </div>
                <div class="book_price">
                    <span class="sp1">价格:</span>
                    <span class="sp2">￥${requestScope.book.price}</span>
                </div>
                <div class="book_sales">
                    <span class="sp1">销量:</span>
                    <span class="sp2">${requestScope.book.sales}</span>
                </div>
                <div class="book_amount">
                    <span class="sp1">库存:</span>
                    <span class="sp2">${requestScope.book.stock}</span>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="book_add">
    <button bookId="${requestScope.book.id}" type="button" class="btn btn-outline-success btn-sm addToCart"><span>加入购物车</span></button>
</div>
<script src="static/script/index.js"></script>
</body>
</html>
