package com.controllers;

import com.dao.*;
import com.models.SessionManager;
import com.models.ThreatType;
import org.springframework.beans.factory.annotation.Autowired;


public abstract class BaseController {
    @Autowired
    UserModelDAO userModelDAO;

    @Autowired
    CoordinatesDAO coordinatesDAO;

    @Autowired
    ThreatTypeDAO threatTypeDAO;

    @Autowired
    ThreatDAO threatDAO;

    @Autowired
    VoteDAO voteDAO;

    @Autowired
    UserRoleDAO userRoleDAO;

    @Autowired
    SessionManager sessionManager;


}
