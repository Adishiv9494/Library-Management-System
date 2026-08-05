FROM tomcat:11.0
RUN apt-get update && apt-get install -y wget
RUN wget -O /usr/local/tomcat/webapps/ROOT.war "https://github.com/Adishiv9494/Library-Management-System/releases/download/v1.0/ROOT.war"
EXPOSE 8080