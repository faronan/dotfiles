# AWS CLI completion via aws_completer
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
complete -c aws -f -a '(begin; set -lx COMP_SHELL fish; set -lx COMP_LINE (commandline); aws_completer | string trim; end)'
