package com.models;


import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.Date;

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

    private String comment;

    private Date date;

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
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

    @Override
    public String toString() {
        return "{" +
                "\"uuid\":\"" + uuid + '\"' +
                ", \"numberOfStars\":\"" + numberOfStars + '\"' +
                ", \"login\":\"" + login + '\"' +
                ", \"comment\":\"" + comment + '\"' +
                ", \"date\":\"" + date + '\"' +
                '}';
    }
}
