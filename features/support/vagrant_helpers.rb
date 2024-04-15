require "open3"

module VagrantHelpers
  extend self

  class VagrantSSHCommandError < RuntimeError; end

  at_exit do
    if ENV["KEEP_RUNNING"]
      puts "Vagrant vm will be left up because KEEP_RUNNING is set."
      puts "Rerun without KEEP_RUNNING set to cleanup the vm."
    else
      vagrant_cli_command("destroy -f")
    end
  end

  def vagrant_cli_command(command)
    puts "[docker] #{command}"
    stdout, stderr, status = Open3.capture3("docker compose exec ssh_server /bin/bash -c #{command}")

    (stdout + stderr).each_line { |line| puts "[docker] #{line}" }

    [stdout, stderr, status]
  end

  def run_vagrant_command(command)
    stdout, stderr, status = vagrant_cli_command(command)
    return [stdout, stderr] if status.success?
    raise VagrantSSHCommandError, status
  end

  def puts(message)
    # Attach log messages to the current cucumber feature (`log`),
    # or simply puts to the console (`super`) if we are outside of cucumber.
    respond_to?(:log) ? log(message) : super(message)
  end
end

World(VagrantHelpers)
