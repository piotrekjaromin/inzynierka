package com.controllers;

import com.models.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@RestController
public class RestfulThreatController extends BaseController {


    /**
     * Dodawanie zagrozenia. Wszyscy zalogowani
     *
     * @return status
     */

    @RequestMapping(value = "/rest/addThreat/", method = RequestMethod.POST)
    public ResponseEntity<String> addThreat(HttpServletRequest request) {

        String[] dayOfWeeks = request.getParameterValues("dayOfWeek");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String typeOfThreat = request.getParameter("typeOfThreat");
        String typeOfThreat2 = request.getParameter("typeOfThreat2");
        String description = request.getParameter("description");
        String coordinates = request.getParameter("coordinates");
        String location = request.getParameter("address");
        String idNumber = request.getParameter("uuid");
        String token = request.getParameter("token");
        Session session = sessionManager.getAndUpdateSession(token);
        if (session == null)
            return new ResponseEntity<String>("{\"status\" : \"Failure bad token\"}", HttpStatus.UNAUTHORIZED);


        for(ThreatType threatType : threatTypeDAO.getAll()) {
            if(threatType.getName().equals(typeOfThreat)) {
                typeOfThreat = threatType.getUuid();
                break;
            }
        }

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
        UserModel user = userModelDAO.get(idNumber);
        threat.setLogin(user.getLogin());
        threat.setDescription(description);
        threat.setDate(new Date());
        threat.setDateType(typeOfThreat2);
        try {

            if (typeOfThreat2.equals("okresowe")) {
                threat.setPeriodicDays(new ArrayList<String>(Arrays.asList(dayOfWeeks)));
                threat.setStartDate(format.parse(startDate));
                threat.setEndDate(format.parse(endDate));
            } else if (typeOfThreat2.equals("jednorazowe")) {
                threat.setStartDate(format.parse(startDate));
                threat.setEndDate(format.parse(endDate));

            }


        } catch (ParseException e) {
            e.printStackTrace();
        }
        threatDAO.save(threat);

        user.addThread(threat);
        userModelDAO.update(user);


        return new ResponseEntity<String>("{\"status\" : \"Success\", \"uuid\" : \"" + threat.getUuid()+ "\",\"what\" : \"threat added\"}", HttpStatus.OK);
    }


    @RequestMapping(value = "/rest/editThreat/", method= RequestMethod.POST)
    public ResponseEntity<String> editThreat(HttpServletRequest request){
        String threatUuid = request.getParameter("uuidThreat");
        String typeOfThreat = request.getParameter("typeOfThreat");
        String coordinates = request.getParameter("coordinates");
        String location = request.getParameter("address");
        String description = request.getParameter("description");

        String token = request.getParameter("token");
        Session session = sessionManager.getAndUpdateSession(token);
        Threat threat = threatDAO.get(threatUuid);

        if (session == null)
            return new ResponseEntity<String>("{\"status\" : \"Failure bad token\"}", HttpStatus.UNAUTHORIZED);

        if(threat!=null) {


            if(coordinates != null && !coordinates.equals("")) {
                Coordinates coordinates1 = new Coordinates();
                coordinates1.setHorizontal(coordinates.split(";")[0]);
                coordinates1.setVertical(coordinates.split(";")[1]);
                coordinates1.setCity(location.split(",")[1]);
                coordinates1.setStreet(location.split(",")[0]);
                coordinatesDAO.save(coordinates1);
                threat.setCoordinates(coordinates1);
            }
            if(typeOfThreat != null && !typeOfThreat.equals("")){
                for(ThreatType threatType : threatTypeDAO.getAll()) {
                    if(threatType.getName().equals(typeOfThreat)) {
                        typeOfThreat = threatType.getUuid();
                        break;
                    }
                }

                ThreatType threatType = threatTypeDAO.getByUuid(typeOfThreat);

                threat.setType(threatType);
            }
            if(description != null && !description.equals(""))
                threat.setDescription(description);

            threatDAO.update(threat);

            return new ResponseEntity<String>("{\"status\" : \"Success\"}", HttpStatus.OK);
        }
        return new ResponseEntity<String>("{\"status\" : \"Failure bad threat uuid\"}", HttpStatus.UNAUTHORIZED);
    }

    /**
     * Akceptacja zagrozenia. Tylko admin
     *
     * @return status
     */

    @RequestMapping(value = "/rest/approveThreat/", method = RequestMethod.POST)
    public ResponseEntity<String> approveThreat(HttpServletRequest request) {
        String threatUuid = request.getParameter("threadUuid");
        String token = request.getParameter("token");
        Session session = sessionManager.getAndUpdateSession(token);

        if (session == null)
            return new ResponseEntity<String>("{\"status\" : \"Failure bad token\"}", HttpStatus.UNAUTHORIZED);

        if (!userModelDAO.getByLogin(session.getLogin()).getUserRole().getType().equals("ADMIN"))
            return new ResponseEntity<String>("{\"status\" : \"Failure no permission\"}", HttpStatus.FORBIDDEN);

        Threat threat = threatDAO.get(threatUuid);
        threat.setIsApproved(true);
        threatDAO.update(threat);

        return new ResponseEntity<String>("{\"status\" : \"Success\",\"what\" : \"threat approved\"}", HttpStatus.OK);
    }


    /**
     * Dodawanie glosu (glosowanie). tylko zalogowani uzytkownicy
     *
     * @return status
     */

    @RequestMapping(value = "/rest/addVote/", method = RequestMethod.POST)
    public ResponseEntity<String> addVote(HttpServletRequest request) {
        short numberOfStars = Short.parseShort(request.getParameter("stars"));
        String threadUuid = request.getParameter("uuid");
        String login = request.getParameter("login");
        String comment = request.getParameter("comment");
        String token = request.getParameter("token");
        Session session = sessionManager.getAndUpdateSession(token);
        Threat threat = threatDAO.get(threadUuid);
        Date date = new Date();

        if (session == null)
            return new ResponseEntity<String>("{\"status\" : \"Failure bad token\"}", HttpStatus.UNAUTHORIZED);

        if (threat == null)
            return new ResponseEntity<String>("{\"status\" : \"Failure bad threat uuid\"}", HttpStatus.UNAUTHORIZED);

        Vote vote = new Vote();
        vote.setLogin(session.getLogin());
        vote.setNumberOfStars(numberOfStars);
        vote.setLogin(login);
        vote.setVoteComment(comment);
        vote.setDate(date);
        voteDAO.save(vote);

        threat.addVote(vote);
        threatDAO.update(threat);

        return new ResponseEntity<String>("{\"status\" : \"Success\" ,\"what\" : \"vote added\"}", HttpStatus.OK);
    }

    /**
     * pobieranie głosu.
     *
     * @return status
     */

    @RequestMapping(value = "/rest/getVote/", method = RequestMethod.GET)
    public ResponseEntity<Vote> getVote(HttpServletRequest request) {

        String voteUuid = request.getParameter("uuid");
        Vote vote = voteDAO.get(voteUuid);


        if (vote == null)
            return new ResponseEntity<Vote>(HttpStatus.PRECONDITION_FAILED);

        return new ResponseEntity<Vote>(vote, HttpStatus.OK);
    }


    /**
     * Pobieranie wszystkich zagrozen. Dostep wszyscy
     *
     * @return lista zagrozen
     */

    @RequestMapping(value = "/rest/getThreats/", method = RequestMethod.GET)
    public ResponseEntity<List<Threat>> listAllThreat() {
        List<Threat> threats = threatDAO.getAll();
        if (threats.isEmpty()) {
            return new ResponseEntity<List<Threat>>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Threat>>(threats, HttpStatus.OK);
    }

    @RequestMapping(value = "/rest/getThreatTypes/", method = RequestMethod.GET)
    public ResponseEntity<List<ThreatType>> listAllThreatType() {
        List<ThreatType> threatTypes = threatTypeDAO.getAll();
        if (threatTypes.isEmpty()) {
            return new ResponseEntity<List<ThreatType>>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<ThreatType>>(threatTypes, HttpStatus.OK);
    }


    /**
     * Pobieranie wszystkich zagrozen użytkownika.
     *
     * @return lista zagrozen
     */

    @RequestMapping(value = "/rest/getUserThreats/", method = RequestMethod.GET)
    public ResponseEntity<List<Threat>> listAllUserThreat(HttpServletRequest request) {
        String userUuid = request.getParameter("uuid");
        UserModel user = userModelDAO.getByLogin(userUuid);

        List<Threat> threats = user.getThreats();
        if (threats.isEmpty()) {
            return new ResponseEntity<List<Threat>>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Threat>>(threats, HttpStatus.OK);
    }

    /**
     * Pobieranie zatwierdzonych zagrozen. Dostep wszyscy
     *
     * @return lista zagrozen
     */

    @RequestMapping(value = "/rest/getApprovedThreats/", method = RequestMethod.GET)
    public ResponseEntity<List<Threat>> listApprovedThreat() {
        List<Threat> threats = threatDAO.getAllApproved();
        if (threats.isEmpty()) {
            return new ResponseEntity<List<Threat>>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Threat>>(threats, HttpStatus.OK);
    }

    /**
     * Pobieranie niezatwierdzonych zagrozen. Dostep wszyscy
     *
     * @return lista zagrozen
     */

    @RequestMapping(value = "/rest/getNotApprovedThreats/", method = RequestMethod.GET)
    public ResponseEntity<List<Threat>> listNotApprovedThreat() {
        List<Threat> threats = threatDAO.getAllNotApproved();
        if (threats.isEmpty()) {
            return new ResponseEntity<List<Threat>>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Threat>>(threats, HttpStatus.OK);
    }

    /**
     * Zwraca zagrozenie o podanych uuid. Dostep wszyscy.
     *
     * @param request -"uuid"
     * @return zagrozenie o podanym id
     */

    @RequestMapping(value = "/rest/getThreat/", method = RequestMethod.GET)
    public ResponseEntity<Threat> getThreat(HttpServletRequest request) {
        String uuid = request.getParameter("uuid");

        Threat threat = threatDAO.get(uuid);
        if (threat == null) {
            System.out.println("threat with uuid " + uuid + " not found");
            return new ResponseEntity<Threat>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<Threat>(threat, HttpStatus.OK);
    }


    /**
     * Usuwa Zagrozenie o podanym uuid. Tylko admin
     *
     * @param request -"uuid", "token"
     * @return status
     */

    @RequestMapping(value = "/rest/deleteThreat/", method = RequestMethod.POST)
    public ResponseEntity<String> deleteThreat(HttpServletRequest request) {

        String token = request.getParameter("token");
        String uuid = request.getParameter("uuid");
        String  login = request.getParameter("login");

        Session session = sessionManager.getAndUpdateSession(token);

        if (session == null)
            return new ResponseEntity<String>("{\"status\" : \"Failure bad token\"}", HttpStatus.UNAUTHORIZED);

        Threat threat = threatDAO.get(uuid);

        if(threat==null) {
            return new ResponseEntity<String>("{\"status\" : \"Failure threat uuid\"}", HttpStatus.UNAUTHORIZED);
        }


        Threat threat1 = threatDAO.get(uuid);

        UserModel user = userModelDAO.getByLogin(login);

            if(user.getThreats().contains(threat)){
                user.deleteThreat(threat);
                userModelDAO.update(user);
            }


        threat.deleteAllConection();
        threatDAO.update(threat);

        try{

            if(threat1.getType()!=null){
                //threatTypeDAO.delete(threat1.getType());
                threat1.setType(null);
                threatDAO.update(threat1);
            }
            if (threat1.getCoordinates() != null) {
                //coordinatesDAO.delete(threat1.getCoordinates());
                threat1.setCoordinates(null);
                threatDAO.update(threat1);
            }
        }catch (Error | Exception e) {

            deleteThreat(request);
        }

        for(Vote vote : threat1.getVotes())
            voteDAO.delete(vote);

        threatDAO.delete(threat);

        return new ResponseEntity<String>("{\"status\" : \"Success\" ,\"what\" : \"threat deleted\"}", HttpStatus.OK);
    }

    @RequestMapping(value = "/rest/getImage/", method = RequestMethod.GET, produces = MediaType.IMAGE_JPEG_VALUE)
    public ResponseEntity<byte[]> testphoto(HttpServletRequest request) throws IOException {
        String threatUuid = request.getParameter("uuid");
        Threat threat = threatDAO.get(threatUuid);
        if (threat != null) {
            InputStream in;
//            if (threat.getPathToPhoto() != null) {
//                in = new BufferedInputStream(new FileInputStream(threat.getPathToPhoto()));
//                final HttpHeaders headers = new HttpHeaders();
//                headers.setContentType(MediaType.IMAGE_PNG);
//
//                return new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
//            }
            return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
    }

    @RequestMapping(value = {"/rest/addImage/"}, method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> addImage(HttpServletRequest request, @RequestParam("file") MultipartFile file) {
        String threatUuid = request.getParameter("uuid");

        if (!file.isEmpty()) {
            try {

                Threat threat = threatDAO.get(threatUuid);

                if (threat == null) {
                    return new ResponseEntity<String>("{\"status\" : \"Failure threat not found\"}", HttpStatus.NOT_FOUND);
                }

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

//                threat.setPathToPhoto(dir.getAbsolutePath()
//                        + File.separator + threatUuid);
                threatDAO.update(threat);

                return new ResponseEntity<String>("{\"status\" : \"Success\" ,\"what\" : \"image" +
                        " added\"}", HttpStatus.OK);
            } catch (Exception e) {
                return new ResponseEntity<String>("{\"status\" : \"Failure\"}", HttpStatus.NOT_FOUND);
            }
        } else {
            return new ResponseEntity<String>("{\"status\" : \"Failure file is empty\"}", HttpStatus.NOT_FOUND);
        }
    }


}
