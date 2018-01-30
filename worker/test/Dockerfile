#
FROM camhd_motion_analysis_rq_worker_base:latest
MAINTAINER Aaron Marburg <amarburg@apl.washington.edu>

## Uses a local copy of the source code.  Expects to be in directory ./camhd-motion-analysis
#
#
ADD camhd-motion-analysis /code/camhd_motion_analysis
WORKDIR /code/camhd_motion_analysis

RUN git submodule init && git submodule update
RUN ./fips set config linux-make-release
RUN ./fips build

RUN ./fips make install

VOLUME /output/CamHD_motion_metadata

ENTRYPOINT ["/code/camhd_motion_analysis/launch_worker.sh"]
