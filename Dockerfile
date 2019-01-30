# s2i-compliance-prometheus-exporter
FROM centos/ruby-25-centos7

LABEL maintainer="Daniel Lobato Garcia <dlobatog@redhat.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV PROMETHEUS_EXPORTER 0.4.2

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Aggregator of all prometheus metrics for compliance" \
      io.k8s.display-name="Compliance prometheus_exporter 0.4.2" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,prometheus_exporter,compliance"

# Install rubygems and clean cache to make the image leaner
USER root
RUN yum install -y rubygems rh-ruby25-{ruby-devel,rubygem-bundler,rubygem-rake} && yum clean all -y

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# This default user is created in the openshift/base-centos7 image
RUN chown -R 1001:1001 /opt/app-root
USER 1001

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# Set the default port for applications built using this image
EXPOSE 8080

CMD ["run"]
