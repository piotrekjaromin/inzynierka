package com.dao;

import com.configuration.CryptWithMD5;
import com.models.UserModel;
import org.hibernate.Query;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.stream.Collectors;


@Repository
public class UserModelDAO extends DatabaseDAO<UserModel> {


    @Autowired
    CryptWithMD5 cryptWithMD5;

    public void save(UserModel user) {
        user.setPassword(cryptWithMD5.encode(user.getPassword()));
        getSession().save(user);
    }

    public UserModel setPasswordEncryped(UserModel user, String password){
        user.setPassword(cryptWithMD5.encode(password));
        return user;
    }

    public boolean isValidUser(String login, String password) {
        UserModel user = getByLogin(login);
        return (user!=null && user.getPassword().equals(password));
    }


    public UserModel get(String uuid) {

        return getSession().get(com.models.UserModel.class, uuid);
    }


    public UserModel getByLogin(String login) {

        Query query = getSession().createQuery("from UserModel where login LIKE ?");
        query.setString(0, login);
        if(query.list().isEmpty())
            return null;
        query.setString(0, login);
        return (UserModel) query.list().get(0);
    }


    public List<UserModel> getAll() {

        Query query = getSession().createQuery("from UserModel");
        List<UserModel> users = query.list();
        return users;
    }


    public void update(UserModel user) {
        getSession().update(user);
    }

    public void delete(String uuid) {
        getSession().delete(get(uuid));
    }

    public boolean isLogin(String login){
        Query query = getSession().createQuery("from UserModel where login='" + login + "'");
        return !query.list().isEmpty();
    }

    public boolean isMail(String mail){
        Query query = getSession().createQuery("from UserModel where mail='" + mail + "'");
        return !query.list().isEmpty();
    }

    public UserModel getByIdNumber(int idNumber){
        Query query = getSession().createQuery("from UserModel where idNumber='" + idNumber + "'");
        if(query.list().isEmpty())
            return null;
        return (UserModel)query.list().get(0);
    }


}