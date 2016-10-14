package com.dao;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Transactional
@Repository
abstract class DatabaseDAO<T> {

    @Autowired
    private SessionFactory sessionFactory;

    public Session getSession(){

        return sessionFactory.getCurrentSession();
    }


   // public abstract void save(T item);
   // public abstract  T get(String uuid);
   // public abstract List<? extends T> getAll();



}