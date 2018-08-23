require 'docker_task'
require 'thomas_task'

module Thomas
  autoload :Config, 'thomas/config'
  autoload :Helper, 'thomas/helper'
  autoload :Task, 'thomas/task'

  def self.config
    if defined?(@config)
      @config
    else
      @config = Config.load_config
    end
  end

  def self.include_docker_tasks(options = { })
    DockerTask.include_tasks(options)
  end
end
