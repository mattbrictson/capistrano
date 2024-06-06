require "open3"
require_relative "docker_gateway"

module RemoteSSHHelpers
  extend self

  class RemoteSSHCommandError < RuntimeError; end

  def start_ssh_server
    docker_gateway.start
  end

  def run_remote_ssh_command(command)
    stdout, stderr, status = docker_gateway.run_shell_command(command)
    return [stdout, stderr] if status.success?
    raise RemoteSSHCommandError, status
  end

  def docker_gateway
    @docker_gateway ||= DockerGateway.new(method(:log))
  end
end

World(RemoteSSHHelpers)
