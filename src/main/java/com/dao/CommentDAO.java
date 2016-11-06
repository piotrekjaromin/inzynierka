package com.dao;

import com.models.Comment;
import com.models.Vote;
import org.springframework.stereotype.Repository;

/**
 * Created by piotrek on 05.11.16.
 */
@Repository
public class CommentDAO extends DatabaseDAO<Vote>{
    public void save(Comment comment) {
        getSession().save(comment);
    }

    public void delete (Comment comment){
        getSession().delete(comment);
    }

    public Comment get(String uuid) {
        return getSession().get(com.models.Comment.class, uuid);
    }
}
