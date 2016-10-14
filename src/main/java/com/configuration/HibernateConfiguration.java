package com.configuration;


import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.hibernate5.HibernateTransactionManager;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.core.env.Environment;

import javax.sql.DataSource;
import java.util.Properties;



//indicates that this class contains one or more bean methods annotated with @Bean producing beans manageable by spring container
@Configuration
//enabling Spring’s annotation-driven transaction management capability.
@EnableTransactionManagement
//used to declare a set of properties(defined in a properties file in application classpath) in Spring run-time Environment
@PropertySource(value = { "classpath:application.properties" })
public class HibernateConfiguration {
        @Autowired
        private Environment environment;

        //creating a LocalSessionFactoryBean, which exactly mirrors the XML based configuration
        @Bean
        public LocalSessionFactoryBean sessionFactory() {
                LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
                sessionFactory.setDataSource(dataSource());
                sessionFactory.setPackagesToScan("com.dao", "com");

                //sessionFactory.setPackagesToScan(new String[] { "com.models" });
                sessionFactory.setHibernateProperties(hibernateProperties());
                return sessionFactory;
        }

        @Bean
        public DataSource dataSource(){
                DriverManagerDataSource dataSource = new DriverManagerDataSource();
                dataSource.setDriverClassName(environment.getRequiredProperty("jdbc.driverClassName"));
                dataSource.setUrl(environment.getRequiredProperty("jdbc.url"));
                dataSource.setUsername(environment.getRequiredProperty("jdbc.username"));
                dataSource.setPassword(environment.getRequiredProperty("jdbc.password"));
                return dataSource;
        }

        private Properties hibernateProperties() {
                Properties properties = new Properties();
                properties.put("hibernate.dialect", environment.getRequiredProperty("hibernate.dialect"));
                properties.put("hibernate.show_sql", environment.getRequiredProperty("hibernate.show_sql"));
                properties.put("hibernate.format_sql", environment.getRequiredProperty("hibernate.format_sql"));
                properties.put("hibernate.hbm2ddl.auto", "update");
                properties.put("hibernate.enable_lazy_load_no_trans", environment.getRequiredProperty("hibernate.enable_lazy_load_no_trans"));
                return properties;
        }

        @Bean
        @Autowired
        public HibernateTransactionManager transactionManager(SessionFactory s) {
                HibernateTransactionManager txManager = new HibernateTransactionManager();
                txManager.setSessionFactory(s);
                return txManager;
        }
}
