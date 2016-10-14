package com.configuration;

import com.dao.UserModelDAO;
import com.models.UserModel;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;


public class IdNumberGenerator {



    public static int getRandomNumberInRange(UserModelDAO userModelDAO, int min, int max) {

        int idNumber;
        if (min >= max) {
            throw new IllegalArgumentException("max must be greater than min");
        }


        Random r = new Random();
        idNumber =  r.nextInt((max - min) + 1) + min;

        List<Integer> idNumbers = new ArrayList<>();

        for(UserModel user : userModelDAO.getAll()){
            idNumbers.add(user.getIdNumber());
        }

        while(idNumbers.contains(idNumber)){
            r = new Random();
            idNumber =  r.nextInt((max - min) + 1) + min;
        }
        return idNumber;
    }
}
