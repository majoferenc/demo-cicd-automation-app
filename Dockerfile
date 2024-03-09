FROM registry.access.redhat.com/ubi8/openjdk-17:1.19-1 AS build

WORKDIR /app

USER 1001

COPY build/libs/demo-0.0.1-SNAPSHOT.jar /app/demo-app.jar

# Expose the port that the application will run on
EXPOSE 8080

CMD ["java", "-jar", "demo-app.jar"]