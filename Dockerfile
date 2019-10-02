FROM registry.access.redhat.com/ubi7/ubi-minimal:7.7-98

MAINTAINER Pramod Padmamabhan[ppadmana@redhat.com]

#Adding env details
ENV FIS_JAVA_IMAGE_NAME="jboss-fuse/minimal-fuse-openshift" \
FIS_JAVA_IMAGE_VERSION="7.7-98" \
PATH=$PATH:"/usr/local/s2i" \
JAVA_DATA_DIR="/deployments/data"

# BASE version information
LABEL name="$FIS_JAVA_IMAGE_NAME" \
version="$FIS_JAVA_IMAGE_VERSION" \
architecture="x86_64" \
summary="Platform for building and running plain Java applications (fat-jar and flat classpath)" \
com.redhat.component="jboss-fuse-x-fuse-java-openshift-container" \
io.fabric8.s2i.version.maven="3.3.3-1.el7" \
io.k8s.description="Platform for building and running plain Java applications (fat-jar and flat classpath)" \
io.k8s.display-name="Fuse Integration Services - Java" \
io.openshift.tags="builder,java" \
io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
io.openshift.s2i.destination="/tmp" \
org.jboss.deployments-dir="/deployments" \
description="Fuse Base Image With minimal UBI" \
group="ubi-minimal"

USER root
ADD run-java/ /opt/run-java
ADD s2i/ /usr/local/s2i
ADD jolokia /opt/jolokia/


#install OpenJDK 1.8 / use only when getting ubi minimal image
RUN microdnf --enablerepo=rhel-7-server-rpms \
&& install java-1.8.0-openjdk-headless \
&& microdnf clean all \
&& echo securerandom.source=file:/dev/urandom >> /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64/jre/lib/security/java.security \
&& useradd -r jboss \
&& usermod -g root -G jboss jboss \
&& chmod -R 755 /opt/run-java ; chmod -R 755 /usr/local/s2i \
&& mkdir -p /deployments/data \
&& chmod -R "g+rwX" /deployments \
&& chown -R jboss:root /deployments \
&& chmod 444 /opt/jolokia/jolokia.jar \
&& chmod 755 /opt/jolokia/jolokia-opts \
&& chmod 775 /opt/jolokia/etc \
&& chgrp root /opt/jolokia/etc

#fis user
USER 185
CMD [ "/usr/local/s2i/run" ]
