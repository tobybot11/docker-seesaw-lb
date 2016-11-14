FROM ubuntu
MAINTAINER Tobias Ford <toby.ford@pobox.com>
ENV REFRESHED_AT 2016-11-14
ENV GOPATH /go
ENV PATH="/go/bin:${PATH}"

RUN apt-get -yq update && \
	apt-get install -yq ca-certificates git apt-utils debconf golang  
RUN apt-get install -y protobuf-compiler libnl-3-dev libnl-genl-3-dev

RUN go get -u golang.org/x/crypto/ssh
RUN go get -u github.com/dlintw/goconf
RUN go get -u github.com/golang/glog
RUN go get -u github.com/miekg/dns
RUN go get -u github.com/kylelemons/godebug/pretty
RUN go get -u github.com/golang/protobuf/proto
RUN go get -u github.com/golang/protobuf/protoc-gen-go

WORKDIR /go/src/github.com/google
RUN git clone https://github.com/google/seesaw.git

WORKDIR /go/src/github.com/google/seesaw
RUN make test
RUN make install
ENV SEESAW_ETC="/etc/seesaw"
RUN mkdir "${SEESAW_ETC}"
RUN install "etc/seesaw/watchdog.cfg" "${SEESAW_ETC}/watchdog.cfg"
RUN mkdir /var/log/seesaw
ENV SEESAW_BIN="/usr/local/seesaw"
RUN mkdir "${SEESAW_BIN}"
RUN /bin/bash -c 'for component in {ecu,engine,ha,healthcheck,ncc,watchdog}; do install "${GOPATH}/bin/seesaw_${component}" "${SEESAW_BIN}"; done'
RUN setcap cap_net_raw+ep /usr/local/seesaw/seesaw_ha
RUN setcap cap_net_raw+ep /usr/local/seesaw/seesaw_healthcheck 
RUN install "etc/seesaw/seesaw.cfg.example" "${SEESAW_ETC}/seesaw.cfg"
