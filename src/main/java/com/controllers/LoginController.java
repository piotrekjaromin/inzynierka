package com.controllers;

import com.configuration.IdNumberGenerator;
import com.dao.UserModelDAO;
import com.dao.UserRoleDAO;
import com.models.UserModel;
import com.models.UserRole;
import com.models.UserRoleType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;




@Controller
public class LoginController extends BaseController {

    @Autowired
    UserRoleDAO userRoleDAO;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(ModelMap model) {

        model.addAttribute("approvedThreats", threatDAO.getAllApproved());
        model.addAttribute("notApprovedThreats", threatDAO.getAllNotApproved());
        model.addAttribute("addedToday", threatDAO.addedToday());
        return "index";
    }

    @RequestMapping(value = "/admin", method = RequestMethod.GET)
    public String adminPage(ModelMap model) {
        model.addAttribute("user", getPrincipal());
        return "index";
    }

    @RequestMapping(value = "/tables", method = RequestMethod.GET)
    public String tablePage(ModelMap model) {
        model.addAttribute("user", getPrincipal());
        return "tables";
    }

    @RequestMapping(value = "/user", method = RequestMethod.GET)
    public String userPage(ModelMap model) {
        model.addAttribute("user", getPrincipal());
        return "index";
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String loginPage() {
        return "login";
    }

    @RequestMapping(value = "/user/userProfile", method = RequestMethod.GET)
    public String userProfilePage() {
        return "userProfile";
    }

    @RequestMapping(value = "/user/userDetails", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public UserModel userDetails() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserModel user = userModelDAO.getByLogin(userDetails.getUsername());

        return user;
    }

    @RequestMapping(value="/logout", method = RequestMethod.GET)
    public String logoutPage (HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null){
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "index";
    }

    @RequestMapping(value = "/Access_Denied", method = RequestMethod.GET)
    public String accessDenied() {
        return "accessDenied";
    }

    @RequestMapping(value = "/registration", method = RequestMethod.GET)
    public String registration() {
        return "registration";
    }

    @RequestMapping(value = "/registration", method = RequestMethod.POST)
    @ResponseBody
    public String addUser(HttpServletRequest request) {

        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String mail = request.getParameter("mail");
        String role = request.getParameter("userRole");

        if(userModelDAO.isLogin(login)) return "Failure: login is used";
        if(userModelDAO.isMail(mail)) return "Failure: mail is used";

        UserModel user = new UserModel();
        user.setIdNumber(new IdNumberGenerator().getRandomNumberInRange(userModelDAO, 100000, 999999));
        user.setLogin(login);
        user.setPassword(password);
        user.setMail(mail);
        user.setSurname(surname);
        user.setName(name);
        user.setPassword(password);
        UserRole userRole = new UserRole();
        userRole.setType("USER");
        userRole = userRoleDAO.saveIfNotInDB(userRole);
        user.setUserRole(userRole);
        userModelDAO.save(user);
        return "Success";
    }


//    @RequestMapping(value = "/registration", method = RequestMethod.POST, headers = {"Accept=application/json"})
//    @ResponseBody
//    public String addUser(UserModel user) {
//
//        System.out.println(user);
//        //if(userModelDAO.isLogin(user.getLogin())) return "Failure: login is used";
//        //if(userModelDAO.isMail(user.getMail())) return "Failure: mail is used";
//        //user.setUserRole(userRoleDAO.saveIfNotInDB(user.getUserRole()));
//        //user.setIdNumber(new IdNumberGenerator().getRandomNumberInRange(userModelDAO, 100000, 999999));
//        //userModelDAO.save(user);
//        return "Success";
//    }

    //    uruchomic tylko raz, dodaje konto admina
    @RequestMapping(value = "/addAdmin", method = RequestMethod.GET)
    @ResponseBody
    public String addAdmin() {
        UserModel user = new UserModel();
        user.setLogin("admin");
        user.setPassword("password");
        user.setName("adminName");
        user.setSurname("adminSurname");
        user.setMail("adminMail");
        user.setIdNumber(100000);
        UserRole role = new UserRole();
        role.setType("ADMIN");
        role = userRoleDAO.saveIfNotInDB(role);
        user.setUserRole(role);
        userModelDAO.save(user);
        return "Success";
    }

    private String getPrincipal(){
        String userName = null;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            userName = ((UserDetails)principal).getUsername();
        } else {
            userName = principal.toString();
        }
        return userName;
    }

}