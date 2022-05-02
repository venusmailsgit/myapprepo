# Assignment

Welcome to the assignment section for DevOps. We understand that time and resources are limited. Hence the assignments are broken into few levels. 

## Context

The sample application is a simple Spring Boot application that helps in storing the detail of the employees. It exposes REST API to CRUD on employee entity. The data is stored in an in memory database (which means that data stored in the database will not survive a server/app restart). 

### Prerequisites
1. Java 8
2. Maven 3 
3. Git Client (to check out code)
4. Postman (to invoke the API of the application)

Once checked out, use following commands to build and run the application on local machine.

```
 cd my-app
 mvn clean install
 cd target
 java -jar my-app-0.0.1-SNAPSHOT.jar
```

There is a [postman collection](DevOps-Assessment.postman_collection.json). Feel free to use and extend the same to test the API behaviour.