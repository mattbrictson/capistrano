# Ensure Docker container is completely stopped when Ruby exits.
at_exit do
  DockerGateway.new.stop
end

# Manages the Docker-based SSH server that is declared in docker-compose.yml.
class DockerGateway
  def initialize(log_proc=$stderr.method(:puts))
    @log_proc = log_proc
  end

  def start
    run_compose_command("up -d")
  end

  def stop
    run_compose_command("down")
  end

  def run_shell_command(command)
    run_compose_command("exec ssh_server /bin/bash -c #{command.shellescape}")
  end

  private

  def run_compose_command(command)
    log "[docker compose] #{command}"
    # updated to explicitly use bash. I don't know if vagrant was giving us a bash session before, but
    # I was having trouble getting inline evaluations to work without using bash. But if we can modify the evaluation
    # commands to work without bash, then we don't need to use it here
    stdout, stderr, status = Open3.capture3("docker compose #{command}")

    (stdout + stderr).each_line { |line| log "[docker compose] #{line}" }

    [stdout, stderr, status]
  end

  def log(message)
    @log_proc.call(message)
  end
end
