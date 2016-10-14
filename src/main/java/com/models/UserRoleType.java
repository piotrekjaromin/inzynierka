package com.models;


public enum UserRoleType {
    USER("USER"),
    ADMIN("ADMIN");

    private String userRoleType;

    private UserRoleType(String userRoleType){
        this.userRoleType = userRoleType;
    }

    public String getUserRoleType(){
        return userRoleType;
    }
}
