package restTest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.Date;


import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Rest extends Thread {

    static String urlString = "http://localhost:8080/TrafficThreat/rest/";

    public static void main(String[] args) throws InterruptedException {
        Rest thread;

        System.out.println("start time: " + System.currentTimeMillis());

        for (int i = 0; i < 100; i++) {
            thread = new Rest();
            thread.start();
            thread.sleep(2);
        }

        System.out.println("Finish");
    }

    public void run() {

        /////////////////////////////////////////////// prepare parameters for register new user

        String login = "login" + System.currentTimeMillis();
        String mail = login + "@mail.com";

        String urlParam = "login=" + login;
        urlParam += "&mail=" + mail;
        urlParam += "&password=password";
        urlParam += "&name=name";
        urlParam += "&surname=surname";
        try {
            //////////////////////////////////////////////// register new user

            String result = " register: ";
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
            while ((output = br.readLine()) != null) {
                result += output;
            }

            conn.disconnect();

            result += "\n login: ";

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
                result += output;
                response += output;
            }

            conn.disconnect();

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

            result += "\n addThreat: ";

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
                result += output;
                response += output;
            }

            conn.disconnect();

            obj = parser.parse(response);
            String threatUuid = (String) ((JSONObject) obj).get("uuid");

            response = "";
            //System.out.println("add Threat: " + result);

            /////////////////////////////////////////////////////////// Prepare data for edit threat


            urlParam = "uuidThreat=" + threatUuid;
            urlParam += "&description=edited%20description";
            urlParam += "&token=" + token;

            /////////////////////////////////////////////////////////// Edit threat

            result += "\n editThreat";

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
                result += output;
                response += output;
            }

            conn.disconnect();

            //System.out.println("edit Threat: " + result);

            /////////////////////////////////////////////////////////// Prepare data for delete threat

            urlParam = "uuid=" + threatUuid;
            urlParam += "&token=" + token;

            /////////////////////////////////////////////////////////// delete threat

            result += "\n deleteThreat";

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
            while ((output = br.readLine()) != null) {
                result += output;
            }

            conn.disconnect();

            //System.out.println("delete Threat: " + result);

            System.out.println("result: " + result);
            System.out.println("____________________________________________");
            System.out.println("endTime" + System.currentTimeMillis());

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (ProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
