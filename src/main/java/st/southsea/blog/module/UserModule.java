package st.southsea.blog.module;

import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.mvc.adaptor.JsonAdaptor;
import org.nutz.mvc.annotation.*;
import org.nutz.mvc.filter.CheckSession;
import org.nutz.repo.Base64;
import st.southsea.blog.base.Result;
import st.southsea.blog.base.module.BaseModule;
import st.southsea.blog.bean.User;
import st.southsea.blog.service.UserService;
import st.southsea.blog.utils.MD5Util;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.nutz.lang.Files.copyFile;

/**
 * @Author: South
 * @Date: 2019-05-14 22:59
 */
@IocBean
@At("/auth/user")
@Filters(@By(type = CheckSession.class, args = {"admin", "/auth/login"}))
public class UserModule extends BaseModule {

    @Inject
    private UserService userService;

    @At("")
    @Ok("beetl:/auth/user/index.html")
    public Object index(HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("user", userService.fetch((String) session.getAttribute("user")));
        return map;
    }

    @At
    @POST
    public Result delete(String email) {
        User user = userService.fetch(email);
        if (user == null) {
            return ajaxError("该用户不存在");
        }
        if (user.getPermissionId() == 1) {
            return ajaxError("该用户不存在");
        }
        int i = userService.delete(email);
        return ajaxSuccess("删除成功");
    }

    @At
    @POST
    public Object list(User user, int page, int limit) {
        Pager pager = new Pager(page, limit);
        List<User> userList = userService.query(user, pager);
        return layuiTable(userList, userService.count(user));
    }

    @At("/edit")
    @Ok("beetl:/auth/user/edit.html")
    public Object edit(HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("user", new User());
        return map;
    }

    @At("/edit/?")
    @Ok("beetl:/auth/user/edit.html")
    @Filters(@By(type = CheckSession.class, args = {"user", "/auth/login"}))
    public Object edit(String email, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("user", userService.fetch(new String(Base64.decode(email))));
        return map;
    }

    @At
    @POST
    @AdaptBy(type = JsonAdaptor.class)
    public Result deleteList(List<User> userList) {
        int i = userService.delete(userList);
        return ajaxSuccess("删除成功");
    }

    // 用户更新接口
    @At
    @POST
    @Filters(@By(type = CheckSession.class, args = {"user", "/auth/login"}))
    public Result edit(HttpSession session, User user) throws NoSuchAlgorithmException, IOException {
        // 是否是用户自己更新
        if (user.getEmail().equals(session.getAttribute("user"))) {
            User originalUser = userService.fetch((String) session.getAttribute("user"));
            String filename = MD5Util.Generate(user.getEmail() + originalUser.getCreateTime());
            user.setAvatarUrl(getAvatarUrl(user, filename));
            user.setPermissionId(originalUser.getPermissionId());
            if (!user.getPassword().equals("")) {
                user.setPassword(MD5Util.Generate(user.getPassword()));
            }
            userService.update(user);
        } else {
            // 是否是管理员添加
            if (userService.fetch((String) session.getAttribute("user")).getPermissionId() == 1) {
                if (!user.getAvatarUrl().equals("")) {
                    String filename = MD5Util.Generate(user.getEmail() + new Date((new java.util.Date()).getTime()));
                    user.setAvatarUrl(getAvatarUrl(user, filename));
                } else {
                    user.setAvatarUrl(new User().getAvatarUrl());
                }
                if (!user.getPassword().equals("")) {
                    user.setPassword(MD5Util.Generate(user.getPassword()));
                }
                if (userService.fetch(user.getEmail()) != null) {
                    userService.update(user);
                } else {
                    userService.insert(user);
                }
            } else {
                return ajaxError("更新失败");
            }
        }
        return ajaxSuccess("更新成功");
    }

    public String getAvatarUrl(User user, String filename) throws IOException {
        String path = "../webapps/Blog_System/resources/avatar";
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File file = new File(user.getAvatarUrl());
        File avatar = new File(path + "/" + filename + ".jpg");
        user.setAvatarUrl(avatar.getPath().replace("../webapps/Blog_System", ""));
        copyFile(file, avatar);
        return user.getAvatarUrl();
    }

}