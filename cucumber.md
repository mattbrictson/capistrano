This is meant to help you run the cucumber test suite using an SSH remote running in Docker.

Dependencies:

- Docker

```shell
# chmod privatekey so that it can be used for SSHing
chmod 0600 ssh_key_rsa

# Run the SSHD in a Docker container, detached
docker compose up -d

# Run a test. One that definitely works is below
bundle exec cucumber features/sshconnect.feature
```

Things that need to be fixed still for this to be portable/shippable:

- Fix remaining specs
- Rename/refactor helpers that are Vagrant-specific (maybe outcome should be... don't call them Docker either)
- Bootstrap `docker-compose up` to the test runner (and maybe teardown?)
- Automate permission on the privatekey as part of test runs (0644 to 0600)
- Github actions should be able to do this OK (may require shipping an image to their container registry)
- Split out Dockerfile to its own repo so that it has its own deployment/building workflow in GA