# Clique Developer Tools

For easier access to Clique running on your Docker it is recommended to install
the Clique developer tools.

This allows the following conveniences:

```bash
$ clq console
$ clq log

# Also some convenient shortcuts for interacting with the docker itself:
$ clq up           # bring docker up
$ clq halt         # or take it down
$ clq pristine     # or totally destroy it and set up a fresh one
$ clq ssh          # SSH into your VM
$ clq ssh pwd      # or run an arbitrary shell command on the VM
$ clq guard        # start guard
```

## Installation

```bash
cd docker/dev-tools
chmod +x install
./install
```

## Troubleshooting

Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/containers/json: dial unix /var/run/docker.sock: connect: permission denied

Create the docker group.

```bash
sudo groupadd docker
```

Add your user to the docker group.

```bash
sudo usermod -aG docker ${USER}
```

Type the following command to re-evaluated the groups.

```bash
su -s ${USER}
```

Verify that you can run docker commands without sudo.

```bash
docker run hello-world
```

If it doesn't work try to restart your computer.

```bash
reboot
```
