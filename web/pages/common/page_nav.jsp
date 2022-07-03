<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript">
    $(function (){
        $(".searchBtn").click(function (){
            var check = /^[0-9]*[1-9][0-9]*$/;
            var pageNo = $(".page_input").val();
            if (check.test(pageNo))
                location.href = "<%=basePath%>"+"${requestScope.page.url}&pageNo="+pageNo;
            else
            {
                $("#page_error_info").modal("toggle");
            }
        });
    });
    <c:if test="${not empty requestScope.msg_info}">
    window.onload = function (){
        $("#info").modal("toggle");
    }
    </c:if>
</script>
<style>
    .page-item.active .page-link{
        background-color: #79bd9a;
        border-color: #79bd9a;
    }
    .page-link:hover{
        color: #79bd9a;
    }
    .page-link{
        color: #79bd9a;
    }
    .page_alert{
        width: fit-content;
        padding: 6px;
        margin: auto 10px;
    }
    .pagination{
        margin: 0;
    }
    #jump{
        justify-content: center;
        align-items: center;
        margin: auto 10px;
    }
    #jump input{
        width: 60px;
        text-align: center;
        display: inline-block;
    }
</style>
<div style="width: 80%; margin: 20px auto; display: flex; justify-content: center; align-items: center">
    <nav aria-label="Page navigation example" style="width: fit-content; margin: 0 10px">
        <ul class="pagination">
            <c:if test="${requestScope.page.pageNo>1}">
                <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=1">首页</a></li>
                <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=${requestScope.page.pageNo-1}">上一页</a></li>
            </c:if>
            <c:choose>
                <c:when test="${requestScope.page.pageTotal <= 5}">
                    <c:forEach begin="1" end="${requestScope.page.pageTotal}" var="i">
                        <c:if test="${i == requestScope.page.pageNo}">
                            <li class="page-item active"><a class="page-link" href="${requestScope.page.url}&pageNo=${i}">${i}</a></li>
                        </c:if>
                        <c:if test="${i != requestScope.page.pageNo}">
                            <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=${i}">${i}</a></li>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:when test="${requestScope.page.pageTotal > 5}">
                    <c:choose>
                        <c:when test="${requestScope.page.pageNo <= 3}">
                            <c:forEach begin="1" end="5" var="i">
                                <c:if test="${i == requestScope.page.pageNo}">
                                    <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
                                </c:if>
                                <c:if test="${i != requestScope.page.pageNo}">
                                    <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=${i}">${i}</a></li>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:when test="${requestScope.page.pageNo > requestScope.page.pageTotal - 3}">
                            <c:forEach begin="${requestScope.page.pageTotal-4}" end="${requestScope.page.pageTotal}" var="i">
                                <c:if test="${i == requestScope.page.pageNo}">
                                    <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
                                </c:if>
                                <c:if test="${i != requestScope.page.pageNo}">
                                    <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=${i}">${i}</a></li>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:forEach begin="${requestScope.page.pageNo-2}" end="${requestScope.page.pageNo+2}" var="i">
                                <c:if test="${i == requestScope.page.pageNo}">
                                    <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
                                </c:if>
                                <c:if test="${i != requestScope.page.pageNo}">
                                    <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=${i}">${i}</a></li>
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </c:when>
            </c:choose>
            <c:if test="${requestScope.page.pageNo < requestScope.page.pageTotal}">
                <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=${requestScope.page.pageNo+1}">下一页</a></li>
                <li class="page-item"><a class="page-link" href="${requestScope.page.url}&pageNo=${requestScope.page.pageTotal}">末页</a></li>
            </c:if>
        </ul>
    </nav>
    <div id="jump">
        跳转到
        <input type="text" class="form-control page_input" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm"> 页
        <button type="button" class="btn btn-outline-success btn-sm searchBtn">确定</button>
    </div>
    <div class="alert alert-success page_alert" role="alert">
        共${requestScope.page.pageTotal}页，${requestScope.page.pageTotalCount}条记录
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
<div class="modal fade" id="page_error_info" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabelInfo2">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="text-align: center">
                别闹，输入一个正常的数哦！
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>