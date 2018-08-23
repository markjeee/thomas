require 'rake'
require 'rake/task'
require 'rake/tasklib'
require 'docker_task'

module ThomasTask
  class Php5FpmMcrypt < Rake::TaskLib
    include Thomas::Task

    set_config_name :'php5-fpm-mcrypt'
  end
end
