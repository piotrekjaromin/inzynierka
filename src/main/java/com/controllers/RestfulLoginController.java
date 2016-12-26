package com.controllers;


import com.configuration.IdNumberGenerator;
import com.models.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

@RestController
public class RestfulLoginController extends BaseController {



    /**
     * Rejestracja uzytkownika. Wszyscy maja dostep
     * @return status
     */

    @RequestMapping(value = "/rest/registration/", method = RequestMethod.POST)
    public ResponseEntity<String> registrationUser(HttpServletRequest request) {
        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String mail = request.getParameter("mail");
        String role = request.getParameter("userRole");

        if(userModelDAO.isLogin(login)) return new ResponseEntity<String>("{\"status\" : \"Failure login is already in use\"}", HttpStatus.IM_USED);
        if(userModelDAO.isMail(mail)) return new ResponseEntity<String>("{\"status\" : \"Failure mail is already in use\"}", HttpStatus.IM_USED);

        UserModel user = new UserModel();
        user.setIdNumber(new IdNumberGenerator().getRandomNumberInRange(userModelDAO, 100000, 999999));
        user.setLogin(login);
        user.setPassword(password);
        user.setMail(mail);
        user.setSurname(surname);
        user.setName(name);
        UserRole userRole = new UserRole();
        userRole.setType(role);
        userRole = userRoleDAO.saveIfNotInDB(userRole);
        user.setUserRole(userRole);
        userModelDAO.save(user);
        return new ResponseEntity<String>("{\"status\" : \"Success\"}", HttpStatus.OK);

    }

    /**
     * Rejestracja konta admina. Tylko admin
     * @return status
     */

    @RequestMapping(value = "/rest/registrationAdmin/", method = RequestMethod.POST)
    public ResponseEntity<String> registrationAdmin(HttpServletRequest request) {
        UserModel user = new UserModel();
        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String mail= request.getParameter("mail");
        String name= request.getParameter("name");
        String surname = request.getParameter("surname");
        String token = request.getParameter("token");

        Session session = sessionManager.getAndUpdateSession(token);

        if(session==null)
            return new ResponseEntity<String>("{\"status\" : \"Failure no session available with given token\"}", HttpStatus.UNAUTHORIZED);

        UserModel admin = userModelDAO.getByLogin(session.getLogin());

        if (admin.getUserRole().getType().equals("ADMIN")) {
            if (userModelDAO.isLogin(login))
                return new ResponseEntity<String>("{\"status\" : \"Failure login is used\"}", HttpStatus.IM_USED);

            if (userModelDAO.isMail(mail)) {
                return new ResponseEntity<String>("{\"status\" : \"Failure login is used\"}", HttpStatus.IM_USED);
            }
            UserRole userRole = new UserRole();
            userRole.setType("ADMIN");

            userRole = userRoleDAO.saveIfNotInDB(userRole);
            user.setLogin(login);
            user.setPassword(password);
            user.setName(name);
            user.setSurname(surname);
            user.setMail(mail);
            user.setIdNumber(new IdNumberGenerator().getRandomNumberInRange(userModelDAO, 100000, 999999));
            user.setUserRole(userRole);
            userModelDAO.save(user);
            return new ResponseEntity<String>("{\"status\" : \"Success\"}", HttpStatus.CREATED);
        } else {
            return new ResponseEntity<String>("{\"status\" : \"Failure: no user role\"}", HttpStatus.FORBIDDEN);
        }

    }

    /**
     * Logownaie. Wszyscy maja dostep
     * HASLO ZASZYFROWANE MD5 !!!!!!!
     * @return status
     */

    @RequestMapping(value = "/rest/login/", method = RequestMethod.POST)
    public ResponseEntity<String> logIn(HttpServletRequest request) {

        String login = request.getParameter("login");
        String password = request.getParameter("password");

        if (userModelDAO.isValidUser(login, password)) {

            String token = sessionManager.createUserSession(login);
            String response = "{ \"token\" : \"" + token + "\", \"role\" : \"" + userModelDAO.getByLogin(login).getUserRole().getType() + "\"," + "\"userID\" : \"" + userModelDAO.getByLogin(login).getUuid() +  "\"}";
            return new ResponseEntity<String>(response, HttpStatus.OK);
        } else {
            return new ResponseEntity<String>("{\"status\" : \"Failure: wrong user or password\"}", HttpStatus.NOT_FOUND);
        }
    }

    /**
     * Wylogowywanie. Wszyscy zalogowani maja dostep
     * @return status
     */

    @RequestMapping(value = "/rest/logout", method = RequestMethod.POST)
    public ResponseEntity<String> logOut(HttpServletRequest request) {
        String token = request.getParameter("token");
        if (sessionManager.closeSession(token))
            return new ResponseEntity<String>("{\"status\" : \"Success\"}", HttpStatus.OK);
        else
            return new ResponseEntity<String>("{\"status\" : \"Failure\"}", HttpStatus.UNAUTHORIZED);
    }

    /**
     * usuwanie uzytkownika. Tylko admin ma dostep
     * @return status
     */

    @RequestMapping(value = "/rest/deleteUser/", method = RequestMethod.DELETE)
    public ResponseEntity<String> deleteUser(HttpServletRequest request) {
        String token = request.getParameter("token");
        String idNumber = request.getParameter("idNumber");
        Session session = sessionManager.getAndUpdateSession(token);

        if(session==null)
            return new ResponseEntity<String>("{\"status\" : \"Failure no session available with given token\"}", HttpStatus.UNAUTHORIZED);

        String login = session.getLogin();
        UserModel userToDelete = userModelDAO.getByIdNumber(Integer.parseInt(idNumber));
        UserModel user = userModelDAO.getByLogin(login);
        if(user.getUserRole().getType().equals("ADMIN")){
            if( userToDelete== null){
                return new ResponseEntity<String>("{\"status\" : \"Failure: no user with this idNumber\"}", HttpStatus.NOT_FOUND);
            }
            userModelDAO.delete(userToDelete.getUuid());
            return new ResponseEntity<String>("{\"status\" : \"Success\"}", HttpStatus.OK);
        }else
            return new ResponseEntity<String>("{\"status\" : \"Failure you are no admin\"}", HttpStatus.UNAUTHORIZED);
    }

}
