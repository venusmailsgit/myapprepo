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

#### Level - 1 : Dockerize the application
1. Create a Dockerfile for the application
2. Build the image 
3. Run the image

#### Level - 2 : Build a CD pipeline
1. Create a CD pipeline in Jenkins CI server (or any other CI server of your choice)
2. As part of the pipeline, 
    1. Check out the code
    2. Build it
    3. Check using SonarQube (optional) 
    4. Test the API
    5. Create Docker image of the same
    6. Push to Docker Hub
    7. Notify once the build is completed

#### Level - 3 : Provision an environment
1. Either manually or through code (like through usage of Terraform) provision the environment
2. As part of the environment,
    1. Create a VPC
    2. Ensure that the VPC spans at least 2 availability zones
    3. Create a public subnet 
    4. Create a private subnet 
    5. Provision EC2 instances; refer to [app-install.sh](app-install.sh); use it as user data to initialize an app on VM startup
    6. Configure classic Elastic Load Balancer to route traffic to the EC2 instances 

#### Level - 4 : Deploy the solution
1. Complete Level - 3
2. Update the VMs to have Docker runtime
3. Deploy the image on the VM by downloading it from Docker Hub