package com.dao;

import com.models.Coordinates;
import org.springframework.stereotype.Repository;

@Repository
public class CoordinatesDAO extends DatabaseDAO<Coordinates>{
    public void save(Coordinates coordinates) {
        getSession().save(coordinates);
    }

    public void delete (Coordinates coordinates){
        getSession().delete(coordinates);
    }

    public void update(Coordinates coordinates) {
        getSession().update(coordinates);
    }
}
