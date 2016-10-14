package com.models;

import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.*;


@Component
public class SessionManager {
    private static Map<String, Session> sessionMap = new ConcurrentHashMap<>();
    private static final Logger LOGGER = LoggerFactory.getLogger(SessionManager.class);

    public String createUserSession(String login) {
        Session session = createSession(login);
        sessionMap.put(login, session);
        return session.getToken();
    }

    private Session createSession(String login) {

        return new Session()
                .withLogin(login)
                .withExpirationTime(DateTime.now().plusMinutes(30))
                .withToken(generateUniqueId());
    }

    private String generateUniqueId() {
        return UUID.randomUUID().toString();
    }

    ScheduledExecutorService scheduledExecutorService =
            Executors.newScheduledThreadPool(1);


    private void cleanSession(){

        for(Map.Entry<String, Session> entry : sessionMap.entrySet()){
            String key = entry.getKey();
            Session session = entry.getValue();
            if(DateTime.now().isAfter(session.getExpirationTime())){
                sessionMap.remove(key);
                LOGGER.info("cleanedSession for: {}, still active: {}", key, sessionMap.size());
            }
        }
    }


    @PostConstruct
    private void expiredSessionCleaner(){
        scheduledExecutorService.scheduleWithFixedDelay(()->cleanSession(),1,1,TimeUnit.MINUTES);
        LOGGER.info("Starting expiredSessionCleaner");

    }

    public Session getAndUpdateSession(String token){
        for(Map.Entry<String, Session> entry : sessionMap.entrySet()){
            if(entry.getValue().getToken().equals(token)){
                entry.getValue().setExpirationTime(DateTime.now().plusMinutes(30));
                return entry.getValue();
            }
        }

        return null;
    }

    public Map<String, Session> getSessionMap(){
        return sessionMap;
    }

    public boolean closeSession(String token){
        for(Map.Entry<String, Session> entry : sessionMap.entrySet()){
            if(entry.getValue().getToken().equals(token)){
                sessionMap.remove(entry.getKey());
                return true;
            }
        }

        return false;
    }

}
