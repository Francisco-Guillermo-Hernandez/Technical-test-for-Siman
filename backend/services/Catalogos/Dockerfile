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

# Copy the executable (fat) jar to a stable path so the runtime stage can pick it reliably
RUN sh -c '\
	for f in build/libs/*.jar; do \
		case "$f" in \
			*-plain.jar) ;; \
			*) cp "$f" /workspace/app.jar; break ;; \
		esac; \
	done; \
'

# Stage 2: Runtime image
FROM amazoncorretto:21-alpine-jdk

WORKDIR /app

# Copy the resolved executable jar from the builder stage
COPY --from=builder /workspace/app.jar /app/app.jar

# Expose the port configured in application.yml (8282)
EXPOSE 8282

# Run the jar
ENTRYPOINT ["java","-jar","/app/app.jar"]