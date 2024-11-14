// Bu sınıf, Spring Boot ve Spring Cloud Config Server yapılandırmasını içeren ana uygulama sınıfıdır.
package com.hamitmizrak._2_configserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

// Spring Boot uygulaması olarak işaretlemek için kullanılır,
// bileşen taraması ve otomatik yapılandırma sağlar.
@SpringBootApplication

// Bu anotasyon, sınıfı bir Config Server olarak tanımlar.
// Config Server, merkezi bir yapılandırma yönetimi sunar ve konfigürasyonları dışarıya sağlar.
@EnableConfigServer
public class Application {

    // Uygulamanın ana (main) metodu, Spring Boot uygulamasının başlangıç noktasıdır.
    public static void main(String[] args) {
        // SpringApplication.run, Spring uygulamasını başlatır ve Spring konteynırını oluşturur.
        SpringApplication.run(Application.class, args);
    }

}
