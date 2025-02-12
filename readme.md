# Reverse Shell on Remote Machines

Sets up a reverse shell on remote machines, using an AWS internet accessible jump host.

Mainly for AWS Sagemaker notebooks.

## Setup

### Create Sagemaker Code Editor and obtain key fingerprint

First, create an AWS Sagemaker notebook instance.

Then, run the following and note the key fingerprint:

```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N '' -q && cat ~/.ssh/id_ed25519.pub
```

### Setup AWS EC2 Jump Host

Create an AWS EC2 instance, which will be used as the jump host. Note the public DNS hostname.

Under Security Groups, add a rule allowing inbound TCP traffic on port 9999.

Connect to the AWS EC2 instance and add the key fingerprint above to `~/.ssh/authorized_keys`.

Run the following to allow SSH to open remotely accessible listening ports on the jump host:

```sh
echo "GatewayPorts clientspecified" | sudo tee /etc/ssh/sshd_config.d/10-gateway-ports.conf
```

### Setup Reverse Shell

If necessary, edit the environment variables in `setup.sh` appropriately.

Now, we can setup the reverse shell. Run the following on the Sagemaker Code Editor:

```sh
curl https://raw.githubusercontent.com/extrange/reverse-shell/main/setup.sh | bash
```

### Misc

To setup a convenient host alias and execute Starship automatically, add `.ssh/ssh-config` on the local host (your computer). You can then do `ssh hcc` on your computer.