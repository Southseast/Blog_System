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

            <div class="layui-form-item">
                <label class="layui-form-label">头像</label>
                <div class="layui-input-block">
                    <img class="author-image" itemprop="image"
                         src="<c:if test="${obj.avatarUrl == null}"> /resources/static/images/avatar.png </c:if> <c:if test="${obj.avatarUrl != null}"> ${obj.avatarUrl} </c:if>"
                         id="avatar"
                         name="avatar">
                    <button type="button" class="layui-btn" id="upload" name="upload">
                        <i class="layui-icon">&#xe67c;</i>上传头像
                    </button>
                    <input type="hidden" name="avatarUrl" id="avatarUrl" value="${obj.avatarUrl}">
                    <p id="hint"></p>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">昵称</label>
                <div class="layui-input-block">
                    <input type="text" name="nickname" placeholder="请输入昵称"
                           autocomplete="off" class="layui-input" value="${obj.nickname}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block">
                    <input type="text" name="email" placeholder="请输入邮箱"
                           autocomplete="off" class="layui-input" value="${obj.email}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="text" name="password" placeholder="请输入要更改的密码，为空则不变。"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-block">
                    <select name="sex">
                        <option value="">请选择性别</option>
                        <option value="1" <c:if test="${obj.sex == 1}"> selected </c:if>>男</option>
                        <option value="2" <c:if test="${obj.sex == 2}"> selected </c:if>>女</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-block">
                    <input type="text" name="telphone" placeholder="请输入电话"
                           autocomplete="off" class="layui-input" value="${obj.telphone}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">地区</label>
                <div class="layui-input-block">
                    <input type="text" name="region" placeholder="请输入地区"
                           autocomplete="off" class="layui-input" value="${obj.region}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">工作</label>
                <div class="layui-input-block">
                    <input type="text" name="occupation" placeholder="请输入工作"
                           autocomplete="off" class="layui-input" value="${obj.occupation}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">毕业院校</label>
                <div class="layui-input-block">
                    <input type="text" name="school" placeholder="请输入毕业院校"
                           autocomplete="off" class="layui-input" value="${obj.school}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">个性签名</label>
                <div class="layui-input-block">
                    <input type="text" name="signature" placeholder="请输入个性签名"
                           autocomplete="off" class="layui-input" value="${obj.signature}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">博客地址</label>
                <div class="layui-input-block">
                    <input type="text" name="blogAddress" placeholder="请输入博客地址"
                           autocomplete="off" class="layui-input" value="${obj.blogAddress}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">Github地址</label>
                <div class="layui-input-block">
                    <input type="text" name="githubAddress" placeholder="请输入Github地址"
                           autocomplete="off" class="layui-input" value="${obj.githubAddress}">
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

    layui.use(['jquery', 'upload', 'form'], function () {
        var upload = layui.upload
            , form = layui.form
            , $ = layui.$;

        var uploadInst = upload.render({
            elem: '#upload'
            , url: '/upload'
            , before: function (obj) {
                //预读本地文件
                obj.preview(function (index, file, result) {
                    $('#avatar').attr('src', result);
                });
            }
            , done: function (res) {
                //如果上传失败
                if (res.code > 0) {
                    return layer.msg('上传失败');
                }
                document.getElementById('avatarUrl').value = res.data.src;
                //上传成功
            }
            , error: function () {
                //演示失败状态，并实现重传
                var hint = $('#hint');
                hint.html('<span style="color: #FF5722; display: inline-block;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
                hint.find('.demo-reload').on('click', function () {
                    uploadInst.upload();
                });
            }
        });

        form.on('submit(post)', function (data) {
            let index = parent.layer.getFrameIndex(window.name);
            $.ajax({
                url: '/auth/user/edit',
                type: 'POST',
                dataType: 'json',
                data: data.field,
                success: function (result) {
                    if (result.ok) {
                        layer.msg("更改成功", {icon: 6, time: 1000}, function () {
                            parent.layer.close(index);
                            parent.layui.table.reload('manage');
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