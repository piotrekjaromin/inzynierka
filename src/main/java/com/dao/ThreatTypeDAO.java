package com.dao;

import com.models.Threat;
import com.models.ThreatType;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by piotrek on 05.03.16.
 */
@Repository
public class ThreatTypeDAO extends DatabaseDAO<ThreatType>{
        public void save(ThreatType type) {

            getSession().save(type);
        }

    public void delete (ThreatType type){
        getSession().delete(type);
    }

    public void update(ThreatType threatType) {
        getSession().update(threatType);
    }

    public List<ThreatType> getAll() {
        return getSession().createQuery("from ThreatType").list();
    }

    }