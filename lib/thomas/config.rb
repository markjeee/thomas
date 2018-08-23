require 'yaml'
require 'erb'

module Thomas
  DEFAULT_CONFIG_PATH = File.join(THOMAS_ROOT_PATH, 'config/thomas.yml')

  class Config < Hash
    def self.load_config
      if File.exist?(config_path)
        self.new.tap { |o| o.load_config(config_path) }
      else
        raise 'Config file %s missing' % config_path
      end
    end

    def self.config_path
      File.expand_path(DEFAULT_CONFIG_PATH)
    end

    def load_config(path = nil)
      new_config = Hash.new

      if !path.nil? && File.exists?(path)
        fcontents = File.read(path)
        config_bind = ConfigBinding.new

        parsed = ERB.new(fcontents).result(config_bind.get_binding)
        data = YAML.load(parsed)

        unless data.nil? || data === false || data.empty?
          new_config.update(data)
        end
      end

      new_config = symbolize_keys(new_config)
      update(deep_merge(new_config))

      self
    end

    def self.symbolize_keys(v)
      Thomas::Helper.symbolize_keys(v)
    end

    def self.simplify_keys(v, to = :string)
      Thomas::Helper.simplify_keys(v, to)
    end

    def simplify_keys(v); self.class.simplify_keys(v); end
    def symbolize_keys(v); self.class.symbolize_keys(v); end

    def finalize_paths(path)
      path = path.gsub(/\$thomas_root/, thomas_root_path)
      path = path.gsub(/\$thomas_working/, thomas_working_path)

      File.expand_path(path)
    end

    def thomas_root_path
      self[:thomas_root] || THOMAS_ROOT_PATH
    end

    def thomas_working_path
      self[:thomas_working] || THOMAS_ROOT_PATH
    end

    def deep_merge(other)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      merge(other, &merger)
    end unless instance_methods.include?(:deep_merge)
  end

  class ConfigBinding
    def get_binding; binding; end
  end
end
