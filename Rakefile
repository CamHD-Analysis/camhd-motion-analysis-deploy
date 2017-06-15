
## Todo.
# Change Docker entyrpoint to script which (optionally) checks for destinations
# TODO. Check for existence of files in injector

require 'bundler'
require 'dotenv'


task :base_image do
  chdir "docker/" do
    sh "docker build --tag camhd_motion_analysis_rq_worker_base:latest --tag camhd_motion_analysis_rq_worker_base:#{`git rev-parse --short HEAD`.chomp} --file Dockerfile_rq_base ."
  end
end

namespace :test do

  ## Test image needs to be build in current directory to access the camhd_motion_analysis submodule
  task :build => :base_image do
    Dotenv.load('test.env')
    sh "git submodule update --init --recursive camhd_motion_analysis"
    sh "docker build --tag camhd_motion_analysis_rq_worker:test " \
                "--file docker/Dockerfile_rq_test ."
  end

  task :launch do
    sh "docker run --rm "\
            "--env-file test.env " \
            "--volume /home/aaron/canine/camhd_analysis/CamHD_motion_metadata:/output/CamHD_motion_metadata"\
            " camhd_motion_analysis_rq_worker:test  --log INFO"
  end

  task :inject do
    sh "git init camhd_motion_analysis && git update camhd_motion_analysis"
    Dotenv.load('test.env')

    chdir "camhd_motion_analysis" do
      sh "python3 /rq_client.py --redis-url #{redis_url} " \
      " --threads 16 " \
      " --output-dir /output/CamHD_motion_metadata /RS03ASHS/PN03B/06-CAMHDA301/2016/01/01/CAMHDA301-20160101T180000Z.mov"
    end
  end


  namespace :swarm do

    task :push do
      sh "docker tag camhd_motion_analysis_rq_worker:test 127.0.0.1:5000/camhd_motion_analysis_rq_worker:test"
      sh "docker push 127.0.0.1:5000/camhd_motion_analysis_rq_worker:test"
    end

    task :launch do
      sh "docker service create" \
      " --name test_worker" \
      " --network lazycache_nocache_default" \
      " --mount type=bind,source=/auto/canine/aaron/camhd_analysis/CamHD_motion_metadata,destination=/output/CamHD_motion_metadata "\
      " 127.0.0.1:5000/camhd_motion_analysis_rq_worker:test"\
      " --redis-url #{redis_url} --log INFO"
    end

    task :update do
      sh "docker service update --force test_worker"
    end

    task :inject do
      chdir "python" do
        sh "python3 ./rq_client.py --redis-url #{redis_url} " \
        " --threads 16 " \
        " --lazycache-url http://lazycache_nocache:8080/v1/org/oceanobservatories/rawdata/files/" \
        " --output-dir /output/CamHD_motion_metadata /RS03ASHS/PN03B/06-CAMHDA301/2016/01/01/CAMHDA301-20160101T090000Z.mov"
      end
    end
  end


end




namespace :prod do

  task :build => :base_image do
    chdir "docker/" do
      sh "docker build --no-cache "\
            " --tag camhd_motion_analysis_rq_worker:latest " \
            " --tag camhd_motion_analysis_rq_worker:#{`git rev-parse --short HEAD`.chomp} "\
            " --file Dockerfile_rq_prod ."
    end
  end

  task :push do
    sh "docker tag camhd_motion_analysis_rq_worker:latest amarburg/camhd_motion_analysis_rq_worker:latest"
    sh "docker push amarburg/camhd_motion_analysis_rq_worker:latest"
  end

  task :inject do
    Dotenv.load('prod.env')
    sh "docker run --rm --env-file ./prod.env "\
            " --entrypoint python3 "\
            " --network lazycache" \
            " amarburg/camhd_motion_analysis_rq_worker:latest"\
            " /code/camhd_motion_analysis/python/rq_client.py " \
            " --threads 16 " \
            " --lazycache-url http://lazycache_nocache:8080/v1/org/oceanobservatories/rawdata/files/" \
            " --output-dir /output/CamHD_motion_metadata"\
            " /RS03ASHS/PN03B/06-CAMHDA301/2016/01/01/"
  end
end

#
#     task :launch do
#       throw "Can't find prod.env" unless File.exists? "prod.env"
#       sh "docker run --detach --env-file prod.env --volume /output/CamHD_motion_metadata:/home/aaron/canine/camhd_analysis/CamHD_motion_metadata/ camhd_motion_analysis_rq_worker:latest"
#     end
#
#     namespace :swarm do
#
#       worker_name = "worker"
#
#       task :launch do
#
#         throw "Can't find prod.env" unless File.exists? "prod.env"
#
#         sh "docker service create" \
#         " --name #{worker_name}" \
#         " --env-file ./prod.env" \
#         " --network lazycache" \
#         " --mount type=bind,source=/auto/canine/aaron/camhd_analysis/CamHD_motion_metadata,destination=/output/CamHD_motion_metadata "\
#         " amarburg/camhd_motion_analysis_rq_worker:latest"\
#         " --log INFO"
#       end
#
#       task :update => "rq:prod:push" do
#         sh "docker service update --force #{worker_name}"
#       end
#
#       task :inject do
#         sh "docker run --rm --env-file ./prod.env "\
#         " --entrypoint python3 "\
#         " --network lazycache" \
#         " amarburg/camhd_motion_analysis_rq_worker:latest"\
#         " /code/camhd_motion_analysis/python/rq_client.py " \
#         " --threads 16 " \
#         " --lazycache-url http://lazycache_nocache:8080/v1/org/oceanobservatories/rawdata/files/" \
#         " --output-dir /output/CamHD_motion_metadata"\
#         " /RS03ASHS/PN03B/06-CAMHDA301/2016/01/"
#       end
#     end
#
#   end
#
# end
