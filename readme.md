# Reverse Shell on Remote Machines

Sets up a reverse shell on remote machines, using an AWS internet accessible jump host.

Mainly for AWS Sagemaker notebooks.


```sh
curl https://raw.githubusercontent.com/extrange/reverse-shell/main/setup.sh | bash
```

To setup a convenient host alias and execute Starship automatically, add `.ssh/ssh-config` on the local host (your computer).

To configure both staging and production accounts, copy `~/.aws/config` to the same path on the remote host.