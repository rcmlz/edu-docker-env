ARG MAINTAINER=rcmlz
#ARG IMAGE_NAME=edu-docker-env
#ARG IMAGE_VERSION=1
#ARG IMAGE_TAG=$MAINTAINER/$IMAGE_NAME:$IMAGE_VERSION
#run: export DOCKER_BUILDKIT=1 && docker build --force-rm -t $IMAGE_TAG . && docker compose up

###############################################################################
#see https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile
ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER
LABEL maintainer=$MAINTAINER

###############################################################################
# apt
WORKDIR /tmp
USER root
COPY apt.txt /tmp/apt.txt
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
# conda
WORKDIR /tmp
USER root
RUN conda config --add channels defaults
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda

ARG ENV_NAME=base
RUN conda install -y -n $ENV_NAME mamba
RUN mamba install -y -n $ENV_NAME jupyterlab-git
RUN mamba install -y -n $ENV_NAME rise
RUN mamba install -y -n $ENV_NAME xeus-cling
RUN mamba install -y -n $ENV_NAME xeus-sqlite
RUN mamba install -y -n $ENV_NAME soci-sqlite
RUN mamba install -y -n $ENV_NAME metakernel
RUN mamba install -y -n $ENV_NAME openjdk
RUN mamba install -y -n $ENV_NAME bash_kernel
RUN mamba install -y -n $ENV_NAME setuptools
RUN mamba install -y -n $ENV_NAME elm
RUN mamba install -y -n $ENV_NAME coq-jupyter
RUN mamba install -y -n $ENV_NAME setuptools wheel
RUN mamba install -y -n $ENV_NAME octave_kernel
RUN mamba install -y -n $ENV_NAME octave
RUN mamba install -y -n $ENV_NAME texinfo

RUN conda config --add channels jetbrains
RUN mamba install -y -n $ENV_NAME kotlin-jupyter-kernel -c jetbrains

RUN conda clean --all

###############################################################################
# pip - everything we did not find on conda
WORKDIR /tmp
USER root
RUN pip install emu86
RUN pip install jupyter-c-kernel
RUN pip install elm_kernel
RUN pip install gnuplot_kernel

RUN rm -rf ${HOME}/.cache

###############################################################################
# Assembly
WORKDIR /tmp
USER root
RUN python -m kernels.intel.install
RUN     rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# C
WORKDIR /tmp
USER root
RUN install_c_kernel
RUN     rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# Elm
WORKDIR /tmp
USER root
RUN python -m elm_kernel.install
RUN     rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# Gap
WORKDIR /tmp
USER root

ARG GAP_VERSION=4.11.1
ARG Jupyter_Kernel_VERSION=1.3
ENV GAP_DIR=/usr/local/share/gap
ENV GAP=/usr/local/share/gap/bin/gap
ARG GAP_PKG=$GAP_DIR/pkg
ENV PATH=PATH=$GAP_DIR/bin:$GAP_PKG/JupyterKernel-$Jupyter_Kernel_VERSION/bin:$PATH

RUN wget --quiet https://github.com/gap-system/gap/releases/download/v$GAP_VERSION/gap-$GAP_VERSION.tar.gz \
    && tar xfz gap-$GAP_VERSION.tar.gz \
    && mv gap-$GAP_VERSION $GAP_DIR \
    && cd $GAP_DIR \
    && ./configure; make \
    && bin/BuildPackages.sh --with-gaproot=$GAP_DIR \
    && ln -s $GAP_DIR/bin/gap.sh $GAP_DIR/bin/gap \
    && $GAP_DIR/bin/gap --nointeract -c 'LoadPackage("PackageManager");InstallPackage("io",false);InstallPackage("json",false);InstallPackage("zeromqinterface",false);InstallPackage("crypting",false);' \
    && cd $GAP_PKG/JupyterKernel-$Jupyter_Kernel_VERSION \
    && python setup.py install

RUN     rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# Gnuplot
WORKDIR /tmp
USER root
RUN python -m gnuplot_kernel install

RUN     rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# Java
WORKDIR /tmp
USER root

RUN curl -Lo IJava.zip https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip \
    && unzip IJava.zip \
    && python3 install.py --sys-prefix

RUN  rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# JS
WORKDIR /tmp
USER root
RUN conda update -c conda-forge nodejs
RUN    npm install -g --unsafe-perm ijavascript \
    && ijsinstall

RUN     rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# Maxima
WORKDIR /tmp
USER root

ARG MAXIMA_PREFIX=/usr/local/share/maxima
ARG MAXIMA_VERSION=5.45.1
ENV PATH=$MAXIMA_PREFIX/bin/:${PATH}
RUN    mkdir -p $MAXIMA_PREFIX \
    && ulimit -s 16384 \
    && curl -L https://sourceforge.net/projects/maxima/files/Maxima-source/$MAXIMA_VERSION-source/maxima-$MAXIMA_VERSION.tar.gz | tar -C /tmp -xzf - \
    && cd /tmp/maxima-$MAXIMA_VERSION \
    && CFLAGS="-Os" ./configure --prefix=$MAXIMA_PREFIX --enable-sbcl \
    && make \
    && make install

RUN    curl -kLO https://beta.quicklisp.org/quicklisp.lisp \
    && mkdir quicklisp \
    && sbcl --non-interactive --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" --eval "(ql-util:without-prompting (ql:add-to-init-file))"
RUN    git clone https://github.com/robert-dodier/maxima-jupyter \
    && cd maxima-jupyter && maxima --batch-string="load(\"load-maxima-jupyter.lisp\");jupyter_install();"

RUN     rm -rf /tmp/* \
     && fix-permissions "${HOME}"

###############################################################################
# Perl
WORKDIR /tmp
USER root
COPY cpanfile /tmp/cpanfile
RUN cpanm --notest --installdeps . \
    && cpanm Devel::IPerl \
    && iperl --help
RUN    rm -rf /tmp/* \
    && fix-permissions "${HOME}"

###############################################################################
# Raku
WORKDIR /tmp
USER root
ARG RAKU_INSTALL_DIR=/usr/local/share/rakudo-star
ENV PATH=$RAKU_INSTALL_DIR/bin/:$RAKU_INSTALL_DIR/share/perl6/site/bin:$RAKU_INSTALL_DIR/share/perl6/vendor/bin:$RAKU_INSTALL_DIR/share/perl6/core/bin:${PATH}
RUN    mkdir $RAKU_INSTALL_DIR \
    && cd $RAKU_INSTALL_DIR \
    && curl -LJO https://rakudo.org/latest/star/src \
    && tar -xzf rakudo-star-*.tar.gz \
    && mv rakudo-star-*/* .  \
    && rm -fr rakudo-star-*  \
    && ./bin/rstar install \
    && zef install Jupyter::Kernel \
    && jupyter-kernel.raku --generate-config \
    && zef install Physics::Measure Physics::Unit Physics::Constants SVG::Plot::Pie Metropolis Telemetry Log::Async Test::Fuzz

RUN    rm -rf /tmp/* \
    && fix-permissions "${HOME}"

###############################################################################
# Ruby
WORKDIR /tmp
USER root
RUN    gem install ffi-rzmq \
    && gem install iruby --pre \
    && iruby register

RUN    rm -rf /tmp/* \
    && fix-permissions "${HOME}"

###############################################################################
# Rust
WORKDIR "${HOME}"
USER "${NB_UID}"
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && source $HOME/.cargo/env \
    && cargo install evcxr_jupyter --no-default-features \
    && evcxr_jupyter --install

RUN    rm -rf /tmp/* \
    && fix-permissions "${HOME}"

###############################################################################
# Logos
WORKDIR /tmp
USER root
RUN git clone https://github.com/rcmlz/edu-binder-env
WORKDIR /tmp/edu-binder-env/ressources
RUN cp assembler/logo-* $HOME/.local/share/jupyter/kernels/intel/
RUN cp c/logo-* $HOME/.local/share/jupyter/kernels/c/
RUN cp raku/logo-* $HOME/.local/share/jupyter/kernels/raku/

RUN cp bash/logo-* /opt/conda/share/jupyter/kernels/bash/
RUN cp java/logo-* /opt/conda/share/jupyter/kernels/java/

RUN cp elm/logo-* /usr/local/share/jupyter/kernels/elm/
RUN cp coq/logo-* /usr/local/share/jupyter/kernels/coq/

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
