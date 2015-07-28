FROM centos:6
MAINTAINER Petr Archakov <petr.etc@gmail.com>

RUN yum install -y wget curl tar make gcc-c++ rpm-build nano which \
  libyaml-devel autoconf readline-devel zlib-devel libffi-devel openssl-devel \
  automake libtool bison sqlite-devel

ADD rvm_package /usr/bin/rvm_package
RUN chmod +x /usr/bin/rvm_package

VOLUME /tmp/out
RUN chmod a+rwx /tmp/out

CMD [ -n "$RVM_USER" ] && [ -n "$RVM_GROUP" ] && [ -n "$RVM_USER_HOME" ] \
  && groupadd ${RVM_GROUP} \
  && useradd -g ${RVM_GROUP} -d ${RVM_USER_HOME} ${RVM_USER} \
  && su - $RVM_USER -c "cd ${RVM_USER_HOME} \
  && RUBY_VERSIONS=${RUBY_VERSIONS} \
  PACKAGE_NAME=${PACKAGE_NAME} \
  PACKAGE_VERSION=${PACKAGE_VERSION} \
  PACKAGE_DEPS=${PACKAGE_DEPS} \
  RUBY_GEMS=${RUBY_GEMS} \
  rvm_package" \
  && mv ${RVM_USER_HOME}/*.rpm /tmp/out \
  || (([ -z $RVM_USER ] && echo "RVM_USER is not specified") \
  && ([ -z $RVM_GROUP ] && echo "RVM_GROUP is not specified") \
  && ([ -z $RVM_USER_HOME ] && echo "RVM_USER_HOME is not specified")) \
  && mv /tmp/*.log /tmp/out
