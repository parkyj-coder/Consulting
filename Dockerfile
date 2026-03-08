# 빌드 단계
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests

# 실행 단계 (Tomcat)
FROM tomcat:10.1-jdk17-temurin-jammy
RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/target/Consulting.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
