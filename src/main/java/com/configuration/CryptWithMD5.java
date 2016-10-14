package com.configuration;

import org.apache.log4j.Logger;
import org.springframework.context.annotation.Primary;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


@Repository
public class CryptWithMD5 implements PasswordEncoder{
    private static MessageDigest md;


    @Override
    public String encode(CharSequence pass) {
        try {
            md = MessageDigest.getInstance("MD5");
            byte[] passBytes = pass.toString().getBytes();
            md.reset();
            byte[] digested = md.digest(passBytes);
            StringBuffer sb = new StringBuffer();
            for(int i=0;i<digested.length;i++){
                sb.append(Integer.toHexString(0xff & digested[i]));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(CryptWithMD5.class.getName()).error("no such argorithm");
        }
        return null;
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        return encode(rawPassword).equals(encodedPassword);
    }
}