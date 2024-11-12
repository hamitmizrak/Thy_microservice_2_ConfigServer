# THY Microservice Config Server
[GitHub](https://github.com/hamitmizrak/Thy_microservice_2_ConfigServer)

---

## Config Server (End point)
```sh 

```
---

## Config Server
- Mikroservislerin konfigürasyonlarını merkezi bir yerde yönetmek için kullanıdoğımız yapıdır.
- Bu config-server yapısı: Merkezi bir alan içinde Config Server üzerinden yapılandırmaları dinamik olarak alabilir.
- Merkezi bir konfigürasyon yönetim sunuculuğunu yapar.
- Bir veya daha fazla mikroservislerin konfigürasyon dosyalarını merkezi bir yerde sunar.

# Spring Cloud(Config Client)
- Spring Cloud Serverdan konfigürasyonları almak için kullanılan istemcidir.
- Mikroservisler genellikle Config Client olarak yapılandırılır.
- Config Client Config Server'a bağlanır ve merkezi oalrak yönetilen konfigürsayon dosylarını alır
- Eğer uygulamamız merkezi olarak yönetilen konfigürasyonları almak için Spring Cloud Config server'a bağlancaksa biz Config Client ekliyoruz.
- İlgili Servisimiz config client için bootstrap.properties dosyasıdan config server verilerini alacaktır.


**Config Server Dosyalarının Detaylı Açıklaması**
- Config Server, bir mikroservis mimarisinde merkezi konfigürasyon yönetimi için kritik bir bileşendir. 
- Bu yapıda, her mikroservis (örneğin, `user-service`, `product-service`, `order-service`, ve `payment-service`), yapılandırma bilgilerini Config Server’dan alır. 
- Config Server, genellikle dış kaynaklı bir git deposunda saklanan yapılandırma dosyalarını okumak için kullanılır, 
- bu sayede yapılandırmalar versiyonlanabilir ve merkezi bir konumdan yönetilebilir.
- Config Server yapılandırması aşağıdaki gibi detaylandırılabilir:
---
### Config Server’ın İşleyişi
1. **Konfigürasyon Dosyalarının Merkezi Yönetimi**: Her mikroservis, yapılandırma dosyalarını kendi kod deposunda tutmak yerine Config Server üzerinden merkezi olarak yönetir. Bu, yapılandırma değişikliklerinin kolayca izlenmesini ve güncellenmesini sağlar.
2. **Dinamik Konfigürasyon Güncellemeleri**: Mikroservisler, Config Server’da yapılan güncellemeleri belirli bir süre aralığında veya elle tetikleme yoluyla alabilir. Spring Cloud Bus ile RabbitMQ veya Kafka gibi mesaj kuyrukları kullanılarak konfigürasyonlar anında güncellenebilir.
3. **Versiyon Kontrolü ile Entegrasyon**: Config Server, konfigürasyon dosyalarını bir Git deposundan aldığı için, her yapılandırma değişikliği git ile versiyonlanabilir. Bu da yapılandırma değişikliklerinin izlenebilir olmasını sağlar.
 Bu detaylı açıklama, Config Server yapılandırmasının nasıl düzenlendiğini ve nasıl işlediğini anlamak için kapsamlı bir bakış sunmaktadır.

---
### 1. `config-server/`
- Config Server, bu ana dizinde barındırılmaktadır. Bu dizinde Config Server’ın çalışması için gerekli tüm bileşenler bulunur.
- **`src/`**: Uygulama kaynak dosyalarını barındırır. Bu dizin, `main` ve `test` gibi alt dizinler içerir, 
- ancak burada sadece `main` dizini yer almaktadır çünkü Config Server işlevselliği için test dosyaları bu örnekte belirtilmemiştir.


#### `src/main/java/com/example/configserver/ConfigServerApplication.java`
Bu dosya, Config Server uygulamasının ana sınıfıdır. Spring Boot uygulamaları için giriş noktası olarak hizmet verir. Config Server olarak yapılandırılması için aşağıdaki gibi `@EnableConfigServer` anotasyonu ile işaretlenmiştir:

```java
package com.example.configserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigServerApplication.class, args);
    }
}
```

- **`@EnableConfigServer`**: Bu anotasyon, sınıfı bir Config Server olarak etkinleştirir. Spring Cloud Config Server, git gibi bir uzaktan yapılandırma deposundan yapılandırma dosyalarını okumak için bu anotasyonu kullanır.

#### `src/main/resources/application.yml`
Bu dosya, Config Server’ın ana yapılandırma dosyasıdır. Config Server’ın git gibi bir kaynaktan yapılandırma dosyalarını nasıl çekeceğini belirler. Genelde şu bölümlerle yapılandırılır:

```yaml
spring:
  application:
    name: config-server  # Config Server uygulamasının adı
  cloud:
    config:
      server:
        git:
          uri: https://github.com/example/config-repo  # Yapılandırma dosyalarının saklandığı git deposunun URL'si
          default-label: main  # Varsayılan olarak hangi dalı kullanacağı (örn. main)
server:
  port: 8888  # Config Server’ın çalışacağı port numarası
```

- **`spring.application.name`**: Config Server uygulaması için bir isim tanımlar.
- **`spring.cloud.config.server.git.uri`**: Config Server’ın yapılandırma dosyalarını hangi git deposundan çekeceğini belirtir.
- **`server.port`**: Config Server’ın hangi portta çalışacağını ayarlar. Burada 8888 portu kullanılmaktadır.
#### `src/main/resources/git-repo-configs/`
Bu klasör, Config Server’ın git deposundan çekeceği örnek yapılandırma dosyalarını içerir. Bu dosyalar, ilgili mikroservisler tarafından kullanılacak yapılandırmaları sağlar. Her bir yapılandırma dosyası, mikroservislerin belirli konfigürasyon bilgilerini merkezi bir konumdan almasını sağlar.

- **`user-service.yml`**: `user-service` mikroservisi için yapılandırma dosyasıdır. Bu dosyada `user-service`’e özgü veritabanı bağlantı bilgileri, port numarası gibi ayarlar bulunabilir. Örnek içerik:

    ```yaml
    spring:
      datasource:
        url: jdbc:mysql://localhost:3306/userdb
        username: user
        password: password
      application:
        name: user-service
    server:
      port: 8081
    ```

    - **`spring.datasource.url`**: Kullanılacak veritabanı bağlantı URL'si.
    - **`spring.application.name`**: Mikroservisin adı.
    - **`server.port`**: `user-service` mikroservisinin çalışacağı port.

- **`product-service.yml`**: `product-service` mikroservisi için yapılandırma dosyasıdır. Bu dosyada `product-service`’e özgü ayarlar bulunur. Örnek içerik:

    ```yaml
    spring:
      datasource:
        url: jdbc:mysql://localhost:3306/productdb
        username: product_user
        password: product_password
      application:
        name: product-service
    server:
      port: 8082
    ```

- **`order-service.yml`**: `order-service` mikroservisi için yapılandırma dosyasıdır. Bu dosya `order-service`’e özgü konfigürasyon ayarlarını içerir.

    ```yaml
    spring:
      datasource:
        url: jdbc:mysql://localhost:3306/orderdb
        username: order_user
        password: order_password
      application:
        name: order-service
    server:
      port: 8083
    ```

- **`payment-service.yml`**: `payment-service` mikroservisi için yapılandırma dosyasıdır. `payment-service`’e özel ayarlar içerir.

    ```yaml
    spring:
      datasource:
        url: jdbc:mysql://localhost:3306/paymentdb
        username: payment_user
        password: payment_password
      application:
        name: payment-service
    server:
      port: 8084
    ```

Bu yapılandırma dosyaları, her bir mikroservis için farklı bir veritabanı bağlantı bilgisi ve port numarası gibi önemli bilgileri içerir. Config Server çalıştığında, bu dosyaları okuyarak ilgili mikroservislere yapılandırma bilgilerini sağlar. Örneğin, `user-service`, `http://localhost:8888/user-service/default` URL’si aracılığıyla yapılandırma bilgilerini alabilir.
---

#### `pom.xml`
`pom.xml` dosyası, Config Server için bağımlılıkları tanımlar. Spring Cloud Config Server’ı etkinleştirmek için belirli bağımlılıklar eklenir.

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-config-server</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

- **`spring-cloud-config-server`**: Spring Cloud Config Server’ın ana bağımlılığıdır.
- **`spring-boot-starter-web`**: Web uygulamaları için gerekli olan bağımlılığı sağlar, böylece Config Server bir web sunucusu olarak çalışabilir.

### Config Server’ın İşleyişi
1. **Konfigürasyon Dosyalarının Merkezi Yönetimi**: Her mikroservis, yapılandırma dosyalarını kendi kod deposunda tutmak yerine Config Server üzerinden merkezi olarak yönetir. Bu, yapılandırma değişikliklerinin kolayca izlenmesini ve güncellenmesini sağlar.
2. **Dinamik Konfigürasyon Güncellemeleri**: Mikroservisler, Config Server’da yapılan güncellemeleri belirli bir süre aralığında veya elle tetikleme yoluyla alabilir. Spring Cloud Bus ile RabbitMQ veya Kafka gibi mesaj kuyrukları kullanılarak konfigürasyonlar anında güncellenebilir.
3. **Versiyon Kontrolü ile Entegrasyon**: Config Server, konfigürasyon dosyalarını bir Git deposundan aldığı için, her yapılandırma değişikliği git ile versiyonlanabilir. Bu da yapılandırma değişikliklerinin izlenebilir olmasını sağlar.
---

Bu detaylı açıklama, Config Server yapılandırmasının nasıl düzenlendiğini ve nasıl işlediğini anlamak için kapsamlı bir bakış sunmaktadır.