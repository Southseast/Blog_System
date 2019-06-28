<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside id="sidebar" class="sidebar" style="margin-top: 250px; margin-left: initial;">

    <form class="layui-form" action="/search" method="post">
        <input class="search-article-input" placeholder="搜索" name="content">
        <input type="hidden" lay-submit lay-filter="search">
    </form>

    <div class="sidebar-inner affix-top" style="opacity: 1; display: block; transform: initial;">

        <ul class="sidebar-nav motion-element">
            <li class="sidebar-nav-overview" data-target="site-overview-wrap">站点概览</li>
            <li class="sidebar-nav-toc sidebar-nav-active" data-target="user-toc-wrap">个人信息</li>
        </ul>
        <section class="site-overview-wrap sidebar-panel"
                 style="opacity: 0; transform: translateY(0px); display: none;">
            <div class="site-overview" style="width: calc(100% + 15px);">
                <div class="site-author motion-element">

                    <a href="/auth/">
                        <img class="site-author-image" src="${obj.host.avatarUrl}">
                    </a>
                    <p class="site-author-name">${obj.host.nickname}</p>
                    <p class="site-description motion-element">${obj.host.signature}</p>
                </div>
                <nav class="site-state motion-element">
                    <div class="site-state-item site-state-posts">
                        <a href="/archives">
                            <span class="site-state-item-count">${obj.articleCount}</span>
                            <span class="site-state-item-name">日志</span>
                        </a>
                    </div>
                    <div class="site-state-item site-state-tags">
                        <a href="/label">
                            <span class="site-state-item-count">${obj.labelCount}</span>
                            <span class="site-state-item-name">标签</span>
                        </a>
                    </div>
                </nav>
                <div class="links-of-author motion-element">
                    <span class="links-of-author-item">
                        <a href="${obj.host.githubAddress}" target="_blank" title="GitHub" rel="external nofollow">
                            <i class="fa fa-fw fa-github"></i>GitHub</a>
                    </span> <span class="links-of-author-item">
                        <a href="mailto:${obj.host.email}" target="_blank" title="E-Mail" rel="external nofollow">
                            <i class="fa fa-fw fa-envelope"></i>E-Mail</a>
                    </span>
                </div>
                <div class="links-of-blogroll motion-element links-of-blogroll-block">
                    <div class="links-of-blogroll-title">
                        <i class="fa fa-fw fa-link"></i> Links
                    </div>
                    <ul class="links-of-blogroll-list">

                        <c:forEach var="friend" items="${obj.friend}" varStatus="status">
                            <li class="links-of-blogroll-item">
                                <a href="<c:out value="${friend.blogAddress}"></c:out>" title="H4mster" target="_blank">
                                    <c:out value="${friend.nickname}"></c:out></a>
                            </li>
                        </c:forEach>

                    </ul>
                </div>
            </div>
        </section>

        <!--noindex-->
        <section class="user-toc-wrap motion-element sidebar-panel sidebar-panel-active"
                 style="opacity: 1; display: block; transform: translateY(0px);">
            <div class="site-overview" style="width: calc(100% + 15px);">
                <div class="site-author motion-element">
                    <c:if test="${obj.user != null}">
                        <a href="/auth/">
                            <img class="site-author-image" src="${obj.user.avatarUrl}">
                        </a>
                        <p class="site-author-name">${obj.user.nickname}</p>
                        <p class="site-description motion-element">${obj.user.signature}</p>
                        <a href="/auth/"><p class="site-description motion-element" style="text-align: center">个人中心</p>
                        </a>
                        <a href="/auth/logout"><p class="site-description motion-element" style="text-align: center">
                            退出登陆</p></a>
                    </c:if>
                    <c:if test="${obj.user == null}">
                        <nav class="site-state motion-element">
                            <div class="site-state-item site-state-posts">
                                <span class="site-state-item-name">您还未登陆哦！</span>
                                <a href="/auth/">
                                    <span class="site-state-item-count">登陆</span>
                                </a>
                            </div>
                        </nav>
                    </c:if>
                </div>
            </div>
        </section>
    </div>
</aside>

<script type="text/javascript">

    layui.config({
        base: '/resources/static/js/'
    }).use('admin');

    layui.use(['form'], function () {
        var form = layui.form;
        //监听提交
        form.on('submit(search)', function (data) {
            $.ajax({
                url: '/auth/article/list',
                type: 'POST',
                dataType: 'json',
                data: data.field,
                success: function (result) {
                    if (result.ok) {
                        layer.msg("发表成功", {icon: 6, time: 1000});
                    } else {
                        layer.msg(result.msg, {icon: 5});
                    }
                }
            });
            return false;
        });
    });
</script>