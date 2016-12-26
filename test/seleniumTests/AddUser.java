package seleniumTests;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;
import org.springframework.context.annotation.DependsOn;
import org.testng.Assert;
import org.testng.annotations.Test;

public class AddUser {


    public static void main(String[] args) throws InterruptedException {
        AddUser addUser = new AddUser();

        for(int i = 0; i<100; i++) {
         try {
             addUser.test1();
             addUser.test2();
             addUser.test3();
             addUser.driver.close();
         } catch (Error | Exception e) {
             System.out.println("Error in" + i + "e");
         }
        }
    }


    WebDriver driver;
    String login;
    @Test
    public void test1() throws InterruptedException {
        // declaration and instantiation of objects/variables
        driver = new FirefoxDriver();
        String baseUrl = "http://localhost:8080/TrafficThreat/";
        login = "login" + System.currentTimeMillis();
        String mail = login + "@mail.com";

        driver.get(baseUrl);

        //upperRight menu
        driver.findElement(By.className("dropdown")).click();

        driver.findElement(By.xpath("//a[contains(text(), 'Sign Up')]")).click();
        Thread.sleep(500);
        driver.findElement(By.id("loginReg")).sendKeys(login);
        driver.findElement(By.id("passwordReg")).sendKeys("password");
        driver.findElement(By.id("mailReg")).sendKeys(mail);
        driver.findElement(By.id("nameReg")).sendKeys("seleniumName");
        driver.findElement(By.id("surnameReg")).sendKeys("seleniumSurname");
        driver.findElement(By.xpath("//button[contains(text(), 'Sign Up')]")).click();
        Thread.sleep(500);

        String message = driver.findElement(By.id("alert_placeholder")).getText();

        if(!message.equals("Success")) {
            Assert.fail("Bad message. Expected: [Success], actual: [" + message + "].");
        }
    }

    @Test
    @DependsOn("test1")
    public void test2() throws InterruptedException {
        driver.findElement(By.className("dropdown")).click();

        driver.findElement(By.xpath("//a[contains(text(), 'Log In')]")).click();
        driver.findElement(By.id("username")).sendKeys(login);
        driver.findElement(By.id("password")).sendKeys("password");
        driver.findElement(By.xpath("//input[contains(@value, 'Log in')]")).click();
        Thread.sleep(500);

        String pageHeader = driver.findElement(By.className("page-header")).getText();

        if(!pageHeader.contains("Dashboard")) {
            Assert.fail("Error you should be on dashboard page. Actual: [" + pageHeader + "]");
        }

        driver.findElement(By.xpath("//a[contains(text(), 'Add Threat')]")).click();
        pageHeader = driver.findElement(By.className("page-header")).getText();

        if(!pageHeader.contains("Add Threat")) {
            Assert.fail("Error you should be on Add Threat page. Actual: [" + pageHeader + "]");
        }

        new Select(driver.findElement(By.id("typeOfThreat"))).selectByVisibleText("Dziury na drodze");
        new Select(driver.findElement(By.id("typeOfThreat2"))).selectByVisibleText("Stałe");
        driver.findElement(By.id("description")).sendKeys("Dziury na drodze");
        driver.findElement(By.id("address")).clear();
        driver.findElement(By.id("address")).sendKeys("Czarnowiejska 30, Kraków");
        driver.findElement(By.id("checkLocation")).click();
        Thread.sleep(1000);
        driver.findElement(By.name("file")).sendKeys("/home/piotrek/Desktop/dziury.jpg");
        Thread.sleep(1000);
        driver.findElement(By.xpath("//input[contains(@value, 'Add Threat')]")).click();
        Thread.sleep(1000);

        pageHeader = driver.findElement(By.className("page-header")).getText();
        if(!pageHeader.contains("Threat Details")) {
            Assert.fail("Error you should be on Threat Details page. Actual: [" + pageHeader + "]");
        }
        driver.findElement(By.className("dropdown")).click();
        driver.findElement(By.xpath("//a[contains(text(), 'Logout')]")).click();
    }

    @Test
    @DependsOn("test2")
    public void test3() throws InterruptedException {

        driver.findElement(By.className("dropdown")).click();
        driver.findElement(By.xpath("//a[contains(text(), 'Log In')]")).click();
        driver.findElement(By.id("username")).sendKeys(login);
        driver.findElement(By.id("password")).sendKeys("password");
        driver.findElement(By.xpath("//input[contains(@value, 'Log in')]")).click();
        Thread.sleep(500);

        String pageHeader = driver.findElement(By.className("page-header")).getText();

        if(!pageHeader.contains("Dashboard")) {
            Assert.fail("Error you should be on dashboard page. Actual: [" + pageHeader + "]");
        }

        driver.findElement(By.className("dropdown")).click();

        driver.findElement(By.xpath("//a[contains(text(), 'User Profile')]")).click();
        driver.findElement(By.xpath("//a[contains(text(), 'My Threats')]")).click();
        Thread.sleep(1000);
        driver.findElement(By.xpath("//button[contains(text(), 'details')]")).click();
        driver.findElement(By.xpath("//button[contains(text(), 'edit')]")).click();
        driver.findElement(By.id("description")).sendKeys("Edited");
        driver.findElement(By.id("checkLocation")).click();
        Thread.sleep(1000);
        driver.findElement(By.xpath("//input[contains(@value, 'Edit Threat')]")).click();
        Thread.sleep(1000);
        driver.findElement(By.xpath("//td[text()='description']"));

        pageHeader = driver.findElement(By.className("page-header")).getText();

        if(!pageHeader.contains("Threat Details")) {
            Assert.fail("Error you should be on Threat Details page. Actual: [" + pageHeader + "]");
        }

        String description = driver.findElement(By.xpath("//td[contains(text(), 'description')]/following-sibling::td")).getText();
        if(!description.contains("Edit")) {
            Assert.fail("Description should be edited");
        }

        driver.findElement(By.className("dropdown")).click();
        driver.findElement(By.xpath("//a[contains(text(), 'Logout')]")).click();

    }

    @Test
    @DependsOn("test3")
    public void test4() throws InterruptedException {

        driver.findElement(By.className("dropdown")).click();
        driver.findElement(By.xpath("//a[contains(text(), 'Log In')]")).click();
        driver.findElement(By.id("username")).sendKeys(login);
        driver.findElement(By.id("password")).sendKeys("password");
        driver.findElement(By.xpath("//input[contains(@value, 'Log in')]")).click();
        Thread.sleep(500);

        String pageHeader = driver.findElement(By.className("page-header")).getText();

        if(!pageHeader.contains("Dashboard")) {
            Assert.fail("Error you should be on dashboard page. Actual: [" + pageHeader + "]");
        }

        driver.findElement(By.className("dropdown")).click();

        driver.findElement(By.xpath("//a[contains(text(), 'User Profile')]")).click();
        driver.findElement(By.xpath("//a[contains(text(), 'My Threats')]")).click();
        Thread.sleep(1000);
        driver.findElement(By.xpath("//button[contains(text(), 'delete')]")).click();
        Thread.sleep(2000);
        driver.navigate().refresh();
        driver.findElement(By.xpath("//a[contains(text(), 'My Threats')]")).click();
        if(driver.findElements(By.xpath("//tr")).size() > 1) {
            Assert.fail("Error deleting threat");
        }

    }

}