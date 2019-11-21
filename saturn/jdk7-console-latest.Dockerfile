FROM openjdk:7-jdk-alpine
MAINTAINER flyceek@gmail.com

COPY build.sh /build.sh

RUN ["sh","/build.sh","alpine","console","3.3.1"]

EXPOSE 9088
CMD ["launch"]