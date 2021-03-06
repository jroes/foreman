require "foreman/export"
require "foreman/utils"

class Foreman::Export::Base

  attr_reader :location, :engine, :app, :log, :port, :user, :template, :concurrency

  def initialize(location, engine, options={})
    @location    = location
    @engine      = engine
    @app         = options[:app]
    @log         = options[:log]
    @port        = options[:port]
    @user        = options[:user]
    @template    = options[:template]
    @concurrency = Foreman::Utils.parse_concurrency(options[:concurrency])
  end

  def export
    raise "export method must be overridden"
  end

private ######################################################################

  def error(message)
    raise Foreman::Export::Exception.new(message)
  end

  def say(message)
    puts "[foreman export] %s" % message
  end

  def export_template(exporter, file, template_root)
    if template_root && File.exist?(file_path = File.join(template_root, file))
      File.read(file_path)
    elsif File.exist?(file_path = File.expand_path(File.join("~/.foreman/templates", file)))
      File.read(file_path)
    else
      File.read(File.expand_path("../../../../data/export/#{exporter}/#{file}", __FILE__))
    end
  end

  def write_file(filename, contents)
    say "writing: #{filename}"

    File.open(filename, "w") do |file|
      file.puts contents
    end
  end

end
