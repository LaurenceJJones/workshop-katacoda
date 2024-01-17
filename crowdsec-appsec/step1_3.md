Since we are creating the configuration from scratch we must create the directories that will hold the files.

If you use any of the official AppSec collections from the [Hub](https://hub.crowdsec.net) then you will not need to create these directories as they will be created for you upon installation.

### Creating the configuration directories

Let's run the following command to create the directories:

`mkdir -p /etc/crowdsec/appsec-{rules,configs}`{{execute T1}}

We use some bash magic (brace expansion) to create the directories in one command.

#### Rules Directory

The `appsec-rules`{{}} directory is where we will store the rules that we want to use to protect our web applications. Think of this as the rules that you would use in a WAF.

#### Configs Directory

The `appsec-configs`{{}} directory is where we will store the configuration files for the CrowdSec AppSec Component. These files instruct the component how to behave and which rules to load as you may want to load different rules for different applications.

We will be creating a file called `my_rules.yaml`{{}} in the `appsec-configs`{{}} directory within the next step.
