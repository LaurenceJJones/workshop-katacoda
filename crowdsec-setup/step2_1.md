Let's check out and run some useful commands with the CrowdSec CLI `cscli`{{}}.

To get an overview of all options, just run the command:

`cscli -h`{{execute T1}}

If you want to access all options easier and faster, just install the bash completion:

`cscli completion bash | tee /etc/bash_completion.d/cscli`{{execute T1}}

`source ~/.bashrc`{{execute T1}}

Test it out by typing: 

`cscli <TAB x 2>`{{}}

## Cscli syntax

Cscli commands are built to be self expressive the syntax is

`cscli <command> <subcommand>`{{}}

So for example `cscli parsers list`{{exec}}. Lists all locally installed parsers, however, if you wish to get all information for a command/subcommand you can apply `-h`{{}} flag. `cscli parsers list -h`{{exec}}

## Collections examples

Here a few collection examples to get you used to the syntax

`echo -e "List local installed collections\n" && cscli collections list`{{exec}}

`echo -e "List ALL available collections\n" && cscli collections list  -a`{{exec}}

`cscli collections install crowdsecurity/iptables`{{exec}}

`cscli collections upgrade crowdsecurity/iptables`{{exec}}

`cscli collections upgrade -a`{{exec}}