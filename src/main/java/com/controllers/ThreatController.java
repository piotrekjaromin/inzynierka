package com.controllers;


import com.models.*;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;


@Controller
public class ThreatController extends BaseController {

    @RequestMapping(value = "/user/addThreat", method = RequestMethod.GET)
    public String goAddThreat(ModelMap model) {
        model.addAttribute("threatTypes", threatTypeDAO.getAll());
        return "addThreat";
    }


    @RequestMapping(value = {"/user/addThreat"}, method = RequestMethod.POST)
    public String addThreat(HttpServletRequest request, @RequestParam("file") MultipartFile file, ModelMap model) throws UnsupportedEncodingException {

        request.setCharacterEncoding("UTF-8");

        String typeOfThreat = convertString(request.getParameter("typeOfThreat"));
        String description= convertString(request.getParameter("description"));
        String coordinates = convertString(request.getParameter("coordinates"));
        String location = convertString(request.getParameter("address"));
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if(coordinates.split(";").length!=2)
            return "Error: bad coordinates";

        if(location.split(",").length!=2)
            return "Error: bad location";

        Coordinates coordinates1 = new Coordinates();
        coordinates1.setHorizontal(coordinates.split(";")[0]);
        coordinates1.setVertical(coordinates.split(";")[1]);
        coordinates1.setCity(location.split(",")[1]);
        coordinates1.setStreet(location.split(",")[0]);
        coordinatesDAO.save(coordinates1);
        ThreatType threatType = new ThreatType();
        List<ThreatType> threatTypes = threatTypeDAO.getAll();
        for(ThreatType type : threatTypes) {
            if(type.getThreatType() != null){
                if(type.getThreatType().equals(typeOfThreat)){
                    threatType = type;
                    break;
                }
            }

        }
        if(threatType.getThreatType() == null){
            threatType.setThreatType(typeOfThreat);
            threatTypeDAO.save(threatType);
        }
        Threat threat = new Threat();
        threat.setCoordinates(coordinates1);
        threat.setType(threatType);
        threat.setLogin(userDetails.getUsername());
        threat.setDescription(description);
        threat.setDate(new Date());
        threatDAO.save(threat);
        UserModel user = userModelDAO.getByLogin(userDetails.getUsername());
        user.addThread(threat);
        userModelDAO.update(user);
        addFile(file, threat.getUuid());

        model.addAttribute("threat", threatDAO.get(threat.getUuid()));
        return "threatDetails";

    }

    @RequestMapping(value = "/user/editThreat", method = RequestMethod.POST, headers = "Accept=application/json")
    public String editThreat(HttpServletRequest request, ModelMap model, @RequestParam("file") MultipartFile file) throws UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        String threatUuid = convertString(request.getParameter("uuidThreat"));
        String typeOfThreat = convertString(request.getParameter("typeOfThreat"));
        String coordinates = convertString(request.getParameter("coordinates"));
        String location = convertString(request.getParameter("address"));
        String description = convertString(request.getParameter("description"));

        Threat threat = threatDAO.get(threatUuid);

        if(coordinates.split(";").length!=2)
            return "Error: bad coordinates";

        if(location.split(",").length!=2)
            return "Error: bad location";


        if(threat!=null) {
            Coordinates coordinates1 = new Coordinates();
            coordinates1.setHorizontal(coordinates.split(";")[0]);
            coordinates1.setVertical(coordinates.split(";")[1]);
            coordinates1.setCity(location.split(",")[1]);
            coordinates1.setStreet(location.split(",")[0]);
            coordinatesDAO.save(coordinates1);
            ThreatType threatType = new ThreatType();
            List<ThreatType> threatTypes = threatTypeDAO.getAll();
            for(ThreatType type : threatTypes) {
                if(type.getThreatType() != null){
                    if(type.getThreatType().equals(typeOfThreat)){
                        threatType = type;
                        break;
                    }
                }

            }
            if(threatType.getThreatType() == null){
                threatType.setThreatType(typeOfThreat);
                threatTypeDAO.save(threatType);
            }
            threat.setCoordinates(coordinates1);
            threat.setType(threatType);
            threat.setDescription(description);
            threatDAO.update(threat);

            addFile(file, threat.getUuid());

            model.addAttribute("threat", threatDAO.get(threat.getUuid()));
            return "threatDetails";
        }
        return "Failure: bad uuid";
    }


    @RequestMapping(value = "/user/addImage", method = RequestMethod.GET)
    public String goAddImage(ModelMap model) {
        return "addImage";
    }

//    @RequestMapping(value = {"/user/addImage"}, method = RequestMethod.POST)
//    @ResponseBody
//    public String addImage(HttpServletRequest request , @RequestParam("file") MultipartFile file) {
//        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//        String threatUuid = request.getParameter("uuid");
//
//
//        if (!file.isEmpty()) {
//            try {
//
//                Threat threat = threatDAO.get(threatUuid);
//
//
//                byte[] bytes = file.getBytes();
//
//                // Creating the directory to store file
//                String rootPath = System.getProperty("catalina.home");
//                File dir = new File("tmpFiles");
//                if (!dir.exists())
//                    dir.mkdirs();
//
//                // Create the file on server
//                File serverFile = new File(dir.getAbsolutePath()
//                        + File.separator + threatUuid);
//                BufferedOutputStream stream = new BufferedOutputStream(
//                        new FileOutputStream(serverFile));
//                stream.write(bytes);
//                stream.close();
//                threat.setPathToPhoto(dir.getAbsolutePath()
//                        + File.separator + threatUuid);
//                threatDAO.update(threat);
//
//                return "You successfully uploaded file";
//            }
//            catch (Exception e) {
//                return "Error";
//            }
//        }
//        else {
//            return "file was empty";
//        }
//    }

    public String addFile(MultipartFile file, String threatUuid) {
        if (!file.isEmpty()) {
            try {

                Threat threat = threatDAO.get(threatUuid);


                byte[] bytes = file.getBytes();

                // Creating the directory to store file
                String rootPath = System.getProperty("catalina.home");
                File dir = new File("tmpFiles");
                if (!dir.exists())
                    dir.mkdirs();

                // Create the file on server
                File serverFile = new File(dir.getAbsolutePath()
                        + File.separator + threatUuid);
                BufferedOutputStream stream = new BufferedOutputStream(
                        new FileOutputStream(serverFile));
                stream.write(bytes);
                stream.close();
                threat.setPathToPhoto(dir.getAbsolutePath()
                        + File.separator + threatUuid);
                threatDAO.update(threat);

                return "You successfully uploaded file";
            }
            catch (Exception e) {
                return "Error";
            }
        }
        else {
            return "file was empty";
        }
    }

    @RequestMapping(value = "/showImage", method = RequestMethod.GET)
    public String goShowImage(ModelMap model) {
        return "showImage";
    }

    @RequestMapping(value = "/user/addVoteForThreat", method = RequestMethod.GET)
    public String goAddVote(ModelMap model, HttpServletRequest request) {
        if(request.getParameter("uuid")!=null)
            request.setAttribute("threatUuid", convertString(request.getParameter("uuid")));
        return "addVote";
    }

    @RequestMapping(value = {"/user/addVoteForThreat"}, method = RequestMethod.POST)
    public String addVote(HttpServletRequest request) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        short numberOfStars = Short.parseShort(convertString(request.getParameter("stars")));
        String comment= convertString(request.getParameter("comment"));
        String threadUuid = convertString(request.getParameter("uuid"));

        Vote vote = new Vote();
        vote.setLogin(userDetails.getUsername());
        vote.setNumberOfStars(numberOfStars);
        vote.setDate(new Date());
        vote.setVoteComment(comment);
        voteDAO.save(vote);

        Threat threat = threatDAO.get(threadUuid);
        threat.addVote(vote);
        threatDAO.update(threat);

        return "index";
    }

    @RequestMapping(value = "/admin/addThreatType", method = RequestMethod.GET)
    public String goAddThreatType(ModelMap model) {
        return "addTypeOfThreat";
    }

    @RequestMapping(value = {"/admin/addThreatType"}, method = RequestMethod.POST)
    public String addThreatType(HttpServletRequest request) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String threatType= convertString(request.getParameter("threatType"));

        if(threatType.equals("")) {
            return "Failure: no threat type name";
        }

        if(!userModelDAO.getByLogin(userDetails.getUsername()).getUserRole().getType().equals("ADMIN"))
            return "Failure: no permission";

        ThreatType threatType1 = new ThreatType();
        threatType1.setThreatType(threatType);
        threatTypeDAO.save(threatType1);

        return "index";
    }

    @RequestMapping(value = "/showAllThreats", method = RequestMethod.GET)
    public String showAllThreat(ModelMap model) {
        model.addAttribute("threats", threatDAO.getAll());
        return "showThreats";
    }

    @RequestMapping(value = "/showApprovedThreats", method = RequestMethod.GET)
    public String showApprovedThreat(ModelMap model) {
        model.addAttribute("threats", threatDAO.getAllApproved());
        return "showThreats";
    }

    @RequestMapping(value = "/showNotApprovedThreats", method = RequestMethod.GET)
    public String showNotApprovedThreat(ModelMap model) {
        model.addAttribute("threats", threatDAO.getAllNotApproved());
        return "showThreats";
    }

    @RequestMapping(value = "/showLogs", method = RequestMethod.GET)
    public String showLogs(ModelMap model) {
        try {
            model.addAttribute("logs", String.join("<br/>",Files.readAllLines(Paths.get("/home/piotrek/Applications/wildfly-10.0.0.Final/standalone/log/server.log"))));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "showLogs";
    }

    @RequestMapping(value = "/admin/showUsers", method = RequestMethod.GET)
    public String showUsers(ModelMap model) {
        model.addAttribute("users", userModelDAO.getAll());
        return "showUsers";
    }

    @RequestMapping(value = "/showImage", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String showImage(HttpServletRequest request) {
        String threatUuid = convertString(request.getParameter("uuid"));
        Threat threat = threatDAO.get(threatUuid);
        if(threat!=null) {
            InputStream in;
            if (threat.getPathToPhoto() != null) {
                try {
                    final HttpHeaders headers = new HttpHeaders();
                    headers.setContentType(MediaType.IMAGE_PNG);
                    in = new BufferedInputStream(new FileInputStream(threat.getPathToPhoto()));
                    return new String(Base64.encodeBase64(IOUtils.toByteArray(in)));
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return "Failure";
    }

    @RequestMapping(value = "/admin/approve", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String approve(HttpServletRequest request) {
        String threatUuid = convertString(request.getParameter("uuid"));
        Threat threat = threatDAO.get(threatUuid);
        if(threat!=null) {
            if(threat.getIsApproved()) {
                return "Already approved";
            } else {
                threat.setIsApproved(true);
                threatDAO.update(threat);
                return "Success";
            }

        }
        return "bad uuid";
    }

    @RequestMapping(value = "/admin/disapprove", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String disapprove(HttpServletRequest request) {
        String threatUuid = convertString(request.getParameter("uuid"));
        Threat threat = threatDAO.get(threatUuid);
        if(threat!=null) {
            if(threat.getIsApproved()) {
                threat.setIsApproved(false);
                threatDAO.update(threat);
                return "Success";
            } else {
                return "Already disapproved";
            }

        }
        return "bad uuid";
    }

    @RequestMapping(value = "/user/deleteThreat", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String delete(HttpServletRequest request) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String threatUuid = convertString(request.getParameter("uuid"));
        Threat threat = threatDAO.get(threatUuid);

        if(threat==null) {
            return "Failure: bad uuid";
        }

        UserModel userTmp = userModelDAO.getByLogin(userDetails.getUsername());
        if(!userTmp.getUserRole().getType().equals("ADMIN") && (userTmp.getUserRole().getType().equals("USER") && !threat.getLogin().equals(userTmp.getLogin()))) {
            return "Error, no permission";
        }
        Threat threat1 = threatDAO.get(threatUuid);

        for(UserModel user : userModelDAO.getAll()){
            if(user.getThreats().contains(threat)){
                user.deleteThreat(threat);
                userModelDAO.update(user);
                break;
            }

        }
        threat.deleteAllConection();
        threatDAO.update(threat);

        if(threat1.getPathToPhoto()!=null) {
            File file = new File(threat1.getPathToPhoto());
            file.delete();
        }

        if(threat1.getType()!=null)
            threatTypeDAO.delete(threat1.getType());

        if(threat1.getCoordinates()!=null)
            coordinatesDAO.delete(threat1.getCoordinates());

        for(Vote vote : threat1.getVotes())
            voteDAO.delete(vote);

        threatDAO.delete(threat);

        return "success";
    }

    @RequestMapping(value = "/editThreat", method = RequestMethod.GET)
    public String editThreat(ModelMap model, HttpServletRequest request) {
        String threatUuid = convertString(request.getParameter("uuid"));
        model.addAttribute("threat", threatDAO.get(threatUuid));
        model.addAttribute("threatTypes", threatTypeDAO.getAll());
        return "editThreat";
    }

    @RequestMapping(value = "/getThreatDetails", method = RequestMethod.GET)
    public String getThreatDetails(ModelMap model, HttpServletRequest request) {
        String threatUuid = convertString(request.getParameter("uuid"));
        model.addAttribute("threat", threatDAO.get(threatUuid));
        return "threatDetails";
    }

    public String convertString(String str) {
        return str.replaceAll("Ä\u0085", "ą").replaceAll("Ä\u0084", "Ą").replaceAll("Å\u009B", "ś").replaceAll("Å\u009A", "Ś")
                .replaceAll("Å\u0082", "ł").replaceAll("Å\u0081", "Ł").replaceAll("Å¼", "ż").replaceAll("'Å»", "Ż").replaceAll("'Åº", "ź")
                .replaceAll("'Å¹", "Ź").replaceAll("Ä\u0087", "ć").replaceAll("Ä\u0086", "Ć").replaceAll("Å\u0084", "ń").replaceAll("Å\u0083", "Ń")
                .replaceAll("Ä\u0099", "ę").replaceAll("Ä\u0098", "Ę").replaceAll("Ã³", "ó").replaceAll("Ã\u0093", "Ó");
    }

}