package com.controllers;

import com.dao.UserRoleDAO;
import com.models.Threat;
import com.models.UserModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class UserController extends BaseController {

    @Autowired
    UserRoleDAO userRoleDAO;

    @RequestMapping(value = "/user/userProfile", method = RequestMethod.GET)
    public String userProfilePage() {
        return "userProfile";
    }

    @RequestMapping(value = "/user/details", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public UserModel userDetails() {

        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userModelDAO.getByLogin(userDetails.getUsername());
    }

    @RequestMapping(value = "/user/myThreats", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public List<Threat> myThreats() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserModel user = userModelDAO.getByLogin(userDetails.getUsername());

        return threatDAO.myThreat(userDetails.getUsername());
    }

    @RequestMapping(value = "/user/editProfile", method = RequestMethod.GET)
    public String goToEditProfile(ModelMap model) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        model.addAttribute("user", userModelDAO.getByLogin(userDetails.getUsername()));
        return "editProfile";
    }


    @RequestMapping(value = "/user/editProfile", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String editProfile(HttpServletRequest request) {
        String userUuid = request.getParameter("uuid");
        String userMail = request.getParameter("mail");
        String userName = request.getParameter("name");
        String userSurname = request.getParameter("surname");
        String password = request.getParameter("password");

        UserModel user = userModelDAO.get(userUuid);
        if(userModelDAO.isMail(userMail) && !userMail.equals(user.getMail()) ) return "Failure: mail is used";

        user.setMail(userMail);
        user.setName(userName);
        user.setSurname(userSurname);
        user.setPassword(password);
        userModelDAO.update(user);
        return "Success";
    }
}