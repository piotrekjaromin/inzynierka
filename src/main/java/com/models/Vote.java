package com.models;


import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table
public class Vote {
    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid")
    @Column(name = "uuid", unique = true)

    private String uuid;

    private short numberOfStars;

    private String login;

    private String voteComment;

    private Date date;

    @OneToMany
    private List<Comment> comments;

    public String getVoteComment() {
        return voteComment;
    }

    public void setVoteComment(String voteComment) {
        this.voteComment = voteComment;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public short getNumberOfStars() {
        return numberOfStars;
    }

    public void setNumberOfStars(short numberOfStars) {
        this.numberOfStars = numberOfStars;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    @Override
    public String toString() {
        return "{" +
                "\"uuid\":\"" + uuid + '\"' +
                ", \"numberOfStars\":\"" + numberOfStars + '\"' +
                ", \"login\":\"" + login + '\"' +
                ", \"voteComment\":\"" + voteComment + '\"' +
                ", \"date\":\"" + date + '\"' +
                ", \"comments\":\"" + comments + '\"' +
                '}';
    }
}
