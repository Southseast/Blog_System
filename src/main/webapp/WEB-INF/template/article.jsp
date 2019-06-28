<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="./common/meta.jsp" %>
    <title>南溟有猫</title>
</head>
<body>
<div class="container sidebar-position-left page-post-detail">
    <%@ include file="./common/header.jsp" %>
    <main id="main" class="main">
        <div class="main-inner">
            <div class="content-wrap">
                <div class="content">
                    <div id="posts" class="posts-expand">
                        <article class="post post-type-normal">
                            <div class="post-block" style="opacity: 1; display: block;">
                                <header class="post-header"
                                        style="opacity: 1; display: block; transform: translateY(0px);">
                                    <h2 class="post-title">
                                        <a class="post-title-link" href="/article/${obj.article.articleId}">
                                            ${obj.article.title}
                                        </a>
                                    </h2>
                                    <div class="post-meta">
                                        <span class="post-time">
                                            <span class="post-meta-item-icon">
                                                <i class="fa fa-calendar-o"></i>
                                            </span>
                                            <span class="post-meta-item-text">发表于</span>
                                            <span>${obj.article.createTime}</span>
                                            <span class="post-meta-divider">|</span>
                                            <span class="post-meta-item-icon">
                                                <i class="fa fa-calendar-check-o"></i>
                                            </span>
                                            <span class="post-meta-item-text">更新于</span>
                                            <span>${obj.article.updateTime}</span>
                                        </span>
                                        <span class="post-comments-count">
                                            <span class="post-meta-divider">|</span>
                                            <span class="post-meta-item-icon">
                                                <i class="fa fa-comment-o"></i>
                                            </span>
                                            <span class="post-meta-item-text">评论数：</span>
                                            <span>${obj.article.commentList.size()}</span>
                                        </span>
                                        <span class="leancloud_visitors">
                                            <span class="post-meta-divider">|</span>
                                            <span class="post-meta-item-icon">
                                                <i class="fa fa-eye"></i>
                                            </span>
                                            <span class="post-meta-item-text">热度：</span>
                                            <span class="leancloud-visitors-count">
                                                ${obj.article.browseVolume}
                                            </span>
                                            <span>℃</span>
                                        </span>
                                    </div>
                                </header>
                                <div class="post-body post-content"
                                     style="opacity: 1; display: block; transform: translateY(0px);">
                                    ${obj.article.content}
                                </div>
                                <footer class="post-footer">
                                    <c:if test="${obj.article.label != null}">
                                        <div class="post-tags">
                                            <a href="/label/${obj.article.label.labelId}/" rel="tag">
                                                <i class="fa fa-tag"></i> ${obj.article.label.labelName}</a>
                                        </div>
                                    </c:if>
                                    <div class="post-nav">
                                        <c:if test="${obj.beforeArticle != null}">
                                            <div class="post-nav-next post-nav-item">
                                                <a href="/article/${obj.beforeArticle.articleId}/" rel="next">
                                                    <i class="fa fa-chevron-left"></i> ${obj.beforeArticle.title} </a>
                                            </div>
                                        </c:if>
                                        <c:if test="${obj.afterArticle != null}">
                                            <span class="post-nav-divider"></span>
                                            <div class="post-nav-prev post-nav-item">
                                                <a href="/article/${obj.afterArticle.articleId}/" rel="prev">
                                                    <i class="fa fa-chevron-right"></i> ${obj.afterArticle.title} </a>
                                            </div>
                                        </c:if>
                                    </div>
                                </footer>
                            </div>
                        </article>
                    </div>
                    <div class="comments" id="comments" style="opacity: 1; display: block;">
                        <c:if test="${obj.user.email != null}">
                            <form class="layui-form" method="post">
                                <input name="articleId" type="hidden" value="${obj.article.articleId}">
                                <input name="email" type="hidden" value="${obj.user.email}">
                                <div class="layui-form-item">
                                    <textarea id="content" name="content" placeholder="请输入内容" class="simditor"
                                              style="resize:none; display: none;" lay-verify="required"></textarea>
                                </div>
                                <div class="layui-inline">
<%--                                    <input name="captcha" placeholder="验证码" type="text" lay-verify="required"--%>
<%--                                           class="article-captcha" id="captcha">--%>
<%--                                    <img src="/auth/captcha" onclick="changeCaptcha();" id="captchaImg"--%>
<%--                                         class="article-captchaImg" alt="验证码刷新中">--%>
                                    <input class="comment-post" type="submit" lay-submit lay-filter="post">
                                </div>
                            </form>
                        </c:if>
                        <c:if test="${obj.user.email == null}">
                            <nav class="site-state motion-element">
                                <div class="site-state-item site-state-posts">
                                    <span class="site-state-item-name">您还未登陆哦！</span>
                                    <a href="/auth/">
                                        <span class="site-state-item-count">登陆</span>
                                    </a>
                                </div>
                            </nav>
                        </c:if>

                        <div class="v" style="opacity: 1; display: block;">
                            <div class="vinfo" style="display:block;">
                                <div class="vcount col">
                                    <span class="vnum">${obj.article.commentList.size()}</span> 评论
                                </div>
                            </div>
                        </div>
                        <c:forEach var="comment" items="${obj.article.commentList}">
                            <div class="v" style="opacity: 1; display: block;">
                                <div class="vlist">
                                    <div class="vcard">
                                        <img class="vimg"
                                             src="${comment.user.avatarUrl}">
                                        <div class="vh">
                                            <div class="vhead">
                                                <span class="vnick">${comment.user.nickname}</span>
                                            </div>
                                            <div class="vmeta">
                                                <span class="vtime">${comment.createTime}</span>
                                            </div>
                                            <div class="vcontent">
                                                    ${comment.content}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>
            </div>
            <%@ include file="./common/aside.jsp" %>
        </div>
    </main>
    <%@ include file="./common/footer.jsp" %>
</div>
<link rel="stylesheet" href="/resources/simditor/styles/mobile.css">
<link rel="stylesheet" href="/resources/simditor/styles/simditor.css">
<script src="/resources/simditor/scripts/module.js"></script>
<script src="/resources/simditor/scripts/uploader.js"></script>
<script src="/resources/simditor/scripts/hotkeys.js"></script>
<script src="/resources/simditor/scripts/simditor.js"></script>
<script type="text/javascript">
    var editor = new Simditor({
        toolbar: [
            'title', 'bold', 'italic', 'underline', 'strikethrough', 'fontScale',
            'color', '|', 'ol', 'ul', 'blockquote', 'code', 'table', '|', 'link',
            'image', 'hr', '|', 'alignment'
        ],
        textarea: '#content',
        placeholder: '写点什么...',
        defaultImage: '/resources/static/images/avatar.png',
        imageButton: ['upload'],
        upload: {
            url: '/auth/comment/upload',
            params: null,
            fileKey: 'file',
            leaveConfirm: '正在上传文件..',
            connectionCount: 3
        }
    });
    layui.config({
        base: '/resources/static/js/'
    }).use('admin');
    layui.use(['jquery', 'form'], function () {
        var form = layui.form
            , $ = layui.$;
        //监听提交
        form.on('submit(post)', function (data) {
            $.ajax({
                url: '/auth/comment/edit',
                type: 'POST',
                dataType: 'json',
                data: data.field,
                success: function (result) {
                    if (result.ok) {
                        layer.msg("发表成功", {icon: 6, time: 1000}, function () {
                            setTimeout('window.location.reload()');
                        });
                    } else {
                        layer.msg(result.msg, {icon: 5});
                    }
                }
            });
            return false;
        });
    });

    // function changeCaptcha() {
    //     document.getElementById("captchaImg").src = "/auth/captcha?" + Math.random();
    //     document.getElementById("captcha").value = "";
    // }
</script>
</body>
</html>