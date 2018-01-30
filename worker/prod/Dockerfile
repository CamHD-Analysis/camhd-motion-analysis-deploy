#
FROM camhd_motion_analysis_rq_worker_base:latest

WORKDIR /code
RUN git clone --branch fips https://github.com/CamHD-Analysis/camhd_motion_analysis.git

WORKDIR /code/camhd_motion_analysis

RUN git submodule init && git submodule update
RUN ./fips set config linux-make-release
RUN ./fips build

RUN ./fips make install

VOLUME /output/CamHD_motion_metadata

ENTRYPOINT ["/code/camhd_motion_analysis/launch_worker.sh"]
