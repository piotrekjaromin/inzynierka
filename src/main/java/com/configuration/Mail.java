//package com.configuration;
//
//
//import com.dao.UserModelDAO;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import java.util.List;
//import java.util.Properties;
//import java.util.concurrent.Executors;
//import java.util.concurrent.ScheduledExecutorService;
//import java.util.concurrent.TimeUnit;
//
//import javax.annotation.PostConstruct;
//import javax.mail.Message;
//import javax.mail.MessagingException;
//import javax.mail.PasswordAuthentication;
//import javax.mail.Session;
//import javax.mail.Transport;
//import javax.mail.internet.InternetAddress;
//import javax.mail.internet.MimeMessage;
//
//@Component
//public class Mail {
//
//    private static final String username = "librarywdwp@gmail.com";
//    private static final String password = "qwertyuiop11";
//
//    @Autowired
//    private UserModelDAO userModelDAO;
//
//    ScheduledExecutorService scheduledExecutorService =
//            Executors.newScheduledThreadPool(1);
//
//    @PostConstruct
//    private void expiredSessionCleaner(){
//        scheduledExecutorService.scheduleWithFixedDelay(()->sendMail(),1,1, TimeUnit.DAYS);
//
//    }
//
////    private void sendMail(){
////        userModelDAO.getAll().forEach(user -> {
////            List<Book> books = userModelDAO.getUserExpirationBook(user.getUuid());
////            if(!books.isEmpty()){
////                createMail(user.getMail(), books);
////            }
////        });
////    }
//
//
//    public static boolean createMail(String mail, List<Book> books){
//
//        Properties props = new Properties();
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
//        props.put("mail.smtp.host", "smtp.gmail.com");
//        props.put("mail.smtp.port", "587");
//
//        String messageText = "Dear user\nYou don't return this books: \n";
//        for(Book book : books){
//            messageText += book.getTitle() + " " + book.getAuthors().get(0).getName() + " " + book.getAuthors().get(0).getSurname() + " " + book.getDates().get(book.getDates().size()-1).getPlanningReturnDate();
//        }
//
//        Session session = Session.getInstance(props,
//                new javax.mail.Authenticator() {
//                    protected PasswordAuthentication getPasswordAuthentication() {
//                        return new PasswordAuthentication(username, password);
//                    }
//                });
//
//        try {
//
//            Message message = new MimeMessage(session);
//            message.setFrom(new InternetAddress("librarywdwp@gmail.com"));
//            message.setRecipients(Message.RecipientType.TO,
//                    InternetAddress.parse(mail));
//            message.setSubject("Library");
//            message.setText(messageText);
//
//            Transport.send(message);
//
//        } catch (MessagingException e) {
//            return false;
//        }
//        return true;
//    }
//}