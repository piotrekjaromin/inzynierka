package com.dao;

import com.models.UserModel;
import com.models.UserRole;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import java.util.*;



@Repository
public class UserRoleDAO extends DatabaseDAO<UserRole> {

    public void save(UserRole role) {
        getSession().save(role);
    }


    public UserRole get(String uuid) {

        return getSession().get(com.models.UserRole.class, uuid);
    }

    public List<UserRole> getAll() {

        Query query = getSession().createQuery("from UserRole");
        List<UserRole> list = query.list();
        return list;

    }


    public Optional<UserRole> isContain(final UserRole role) {

        return getAll().stream().filter(a -> a.equals(role)).findFirst();
    }

    public UserRole saveIfNotInDB(UserRole userRole) {
        Optional<UserRole> userRoleOptional = isContain(userRole);
        if (userRoleOptional.isPresent()) {
            return userRoleOptional.get();
        } else {
            save(userRole);
            return userRole;
        }
    }



}