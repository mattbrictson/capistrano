require "open3"

module VagrantHelpers
  extend self

  class VagrantSSHCommandError < RuntimeError; end

  at_exit do
    if ENV["KEEP_RUNNING"]
      puts "KEEP_RUNNING is no longer supported"
    end

    vagrant_down
  end

  def vagrant_down
    puts "[docker] compose down"
    # updated to explicitly use bash. I don't know if vagrant was giving us a bash session before, but
    # I was having trouble getting inline evaluations to work without using bash. But if we can modify the evalulation
    # commands to work without bash, then we don't need to use it here
    stdout, stderr, status = Open3.capture3("docker compose down")

    (stdout + stderr).each_line { |line| puts "[docker] #{line}" }

    [stdout, stderr, status]
  end

  def vagrant_up
    puts "[docker] compose up"
    # updated to explicitly use bash. I don't know if vagrant was giving us a bash session before, but
    # I was having trouble getting inline evaluations to work without using bash. But if we can modify the evalulation
    # commands to work without bash, then we don't need to use it here
    stdout, stderr, status = Open3.capture3("docker compose up -d")

    (stdout + stderr).each_line { |line| puts "[docker] #{line}" }

    [stdout, stderr, status]
  end

  def vagrant_cli_command(command)
    puts "[docker] #{command}"
    # updated to explicitly use bash. I don't know if vagrant was giving us a bash session before, but
    # I was having trouble getting inline evaluations to work without using bash. But if we can modify the evalulation
    # commands to work without bash, then we don't need to use it here
    stdout, stderr, status = Open3.capture3("docker compose exec ssh_server /bin/bash -c #{command.shellescape}")

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
