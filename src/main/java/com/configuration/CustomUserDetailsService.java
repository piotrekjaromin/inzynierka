package com.configuration;


import java.util.ArrayList;
import java.util.List;

import com.dao.UserModelDAO;
import com.models.UserModel;
import com.models.UserRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService{

    @Autowired
    private UserModelDAO userModelDAO;

    @Transactional(readOnly=true)
    public UserDetails loadUserByUsername(String login)
            throws UsernameNotFoundException {
        UserModel userModel = userModelDAO.getByLogin(login);
        System.out.println(userModel);
        if(userModel==null){
            System.out.println("UserModel not found");
            throw new UsernameNotFoundException("Username not found");
        }


        return new org.springframework.security.core.userdetails.User(userModel.getLogin(), userModel.getPassword(),
                true, true, true, true, getGrantedAuthorities(userModel));
    }


    private List<GrantedAuthority> getGrantedAuthorities(UserModel userModel){
        List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();

            authorities.add(new SimpleGrantedAuthority("ROLE_"+userModel.getUserRole().getType()));
        System.out.print("authorities :"+authorities);
        return authorities;
    }

}