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
    # updated to explicitly use bash. I don't know if vagrant was giving us a bash session before, but
    # I was having trouble getting inline evaluations to work without using bash. But if we can modify the evalulation
    # commands to work without bash, then we don't need to use it here
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
