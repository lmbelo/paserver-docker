FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

### Download PAServer
ADD https://altd.embarcadero.com/releases/studio/23.0/121/1211/LinuxPAServer23.0.tar.gz ./paserver.tar.gz

### Copy the PAServer runner script
COPY paserver_docker.sh ./paserver_docker.sh

### Run all commands in a single layer - this might affect the final image size
RUN apt-get update && apt-get -y autoremove --purge && apt-get -y clean && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install \
    joe \
    wget \
    p7zip-full \
    curl \
    openssh-server \
    build-essential \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libncurses5 \
    libpython3.10 \
    && rm -rf /var/lib/apt/lists/* \
    ### Extract PAServer to the right folder and remove the compressed file
    && tar xvzf paserver.tar.gz \
    && mv PAServer-23.0/* . \
    && rm PAServer-23.0 -r \
    && rm paserver.tar.gz \
    ### Creates the symlink to the Python interpreter in the PAServer required location
    && mv lldb/lib/libpython3.so lldb/lib/libpython3.so_ \
    && ln -s /lib/x86_64-linux-gnu/libpython3.9.so.1 lldb/lib/libpython3.so \
    ### Add executes permission to run paserver_docker.sh later on
    && chmod +x paserver_docker.sh

### Expose PAServer`s default port
EXPOSE 64211

### Get ready to bind to PAServer`s default scratch dir
VOLUME ["/root/PAServer/scratch-dir"]

### Executes PAServer runner script
ENTRYPOINT ["./paserver_docker.sh"]
