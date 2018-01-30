#
FROM camhd_motion_analysis_rq_worker_base:latest
MAINTAINER Aaron Marburg <amarburg@apl.washington.edu>

ADD camhd-motion-analysis /code/camhd_motion_analysis
WORKDIR /code/camhd_motion_analysis

RUN git submodule init && git submodule update
RUN ./fips set config linux-make-release
RUN ./fips build

RUN ./fips make install
RUN ldconfig   ## Weird that I need to run this...

VOLUME /output/CamHD_motion_metadata

ADD launch_worker.sh  /code
ENTRYPOINT ["/code/launch_worker.sh"]
