# Stage 1: Build the applications
FROM maven:3.8.6-jdk-11-slim AS build
RUN mkdir -p /workspace
WORKDIR /workspace

# Copy the code and build the applications
COPY lesson26/pom.xml /workspace


# Build the applications with Maven
RUN mvn -B package --file pom.xml -DskipTests

# Stage 2: Create the Docker image
FROM openjdk:14-slim

# Copy the built JAR files from the build stage
COPY --from=build /workspace/app_jenkins/target/*jar-with-dependencies.jar /app_jenkins.jar
COPY --from=build /workspace/app_devops/target/*jar-with-dependencies.jar /app_devops.jar
COPY --from=build /workspace/app_world/target/*jar-with-dependencies.jar /app_world.jar

# Expose the necessary port(s)
EXPOSE 6379

# Set the entry point and default command
ENTRYPOINT ["java", "-jar"]
CMD ["/app_jenkins.jar"]
