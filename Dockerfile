FROM tomcat:8.0.20-jre8
# Dummy text to test 
COPY target/cicd-prem-app*.war /usr/local/tomcat/webapps/cicd-prem-app.war
