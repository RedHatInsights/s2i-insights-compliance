# s2i-compliance-prometheus-exporter
FROM centos/ruby-25-centos7

LABEL maintainer="Daniel Lobato Garcia <dlobatog@redhat.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV PROMETHEUS_EXPORTER 0.4.2
ENV RAILS_ENV=production RAILS_LOG_TO_STDOUT=true

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Aggregator of all prometheus metrics for compliance" \
      io.k8s.display-name="Compliance prometheus_exporter 0.4.2" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,prometheus_exporter,compliance"

# Install rubygems and clean cache to make the image leaner
USER root
RUN yum install -y epel-release openscap qt5-qtwebkit-devel && yum clean all -y
USER 1001

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

CMD ["run"]
