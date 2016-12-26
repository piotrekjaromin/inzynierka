package restTest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Rest {

    private static final int THREADS_NUMBER = 500;
    static String urlString = "http://localhost:8080/TrafficThreat/rest/";

    private static final Logger LOGGER = LoggerFactory.getLogger(Rest.class);

    public void start() throws InterruptedException, ExecutionException {


        System.out.println("start time: " + System.currentTimeMillis());

        ExecutorService executorService = Executors.newFixedThreadPool(THREADS_NUMBER);

//        for (int i = 0; i < THREADS_NUMBER; i++) {
//            final int counter = i;
//            //executorService.execute(()->sendRequest(counter));
//
//        }

        List<CompletableFuture<Long>> results = new ArrayList<>();
          for (int i = 0; i < THREADS_NUMBER; i++) {
            final int counter = i;
            //executorService.execute(()->sendRequest(counter));

              results.add(CompletableFuture.supplyAsync(()->sendRequest(counter), executorService) );
        }
        for (CompletableFuture<Long> result: results) {
            result.get();
            //LOGGER.info("Duration time v2: {}", result.get());
        }

        System.out.println("Finish");
    }

    public long sendRequest(int counter) {
        Thread.currentThread().setName("Thread number: " + counter);
        /////////////////////////////////////////////// prepare parameters for register new user
        long startMilis = System.currentTimeMillis();
        String login = "login" + UUID.randomUUID();
        //LOGGER.info("start time: {}, login: {}", System.currentTimeMillis(), login);
        String mail = login + "@mail.com";

        String urlParam = "login=" + login;
        urlParam += "&mail=" + mail;
        urlParam += "&password=password";
        urlParam += "&name=name";
        urlParam += "&surname=surname";
        try {
            //////////////////////////////////////////////// register new user

            String result = "";
            String response = "";

            URL url = null;

            url = new URL(urlString + "registration/?" + urlParam);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(
                    (conn.getInputStream())));

            String output;
            while ((output = br.readLine()) != null) {}

            conn.disconnect();
            long registerTime = System.currentTimeMillis();
            result += (registerTime - startMilis) + ";" ;

            ///////////////////////////////////////////////////////////////////prepare parameters for login

            urlParam = "login=" + login;
            urlParam += "&password=5f4dcc3b5aa765d61d8327deb882cf99";

            /////////////////////////////////////////////////////////////////// login


            url = new URL(urlString + "login" + "/?" + urlParam);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

            while ((output = br.readLine()) != null) {
                response += output;
            }

            conn.disconnect();
            long loginTime = System.currentTimeMillis();
            result += (loginTime - registerTime) + ";";

//        System.out.println("login: " + result);
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(response);
            String userID = (String) ((JSONObject) obj).get("userID");
            String token = (String) ((JSONObject) obj).get("token");

            response = "";
            /////////////////////////////////////////////////////////////////// prepare data for add threat

            urlParam = "typeOfThreat=Dziury%20na%20drodze";
            urlParam += "&typeOfThreat2=stałe";
            urlParam += "&description=Dziury%20na%20drodze";
            urlParam += "&coordinates=50.0667059;19.920890900000018";
            urlParam += "&address=Czarnowiejska%2030,%20Krakow";
            urlParam += "&uuid=" + userID;
            urlParam += "&token=" + token;

            ////////////////////////////////////////////////////////////////// add Threat

            url = new URL(urlString + "addThreat/?" + urlParam);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

            //      System.out.println("Output from Server .... \n");
            while ((output = br.readLine()) != null) {
                response += output;
            }

            conn.disconnect();

            long addThreatTime = System.currentTimeMillis();
            result += (addThreatTime - loginTime) + ";";

            obj = parser.parse(response);
            String threatUuid = (String) ((JSONObject) obj).get("uuid");

            response = "";
            //System.out.println("add Threat: " + result);

            /////////////////////////////////////////////////////////// Prepare data for edit threat


            urlParam = "uuidThreat=" + threatUuid;
            urlParam += "&description=edited%20description";
            urlParam += "&token=" + token;

            /////////////////////////////////////////////////////////// Edit threat

            url = new URL(urlString + "editThreat/?" + urlParam);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

            //System.out.println("Output from Server .... \n");
            while ((output = br.readLine()) != null) {
                response += output;
            }

            conn.disconnect();


            long editThreatTime = System.currentTimeMillis();
            result += (editThreatTime - addThreatTime) + ";";

            //System.out.println("edit Threat: " + result);

            /////////////////////////////////////////////////////////// Prepare data for delete threat

            urlParam = "uuid=" + threatUuid;
            urlParam += "&token=" + token;
            urlParam += "&login=" + login;

            /////////////////////////////////////////////////////////// delete threat


            url = new URL(urlString + "deleteThreat/?" + urlParam);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

            //System.out.println("Output from Server .... \n");
            while ((output = br.readLine()) != null) {}

            conn.disconnect();


            long deleteThreatTime = System.currentTimeMillis();
            result += (deleteThreatTime - editThreatTime ) + "";
            System.out.println(result);

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (ProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }


        long executionTime = System.currentTimeMillis() - startMilis;
       // LOGGER.info("execution time: {}", executionTime);

        return executionTime;
    }
}
