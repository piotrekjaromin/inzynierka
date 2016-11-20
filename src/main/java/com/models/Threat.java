package com.models;


import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.Date;
import java.util.List;
import java.util.Map;


@Entity
@Table
public class Threat extends DatabaseObject {

    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid")
    @Column(name = "uuid", unique = true)
    private String uuid;

    @ManyToOne
    private ThreatType type;


    private String description;

    private String login;

    private Date date;

    private String pathToPhoto;

    @OneToMany
    private List<Vote> votes;

    @OneToOne
    private Coordinates coordinates;

//    @OneToMany
//    private ThreatTimeTypes timeTypes;

    private boolean isApproved;

    private Date startDate;
    private Date endDate;
    private String dateType;

    @ElementCollection
    private List<Integer> periodicDays;

    public String getDateType() {
        return dateType;
    }

    public void setDateType(String dateType) {
        this.dateType = dateType;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public List<Integer> getPeriodicDays() {
        return periodicDays;
    }

    public void setPeriodicDays(List<Integer> periodicDays) {
        this.periodicDays = periodicDays;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public Coordinates getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(Coordinates coordinates) {
        this.coordinates = coordinates;
    }

    public ThreatType getType() {
        return type;
    }

    public void setType(ThreatType type) {
        this.type = type;
    }


    public void addVote(Vote vote) {
        votes.add(vote);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

//    public ThreatTimeTypes getTimeTypes() {
//        return timeTypes;
//    }
//
//    public void setTimeTypes(ThreatTimeTypes timeTypes) {
//        this.timeTypes = timeTypes;
//    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public List<Vote> getVotes() {
        return votes;
    }

    public void setVotes(List<Vote> votes) {
        this.votes = votes;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public boolean getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(boolean isApproved) {
        this.isApproved = isApproved;
    }

    public String getPathToPhoto() {
        return pathToPhoto;
    }

    public void setPathToPhoto(String pathToPhoto) {
        this.pathToPhoto = pathToPhoto;
    }

    public void deleteAllConection(){
        type=null;
        votes.clear();
        coordinates=null;

    }


    @Override
    public String toString() {
        return "{" +
                "\"uuid\":\"" + uuid  + '\"' +
                ", \"login\":\"" + login + '\"'+
                ", \"type\":" + type +
                ", \"description\":\"" + description + '\"' +
                ", \"votes\": " + votes +
                ", \"coordinates\":" + coordinates +
                ", \"isApproved\":\"" + isApproved + '\"' +
                ", \"path to photo\":\"" + pathToPhoto + '\"' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Threat threat = (Threat) o;

        return uuid.equals(threat.uuid);

    }

    @Override
    public int hashCode() {
        return uuid.hashCode();
    }
}
