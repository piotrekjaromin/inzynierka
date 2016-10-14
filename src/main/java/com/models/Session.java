package com.models;

import org.joda.time.DateTime;





public class Session {
    private String login;
    private DateTime expirationTime;
    private String token;

    public Session withLogin(String login){
        this.login = login;
        return this;
    }

    public Session withExpirationTime(DateTime expirationTime){
        this.expirationTime = expirationTime;
        return this;
    }

    public Session withToken(String token){
        this.token = token;
        return this;
    }

    public String getLogin() {
        return login;
    }

    public DateTime getExpirationTime() {
        return expirationTime;
    }

    public String getToken() {
        return token;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public void setExpirationTime(DateTime expirationTime) {
        this.expirationTime = expirationTime;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
