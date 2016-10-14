package com.models;


import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.joda.time.Days;
import org.joda.time.LocalDate;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;



@Entity
@Table
public class UserModel extends DatabaseObject
{
        @Id
        @GeneratedValue(generator = "uuid")
        @GenericGenerator(name = "uuid", strategy = "uuid")
        @Column(name = "uuid", unique = true)

        private String uuid;

        private int idNumber;

        @Column(unique = true, nullable = false)
        private String login;

        @Column(nullable = false)
        private String password;

        @Column(unique = true, nullable = false)
        private String mail;

        @Column(nullable = false)
        private String name;

        @Column(nullable = false)
        private String surname;

        @OneToMany
        private List<Threat> threats;


        @ManyToOne(fetch = FetchType.EAGER)
        @JoinTable(name="user_userRole",
                        joinColumns = {@JoinColumn(name="userId")},
                        inverseJoinColumns = {@JoinColumn(name="userProfileId")})
        private UserRole userRole;


        public String getUuid() {
                return uuid;
        }

        public void setUuid(String uuid) {
                this.uuid = uuid;
        }



        public String getLogin() {
                return login;
        }

        public void setLogin(String login) {
                this.login = login;
        }

        public String getPassword() {
                return password;
        }

        public void setPassword(String password) {
                this.password = password;
        }


        public UserRole getUserRole() {
                return userRole;
        }

        public void setUserRole(UserRole userRole) {
                this.userRole = userRole;
        }

        public String getMail() {
                return mail;
        }

        public void setMail(String mail) {
                this.mail = mail;
        }

        public String getName() {
                return name;
        }

        public void setName(String name) {
                this.name = name;
        }

        public String getSurname() {
                return surname;
        }

        public void setSurname(String surname) {
                this.surname = surname;
        }

        public List<Threat> getThreats() {
                return threats;
        }

        public void setThreats(List<Threat> threats) {
                this.threats = threats;
        }

        public void addThread (Threat threat) {
                threats.add(threat);
        }

        public void deleteThreat(Threat threat){
                threats.remove(threat);
        }

        @Override
        public String toString() {
                return "{" +
                        "\"uuid\":\"" + uuid  + '\"' +
                        ", \"login\":\"" + login + '\"'+
                        ", \"name\":\"" + name + '\"' +
                        ", \"surname\":\"" + surname + '\"' +
                        ", \"mail\":\"" + mail + '\"' +
                        ", \"idNumber\":\"" + idNumber + '\"' +
                        ", \"threats\":" + threats  +
                        '}';
        }

        @Override
        public boolean equals(Object o) {
                if (this == o) return true;
                if (o == null || getClass() != o.getClass()) return false;

                UserModel userModel = (UserModel) o;
                return !(login != null ? !login.equals(userModel.login) : userModel.login != null);
        }

        @Override
        public int hashCode() {
                return login != null ? login.hashCode() : 0;
        }

        public int getIdNumber() {
                return idNumber;
        }

        public void setIdNumber(int idNumber) {
                this.idNumber = idNumber;
        }
}
