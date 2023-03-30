FROM tomcat:8.0.20-jre8

COPY target/project*.war /usr/local/tomcat/webapps/project.war