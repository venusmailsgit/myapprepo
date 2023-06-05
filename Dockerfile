FROM maven:3.8.6-openjdk-8

COPY ./my-app/target ./my-app

WORKDIR ./my-app

ENTRYPOINT ["/usr/local/openjdk-8/bin/java","-jar", "my-app-0.0.1-SNAPSHOT.jar"]