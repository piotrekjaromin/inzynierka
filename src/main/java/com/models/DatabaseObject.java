package com.models;




public abstract class DatabaseObject
{

    public String uuid;

    public String ToString()
    {
        return uuid;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }
}

