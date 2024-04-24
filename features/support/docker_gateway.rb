module DockerGateway
  def start_gateway
    run_compose_command("up -d")
  end

  def stop_gateway
    run_compose_command("down")
  end

  def run_shell_command(command)
    run_compose_command("exec ssh_server /bin/bash -c #{command.shellescape}")
  end

  # Extracted a DockerGateway to create a stronger distinction between "public" and "private" API methods
  # Since these are all just instance methods on a module, there isn't a Ruby privacy scope
  # Hopefully "run_compose_command" is a good enough clue that this isn't meant to be bled outside of this file
  def run_compose_command(command)
    puts "[docker compose] #{command}"
    # updated to explicitly use bash. I don't know if vagrant was giving us a bash session before, but
    # I was having trouble getting inline evaluations to work without using bash. But if we can modify the evalulation
    # commands to work without bash, then we don't need to use it here
    stdout, stderr, status = Open3.capture3("docker compose #{command}")

    (stdout + stderr).each_line { |line| puts "[docker compose] #{line}" }

    [stdout, stderr, status]
  end

  # The reason DockerGateway is exposed as a module is because of this puts
  # This gives us nice formatting of remote container commands within the cucumber test context
  # This seemed like the simplest way to keep track of the Cucumber runner context while introducing minimal change
  # But maybe there's a better way?
  def puts(message)
    # Attach log messages to the current cucumber feature (`log`),
    # or simply puts to the console (`super`) if we are outside of cucumber.
    respond_to?(:log) ? log(message) : super(message)
  end
end
