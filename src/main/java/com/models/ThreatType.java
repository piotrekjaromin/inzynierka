package com.models;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table
public class ThreatType {

    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid")
    @Column(name = "uuid", unique = true)

    private String uuid;

    private String name;

    @ManyToOne
    private ThreatType parent;

    @OneToMany
    private Set<ThreatType> childs;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ThreatType getParent() {
        return parent;
    }

    public void setParent(ThreatType parent) {
        this.parent = parent;
    }

    public void addChild(ThreatType type) {
        if(childs == null) {
            childs = new LinkedHashSet<ThreatType>();
            childs.add(type);
        } else {
            childs.add(type);
        }
    }

    public Set<ThreatType> getChilds() {
        return childs;
    }

    public void setChilds(Set<ThreatType> childs) {
        this.childs = childs;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    @Override
    public String toString() {
        return "{" +
                "\"uuid\":\"" + uuid + '\"' +
                ", \"name\":\"" + name + '\"' +
                '}';
    }
}
