require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'yaml'
module Guard
  class CoffeeDripper < Guard

    attr_accessor :config
    def self.init(guard_name = nil)
      if !File.exist?("config/coffeedripper.yaml")
        puts "Writing new Guardfile to #{Dir.pwd}/config/coffee-dripper.yaml"
        FileUtils.cp(File.expand_path('../coffeedripper/templates/coffee-dripper.yaml', __FILE__), 'config/coffee-dripper.yaml')
      elsif guard_name.nil?
        ::Guard::UI.error "Guardfile already exists at #{Dir.pwd}/config/coffee-dripper.yaml"
        exit 1
      end
    end

    def initialize(watchers=[], options={})
      super
      @watchers, @options = watchers, options
      @options[:output] ||= 'app/coffeescripts/'
      @options[:input] ||= 'app/coffeescripts/'
      @options[:ext] ||= 'bean'
      @options[:config] ||= 'config/coffee-dripper.yaml'
      load_config
    end

    def load_config
      @config = YAML.load_file File.join Dir.pwd, @options[:config]
      return true if @config
      return false
    end

    def change_bean(bean)
      @config.each do |coffee, beans|
        if beans.include? bean
          drip(coffee)
        end
      end
    end

    def drip_all
      puts "Drip Start for All"
      @config.each do |coffee, beans|
        drip(coffee)
      end
    end

    def drip(coffee_script)
      puts "Drip Start for #{coffee_script}"
      beans = @config[coffee_script]
      output = File.join Dir.pwd, @options[:output], coffee_script
      str = ""
      beans.each do |bean|
        str += load_bean(bean)
      end
      write(output, str)
      puts "Drip End #{output}"
    end

    def load_bean(bean)
      str = ""
      input = File.join Dir.pwd, @options[:input], bean
      f = open(input)
      str = f.read
      f.close
      str << "\n"
    end

    def load_coffee(coffee)
      str = ""
      output = File.join Dir.pwd, @options[:output], coffee
      f = open(output)
      str = f.read
      f.close
      return str
    end

    def write(output,str)
      f = File.open(output,'w')
      f.puts str
      f.close
    end
    # =================
    # = Guard methods =
    # =================

    # If one of those methods raise an exception, the Guard::GuardName instance
    # will be removed from the active guards.

    # Called once when Guard starts
    # Please override initialize method to init stuff
    def start
      run_all
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
      true
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    def reload
      load_config
      run_all
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      drip_all
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      paths.each do |bean|
        change_bean(bean.split("/").last)
      end
    end
  end
end
