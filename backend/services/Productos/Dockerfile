# Stage 1: Build the jar
FROM gradle:8.14-jdk21-jammy AS builder

WORKDIR /workspace

# Copy only the files needed to build (use Gradle wrapper and project files)
COPY gradlew gradlew
COPY gradle gradle
COPY gradle/wrapper gradle/wrapper
COPY build.gradle settings.gradle ./
COPY src src

# Ensure gradlew is executable
RUN chmod +x gradlew

# Build the jar (bootJar will create the runnable jar)
RUN ./gradlew bootJar --no-daemon

# Stage 2: Runtime image
FROM amazoncorretto:21-alpine-jdk

WORKDIR /app

# Copy the jar from the builder stage
COPY --from=builder /workspace/build/libs/*-plain.jar app.jar

# Expose the port configured in application.yml (8282)
EXPOSE 8282

# Run the jar
ENTRYPOINT ["java","-jar","/app/app.jar"]