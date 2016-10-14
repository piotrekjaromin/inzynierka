package com.dao;

import com.models.Vote;
import org.springframework.stereotype.Repository;

@Repository
public class VoteDAO extends DatabaseDAO<Vote>{
    public void save(Vote vote) {
        getSession().save(vote);
    }

    public void delete (Vote vote){
        getSession().delete(vote);
    }

    public Vote get(String uuid) {
        return getSession().get(com.models.Vote.class, uuid);
    }
}