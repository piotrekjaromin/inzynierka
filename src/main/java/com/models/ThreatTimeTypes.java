//package com.models;
//
//import org.hibernate.annotations.GenericGenerator;
//
//import javax.persistence.*;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//import java.util.Map;
//
///**
// * Created by piotrek on 19.11.16.
// */
//
//@Entity
//@Table
//public class ThreatTimeTypes {
//
//    @Id
//    @GeneratedValue(generator = "uuid")
//    @GenericGenerator(name = "uuid", strategy = "uuid")
//    @Column(name = "uuid", unique = true)
//    private String uuid;
//
//    String type; // stale, okresowe, jednorazowe
//
////    @ElementCollection
////    ArrayList<String> periodicDate;
//
//    Date startDate;
//
//    Date endDate;
//
////    public ArrayList<String> getPeriodicDate() {
////        return periodicDate;
////    }
////
////    public void setPeriodicDate(ArrayList<String> periodicDate) {
////        this.periodicDate = periodicDate;
////    }
//
//    public class DayDate {
//        private int day;
//        private Date startDate;
//        private Date endDate;
//
//        public int getDay() {
//            return day;
//        }
//
//        public void setDay(int day) {
//            this.day = day;
//        }
//
//        public Date getStartDate() {
//            return startDate;
//        }
//
//        public void setStartDate(Date startDate) {
//            this.startDate = startDate;
//        }
//
//        public Date getEndDate() {
//            return endDate;
//        }
//
//        public void setEndDate(Date endDate) {
//            this.endDate = endDate;
//        }
//    }
//
//    public String getUuid() {
//        return uuid;
//    }
//
//    public void setUuid(String uuid) {
//        this.uuid = uuid;
//    }
//
//    public String getType() {
//        return type;
//    }
//
//    public void setType(String type) {
//        this.type = type;
//    }
//
//    public Date getStartDate() {
//        return startDate;
//    }
//
//    public void setStartDate(Date startDate) {
//        this.startDate = startDate;
//    }
//
//    public Date getEndDate() {
//        return endDate;
//    }
//
//    public void setEndDate(Date endDate) {
//        this.endDate = endDate;
//    }
//}
