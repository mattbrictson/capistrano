require "open3"
require_relative "docker_gateway"

module RemoteSSHHelpers
  extend self
  include DockerGateway

  class RemoteSSHCommandError < RuntimeError; end

  at_exit do
    # We made available KEEP_RUNNING to allow the same vagrant environment to run between test runs
    # For it to work, we'd drop some files (presumably the equivalent to a temporary volume) between test runs
    # to avoid test pollution
    # An equivalent for Docker would be to stop the container and run `docker compose rm`
    # But since that requires a stop and start of the container, we'd lose time savings, so I'm not sure this can be
    # supported as elegantly as before
    # Another way we could do this is to remove parts of the filesystem that the tests create, which would add some
    # complexity here.
    if ENV["KEEP_RUNNING"]
      puts "KEEP_RUNNING is no longer supported"
    end

    stop_ssh_server
  end

  def stop_ssh_server
    stop_gateway
  end

  def start_ssh_server
    start_gateway
  end

  def run_remote_ssh_command(command)
    stdout, stderr, status = run_shell_command(command)
    return [stdout, stderr] if status.success?
    raise RemoteSSHCommandError, status
  end
end

World(RemoteSSHHelpers)
