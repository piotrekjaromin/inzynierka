package com.controllers;


import com.google.gson.GsonBuilder;
import com.models.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;


@Controller
public class ThreatController extends BaseController {

    @RequestMapping(value = "/user/addThreat", method = RequestMethod.GET)
    public String goAddThreat(ModelMap model) {
        model.addAttribute("threatType", threatTypeDAO.getFirst());
        return "addThreat";
    }


    @RequestMapping(value = {"/user/addThreat"}, method = RequestMethod.POST)
    public ModelAndView addThreat(HttpServletRequest request, @RequestParam("file") MultipartFile files[], ModelMap model) throws UnsupportedEncodingException, ParseException {

        request.setCharacterEncoding("UTF-8");

        String[] dayOfWeeks = request.getParameterValues("dayOfWeek");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String typeOfThreat = convertString(request.getParameter("typeOfThreat"));
        String typeOfThreat2 = convertString(request.getParameter("typeOfThreat2"));
        String description= convertString(request.getParameter("description"));
        String coordinates = convertString(request.getParameter("coordinates"));
        String location = convertString(request.getParameter("address"));
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");

        Coordinates coordinates1 = new Coordinates();
        coordinates1.setHorizontal(coordinates.split(";")[0]);
        coordinates1.setVertical(coordinates.split(";")[1]);
        coordinates1.setCity(location.split(",")[1]);
        coordinates1.setStreet(location.split(",")[0]);
        coordinatesDAO.save(coordinates1);
        ThreatType type = threatTypeDAO.getByUuid(typeOfThreat);
        Threat threat = new Threat();
        threat.setCoordinates(coordinates1);
        threat.setType(type);
        threat.setLogin(userDetails.getUsername());
        threat.setDescription(description);
        threat.setDate(new Date());
        threat.setDateType(typeOfThreat2);

        if(typeOfThreat2.equals("jednorazowe")){
            threat.setPeriodicDays(new ArrayList<String>(Arrays.asList(dayOfWeeks)));
            threat.setStartDate(format.parse(startDate));
            threat.setEndDate(format.parse(endDate));
        } else if(typeOfThreat2.equals("okresowe")) {

            threat.setStartDate(format.parse(startDate));
            threat.setEndDate(format.parse(endDate));
        }

        threatDAO.save(threat);
        UserModel user = userModelDAO.getByLogin(userDetails.getUsername());
        user.addThread(threat);
        userModelDAO.update(user);
        addFile(files, threat.getUuid());

        model.addAttribute("threat", threatDAO.get(threat.getUuid()));
        return new ModelAndView("redirect:/getThreatDetails?uuid=" + threat.getUuid() + "");

    }


    @RequestMapping(value = "/user/addPhotos", method = RequestMethod.POST, headers = "Accept=application/json")
    public ModelAndView addPhotos(HttpServletRequest request, ModelMap model, @RequestParam("file") MultipartFile file[]) throws UnsupportedEncodingException {
        String threatUuid = convertString(request.getParameter("threatUuid"));
        addFile(file, threatUuid);
        return new ModelAndView("redirect:/getThreatDetails?uuid=" + threatUuid + "");
    }

        @RequestMapping(value = "/user/editThreat", method = RequestMethod.POST, headers = "Accept=application/json")
    public String editThreat(HttpServletRequest request, ModelMap model, @RequestParam("file") MultipartFile file[]) throws UnsupportedEncodingException {
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
            ThreatType threatType = threatTypeDAO.getByUuid(typeOfThreat);
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



    public String addFile(MultipartFile filesArray[], String threatUuid) {

        List<MultipartFile> files = new ArrayList<MultipartFile>(Arrays.asList(filesArray));
        if (!files.isEmpty()) {
            try {


                Threat threat = threatDAO.get(threatUuid);

                List<String> photosName = new ArrayList<String>(threat.getPathesToPhoto());
                for(MultipartFile file: files) {

                    byte[] bytes = file.getBytes();

                    // Creating the directory to store file
                    String rootPath = System.getProperty("catalina.home");

                    int photoCounter = 0;

                    // Create the file on server
                    File serverFile = new File("/home/piotrek/uploadedFiles/" + threatUuid + "/" + file.getOriginalFilename());
                    serverFile.getParentFile().mkdir();
                    serverFile.createNewFile();

                    file.transferTo(serverFile);
                    photosName.add(threatUuid + "/" + file.getOriginalFilename());

//                    BufferedOutputStream stream = new BufferedOutputStream(
//                            new FileOutputStream(serverFile));
//                    stream.write(bytes);
//                    stream.close();

                }

                threat.setPathesToPhoto(photosName);
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

    @RequestMapping(value = {"/user/replyToComment"}, method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String reply(HttpServletRequest request) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String commentMessage = convertString(request.getParameter("comment"));
        String voteUuid = convertString(request.getParameter("uuid"));

        Comment comment = new Comment();
        comment.setComment(commentMessage);
        comment.setDate(new Date());
        comment.setLogin(userDetails.getUsername());
        commentDAO.save(comment);

        Vote vote = voteDAO.get(voteUuid);
        vote.addComment(comment);
        voteDAO.update(vote);

        return "Success";
    }

    @RequestMapping(value = {"/user/addVoteForThreat"}, method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
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

        return "Success";
    }

    @RequestMapping(value = "/admin/addThreatType", method = RequestMethod.GET)
    public String goAddThreatType(ModelMap model) {
        model.addAttribute("threatType", threatTypeDAO.getFirst());
        return "addTypeOfThreat";
    }

    @RequestMapping(value = {"/admin/addThreatType"}, method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String addThreatType(HttpServletRequest request) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String threatType= convertString(request.getParameter("threatType"));
        String threatParentUuid = request.getParameter("parentUuid");

        if(threatType.equals("")) {
            return "Failure: no threat type name";
        }

        if(!userModelDAO.getByLogin(userDetails.getUsername()).getUserRole().getType().equals("ADMIN"))
            return "Failure: no permission";


            ThreatType typeParent = threatTypeDAO.getByUuid(threatParentUuid);
            ThreatType newType = new ThreatType();
            newType.setParent(typeParent);
            newType.setName(threatType);
            newType.setChilds(null);
            threatTypeDAO.save(newType);
            typeParent.addChild(newType);
            threatTypeDAO.update(typeParent);

        return "Success";
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
//            if (threat.getPathToPhoto() != null) {
//                try {
//                    final HttpHeaders headers = new HttpHeaders();
//                    headers.setContentType(MediaType.IMAGE_PNG);
//                    in = new BufferedInputStream(new FileInputStream(threat.getPathToPhoto()));
//                    return new String(Base64.encodeBase64(IOUtils.toByteArray(in)));
//                } catch (FileNotFoundException e) {
//                    e.printStackTrace();
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }

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

    @RequestMapping(value = "loadVotes", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String loadVotes(HttpServletRequest request) {
        String threatUuid = convertString(request.getParameter("uuid"));

        GsonBuilder builder = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss");
        return builder.create().toJson(threatDAO.get(threatUuid).getVotes());
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

//        if(threat1.getPathToPhoto()!=null) {
//            File file = new File(threat1.getPathToPhoto());
//            file.delete();
//        }

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
        model.addAttribute("threatType", threatTypeDAO.getFirst());
        return "editThreat";
    }

    @RequestMapping(value = "/getThreatDetails", method = RequestMethod.GET)
    public String getThreatDetails(ModelMap model, HttpServletRequest request) {
        String threatUuid = convertString(request.getParameter("uuid"));
        Threat threat = threatDAO.get(threatUuid);
        List<String> videosName = threat.getPathesToPhoto().stream().filter(path -> path.endsWith(".mp4")).collect(Collectors.toList());
        List<String> photosName = threat.getPathesToPhoto().stream().filter(path -> !path.endsWith(".mp4")).collect(Collectors.toList());
        model.addAttribute("threat", threat);
        model.addAttribute("photos", photosName);
        model.addAttribute("videos", videosName);
        return "threatDetails";
    }

    public String convertString(String str) {
        return str.replaceAll("Ä\u0085", "ą").replaceAll("Ä\u0084", "Ą").replaceAll("Å\u009B", "ś").replaceAll("Å\u009A", "Ś")
                .replaceAll("Å\u0082", "ł").replaceAll("Å\u0081", "Ł").replaceAll("Å¼", "ż").replaceAll("'Å»", "Ż").replaceAll("'Åº", "ź")
                .replaceAll("'Å¹", "Ź").replaceAll("Ä\u0087", "ć").replaceAll("Ä\u0086", "Ć").replaceAll("Å\u0084", "ń").replaceAll("Å\u0083", "Ń")
                .replaceAll("Ä\u0099", "ę").replaceAll("Ä\u0098", "Ę").replaceAll("Ã³", "ó").replaceAll("Ã\u0093", "Ó");
    }

}