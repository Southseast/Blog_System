<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
    <title>管理</title>
    <%@ include file="../common/meta.jsp" %>
</head>
<body>
<div class="layui-fluid" style="margin: 20px;">
    <div class="layui-col-md3">
        <form class="layui-form" action="">

            <input name="friendId" type="hidden" value="${obj.friendId}">

            <div class="layui-form-item">
                <label class="layui-form-label">昵称</label>
                <div class="layui-input-block">
                    <input type="text" name="nickname" required lay-verify="required" placeholder="请输入昵称"
                           autocomplete="off" class="layui-input" value="${obj.nickname}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">博客地址</label>
                <div class="layui-input-block">
                    <input type="text" name="blogAddress" required lay-verify="required" placeholder="请输入博客地址"
                           autocomplete="off" class="layui-input" value="${obj.blogAddress}">
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit lay-filter="post">立即提交</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>
    </div>
</div>


<script type="text/javascript">
    layui.config({
        base: '/resources/static/js/'
    }).use('admin');

    layui.use(['jquery', 'form'], function () {
        var form = layui.form
            , $ = layui.$;

        form.on('submit(post)', function (data) {
            let index = parent.layer.getFrameIndex(window.name);
            $.ajax({
                url: '/auth/friend/edit',
                type: 'POST',
                dataType: 'json',
                data: data.field,
                success: function (result) {
                    if (result.ok) {
                        layer.msg("发表成功", {icon: 6, time: 1000}, function () {
                            parent.layui.table.reload('manage');
                            parent.layer.close(index);
                        });
                    } else {
                        layer.msg(result.msg, {icon: 5});
                    }
                }
            });
            return false;
        });
    });
</script>
</body>
</html>