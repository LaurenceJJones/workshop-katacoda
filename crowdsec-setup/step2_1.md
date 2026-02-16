## Install Bash Completion

If you want faster and easier access to all options, install bash completion:

`cscli completion bash | tee /etc/bash_completion.d/cscli`{{execute T1}}

`source ~/.bashrc`{{execute T1}}

Test it out by typing: 

`cscli <TAB x 2>`{{}}

## Cscli syntax

Let's check out and run some useful commands with the CrowdSec CLI `cscli`{{}}.

To get an overview of all options, run:

`cscli -h`{{execute T1}}

`cscli` commands are designed to be self-explanatory. The syntax is:

`cscli <command> <subcommand>`{{}}

Example `cscli parsers list`{{exec}} lists all locally installed parsers, however, if you wish to get all information for a command/subcommand you can apply `-h`{{}} flag.

`cscli parsers list -h`{{exec}}

## Collections examples

Here are a few collection examples to get you used to the syntax. The collections command is commonly used because it lets you update parsers/scenarios with one command.

`cscli collections list`{{exec}} List local install collections

`cscli collections list  -a`{{exec}} list ALL available collections

`cscli collections install crowdsecurity/iptables`{{exec}} install a collection

`cscli collections upgrade crowdsecurity/iptables`{{exec}} upgrade a collection

`cscli collections upgrade -a`{{exec}} upgrade ALL installed collections

## Handling decisions

Whilst working with crowdsec there may come a time when you need to add or remove decisions.

Add manual decision

`cscli decisions add --ip 1.2.3.4`{{exec}}

Delete a decision

`cscli decisions list`{{exec}}

`cscli decisions delete --id #`

Delete a decision by ip

`cscli decisions delete --ip 1.2.3.4`{{exec}}
