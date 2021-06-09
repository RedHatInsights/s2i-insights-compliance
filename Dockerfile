# s2i-insights-compliance
# Rebuild: 2021-02-23
FROM registry.access.redhat.com/ubi8/ruby-27

# Update release-date on changes or rebuids
LABEL maintainer="Insights Compliance <insights-dev@redhat.com>" \
      com.redhat.cloud.compliance.s2i.release-date="2021-01-12"

ENV RAILS_ENV=production RAILS_LOG_TO_STDOUT=true

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Base image for Red Hat Insights Compliance" \
      io.k8s.display-name="Compliance base image" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,compliance"

# Install dependencies and clean cache to make the image cleaner
USER root
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum install -y hostname shared-mime-info && \
    yum clean all -y
USER 1001

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

CMD ["run"]
