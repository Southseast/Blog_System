package st.southsea.blog.module;

import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.mvc.annotation.*;
import st.southsea.blog.base.module.BaseModule;
import st.southsea.blog.bean.Article;
import st.southsea.blog.service.ArticleService;
import st.southsea.blog.service.FriendService;
import st.southsea.blog.service.LabelService;
import st.southsea.blog.service.UserService;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @Author: South
 * @Date: 2019-05-22 09:24
 */
@IocBean
@At("")
@Filters()
public class BrowseModule extends BaseModule {

    @Inject
    private UserService userService;

    @Inject
    private FriendService friendService;

    @Inject
    private ArticleService articleService;

    @Inject
    private LabelService labelService;

    public Map<String, Object> init(HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        List<Article> articleList = articleService.query();
        if (session.getAttribute("user") != (null)) {
            if (userService.fetch((String) session.getAttribute("user")) != null) {
                map.put("user", userService.fetch((String) session.getAttribute("user")));
            }
        }
        map.put("friends", friendService.query());
        map.put("host", userService.getHost());
        map.put("articleCount", articleList.size());
        map.put("labelCount", labelService.count());
        map.put("totalPages", (articleList.size() / 10) + 1);
        int trafficVolume = 0;
        for (Article article : articleList) {
            trafficVolume += article.getBrowseVolume();
        }
        map.put("trafficVolume", trafficVolume);
        return map;
    }

    // 首页查询
    @At(value = {"/", "/index"})
    @Ok("beetl:/index.html")
    public Map<String, Object> index(HttpSession session) {
        return indexPage(1, session);
    }

    // 首页分页查询
    @At("/?")
    @Ok("beetl:/index.html")
    public Map<String, Object> indexPage(int page, HttpSession session) {
        Map<String, Object> map = init(session);
        Pager pager = new Pager(page, 10);
        List<Article> articleList = articleService.query(new Article(), pager);
        map.put("articleList", articleList);
        map.put("page", page);
        return map;
    }

    // 搜索查询
    @At("/search")
    @Ok("beetl:/index.html")
    @POST
    public Map<String, Object> searchArticlePage(Article article, int page, HttpSession session) {
        Map<String, Object> map = init(session);
        Pager pager = new Pager(page, 10);
        List<Article> articleList = articleService.queryFormSearch(article, pager);
        map.put("articleList", articleList);
        map.put("page", page);
        map.put("totalPages", (articleService.queryFormSearch(article, null).size() / 10) + 1);
        return map;
    }

    // 分类页面
    @At("/label")
    @Ok("beetl:/label.html")
    public Map<String, Object> label(HttpSession session) {
        Map<String, Object> map = init(session);
        map.put("labelList", labelService.query());
        return map;
    }


    // 分类分页查询
    @At("/label/*")
    @Ok("beetl:/labels.html")
    @GET
    public Map<String, Object> labelPage(int labelId, int page, HttpSession session) {
        Map<String, Object> map = init(session);
        Article article = new Article();
        article.setLabelId(labelId);
        if (page == 0) {
            page = 1;
        }
        Pager pager = new Pager(page, 10);
        List<Article> articleList = articleService.query(article, pager);
        map.put("articleList", articleList);
        map.put("page", page);
        map.remove("totalPages");
        map.put("totalPages", (articleService.query(article, null).size() / 10) + 1);
        map.put("label", labelService.fetch(labelId));
        return map;
    }

    // 归档查询
    @At("/archives")
    @Ok("beetl:/archives.html")
    public Map<String, Object> archives(HttpSession session) {
        return archivesPage(1, session);
    }

    // 归档分页查询
    @At("/archives/?")
    @Ok("beetl:/archives.html")
    public Map<String, Object> archivesPage(int page, HttpSession session) {
        Map<String, Object> map = init(session);
        Pager pager = new Pager(page, 10);
        List<Article> articleList = articleService.query(new Article(), pager);
        map.put("page", page);
        map.put("articleList", articleList);
        return map;
    }

    // 文章查看
    @At("/article/?")
    @Ok("beetl:/article.html")
    public Object article(long articleId, HttpSession session) {

        Article originalArticle = articleService.fetchLinks(articleId);

        if (session.getAttribute(String.valueOf(articleId)) == null) {
            originalArticle.setBrowseVolume(originalArticle.getBrowseVolume() + 1);
            session.setAttribute(String.valueOf(articleId), 1);
            session.setMaxInactiveInterval(60 * 60 * 24);
        }

        articleService.update(originalArticle);

        Map<String, Object> map = init(session);
        map.put("article", originalArticle);
        List<Article> articleList = articleService.query();
        int index = 0;
        for (Article article : articleList) {
            if (article.getArticleId() == articleId) {
                if (index == 0) {
                    map.put("beforeArticle", null);
                    map.put("afterArticle", articleList.get(index + 1));
                } else if (index == articleList.size() - 1) {
                    map.put("afterArticle", null);
                    map.put("beforeArticle", articleList.get(index - 1));
                } else {
                    map.put("beforeArticle", articleList.get(index - 1));
                    map.put("afterArticle", articleList.get(index + 1));
                }
            } else {
                index++;
            }
        }
        return map;
    }
}
