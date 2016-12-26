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
    public String userDetails() {

        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserModel user =userModelDAO.getByLogin(userDetails.getUsername());
        String result = "{ \"login\" : \"" + user.getLogin() + "\",";
        result += "\"mail\" : \"" + user.getMail() + "\",";
        result += "\"name\" : \"" + user.getName() + "\",";
        result += "\"surname\" : \"" + user.getSurname() + "\"}";
        return result;
    }

    @RequestMapping(value = "/user/myThreats", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String myThreats() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserModel user = userModelDAO.getByLogin(userDetails.getUsername());
        String result = "{\"threats\": [";
        int counter = 0;
        for(Threat threat : threatDAO.myThreat(userDetails.getUsername())) {
            counter++;
            result += "{ \"uuid\" : \"" + threat.getUuid() + "\",";
            result += "\"type\" : \"" + threat.getType().getName() + "\",";
            result += "\"description\" : \"" + threat.getDescription() + "\",";
            result += "\"isApproved\" : \"" + threat.getIsApproved() + "\"}";
            if(counter < threatDAO.myThreat(userDetails.getUsername()).size())
                result += ",";

        }
        result += "]}";
        return result;
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
        String userUuid = convertString(request.getParameter("uuid"));
        String userMail = convertString(request.getParameter("mail"));
        String userName = convertString(request.getParameter("name"));
        String userSurname = convertString(request.getParameter("surname"));
        String password = convertString(request.getParameter("password"));

        UserModel user = userModelDAO.get(userUuid);
        if(userModelDAO.isMail(userMail) && !userMail.equals(user.getMail()) ) return "Failure: mail is used";

        user.setMail(userMail);
        user.setName(userName);
        user.setSurname(userSurname);
        user.setPassword(password);
        userModelDAO.update(user);
        return "Success";
    }

    public String convertString(String str) {
        return str.replaceAll("Ä\u0085", "ą").replaceAll("Ä\u0084", "Ą").replaceAll("Å\u009B", "ś").replaceAll("Å\u009A", "Ś")
                .replaceAll("Å\u0082", "ł").replaceAll("Å\u0081", "Ł").replaceAll("Å¼", "ż").replaceAll("'Å»", "Ż").replaceAll("'Åº", "ź")
                .replaceAll("'Å¹", "Ź").replaceAll("Ä\u0087", "ć").replaceAll("Ä\u0086", "Ć").replaceAll("Å\u0084", "ń").replaceAll("Å\u0083", "Ń")
                .replaceAll("Ä\u0099", "ę").replaceAll("Ä\u0098", "Ę").replaceAll("Ã³", "ó").replaceAll("Ã\u0093", "Ó");
    }
}