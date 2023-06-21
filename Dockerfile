#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY my-app/src /home/app/src
COPY my-app/pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean install

#
# Package stage
#
FROM openjdk:11-jre-slim
COPY --from=build /home/app/target/my-app-0.0.1-SNAPSHOT.jar /usr/local/lib/my-app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/my-app.jar"]