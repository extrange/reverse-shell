cd ~
export AWS_PROFILE=staging
complete -C '/usr/local/bin/aws_completer' aws
eval "$(starship init bash)"
