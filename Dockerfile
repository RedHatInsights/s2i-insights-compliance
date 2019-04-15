# s2i-insights-compliance
FROM registry.access.redhat.com/rhscl/ruby-25-rhel7

LABEL maintainer="Daniel Lobato Garcia <dlobatog@redhat.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV INSIGHTS_COMPLIANCE 0.4.2
ENV RAILS_ENV=production RAILS_LOG_TO_STDOUT=true

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Base image for Red Hat Insights Compliance" \
      io.k8s.display-name="Compliance base image" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,compliance"

# Install dependencies and clean cache to make the image cleaner
USER root
RUN yum install -y yum-utils
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum-config-manager --enable epel
RUN yum install -y openscap qt5-qtwebkit-devel jemalloc pygpgme curl
RUN curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
RUN yum install -y passenger || yum-config-manager --enable cr && yum install -y passenger && \
    yum clean all -y
RUN /usr/bin/passenger-config validate-install

USER 1001

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

CMD ["run"]
