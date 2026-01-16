ARG MAINTAINER=rcmlz
#ARG IMAGE_NAME=edu-docker-env
#ARG IMAGE_VERSION=1
#ARG IMAGE_TAG=$MAINTAINER/$IMAGE_NAME:$IMAGE_VERSION
#run: export DOCKER_BUILDKIT=1 && docker build --force-rm -t $IMAGE_TAG . && docker compose up
# Avoid prompts with apt
###############################################################################
#see https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile
ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER
LABEL maintainer=rcmlz
ENV DEBIAN_FRONTEND=noninteractive

###############################################################################
# apt
WORKDIR /tmp
USER root
#COPY apt.txt /tmp/apt.txt
COPY apt-minimal.txt /tmp/apt.txt
RUN    echo "Acquire::http::Pipeline-Depth 0;" >  /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::http::No-Cache true;"    >> /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::BrokenProxy true;"       >> /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::By-Hash true;"           >> /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::ForceIPv4 true;"         >> /etc/apt/apt.conf.d/99fixbadproxy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update -y \
    && grep -vE '^#' /tmp/apt.txt | xargs apt-get install --yes --no-install-recommends \
    && apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*

###############################################################################
# pip
WORKDIR /tmp
USER root
COPY requirements.txt .
#RUN pip install --no-cache-dir -r requirements.txt
RUN pip install -r requirements.txt

###############################################################################
# raku
###############################################################################
WORKDIR /tmp
USER root
ARG RAKUVERSION='moar-2025.12'
ENV PATH=$PATH:/home/jovyan/.rakubrew/versions/$RAKUVERSION/install/share/perl6/site/bin:/usr/share/perl6/core/bin:/usr/share/perl6/site/bin:/usr/share/perl6/vendor/bin
RUN curl -LJO https://rakubrew.org/install-on-perl.sh && \
    chmod +x install-on-perl.sh && \
    ./install-on-perl.sh && \
    eval "$($HOME/.rakubrew/bin/rakubrew init Bash)" && \
    echo 'eval "$($HOME/.rakubrew/bin/rakubrew init Bash)"' >> ~/.bashrc && \
    rakubrew build $RAKUVERSION

#RUN eval "$($HOME/.rakubrew/bin/rakubrew init Bash)" && \
    #if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    #        rakubrew download $RAKUVERSION; \
    #else \
    #        rakubrew build $RAKUVERSION; \
    #fi

###############################################################################
# zef
###############################################################################
WORKDIR /tmp
ENV PATH=$PATH:$HOME/.raku/bin
USER root
RUN eval "$($HOME/.rakubrew/bin/rakubrew init Bash)" && \
    git clone https://github.com/ugexe/zef.git && \
    cd zef && \
    raku -I. bin/zef install .

#RUN if [ "$TARGETPLATFORM" != "linux/amd64" ]; then \
#            eval "$($HOME/.rakubrew/bin/rakubrew init Bash)"; \
#            git clone https://github.com/ugexe/zef.git; \
#            cd zef; \
#            raku -I. bin/zef install . ; \
#    fi

###############################################################################
# raku packages
###############################################################################
COPY raku-packages.txt .
USER "${NB_UID}"
RUN eval "$($HOME/.rakubrew/bin/rakubrew init Bash)" && \
    ZEF_TEST_DEGREE=`raku -e "say $*Kernel.cpu-cores"` && \
    ZEF_FETCH_DEGREE=$ZEF_TEST_DEGREE && \
    zef update && \
    PACKAGE_NAME='Jupyter::Chatbook:auth<zef:antononcube>'  && \
    zef install --/test --deps-only "$PACKAGE_NAME" && \
    zef install --/test "$PACKAGE_NAME" && \
    jupyter-chatbook-raku --generate-config --location=/home/jovyan/.local/share/jupyter/kernels/chatbook-raku && \
    cat raku-packages.txt | raku -e 'for $*IN.lines.grep(/^^\w/) { say shell "zef install --/test \"$_\"" }'

###############################################################################
# Perl
WORKDIR /tmp
USER root
COPY cpanfile /tmp/cpanfile
RUN    cpanm --notest --installdeps . \
    && cpanm --notest Alien::ZMQ::latest \
    && cpanm --notest Devel::IPerl \
    && iperl --help

###############################################################################
# Julia
WORKDIR /tmp
USER root
RUN julia -e 'import Pkg; Pkg.add("Pluto")'

###############################################################################
# JS
WORKDIR /tmp
USER root
RUN  npm install -g --unsafe-perm ijavascript \
    && ijsinstall

###############################################################################
# clean up
WORKDIR /tmp
USER root
RUN    rm -rf /tmp/* \
    && rm -rf ${HOME}/.git ${HOME}/.cache ${HOME}/.yarn ${HOME}/.cpan ${HOME}/.cpanm ${HOME}/.empty ${HOME}/.npm/_cacache \
    && rm -rf /root/* \
    && find /var/log -type f -print0 | xargs -0 truncate -s 0 \
    && fix-permissions "${HOME}"

###############################################################################
# ready for starting jupyter
USER "${NB_UID}"
WORKDIR "${HOME}"
