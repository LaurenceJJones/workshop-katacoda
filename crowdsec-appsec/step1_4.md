# Step 3 Configuration File

In this step, we will create the configuration file for the CrowdSec AppSec Component.

## Yaml configuration example

Here an example concise configuration example

```yaml
name: my/rules
default_remediation: ban
inband_rules:
 - my/rule
```{{}}

* `name: my/rules`{{}}: This is the name of the configuration, it can be anything you want. This must match what you define within the acquisition file. If you change the name here, you must also change it in the acquisition file.

* `default_remediation: ban|captcha`{{}}: This is the default remediation that will be used when a rule matches. In this case, we are going to provide the ban template which will block the request. It is important to note that this does not mean the IP address is banned, it means that the request is blocked.

* `inband_rules: - my/rule`{{}}: This is list of rule names that we want to load. In this case, we are going to create one from scratch called `my/rule`{{}}. It is important to note the inband rules are disruptive and will block the request.

Lets create our configuration file using the below snippet:

```
cat > /etc/crowdsec/appsec-configs/my_rules.yaml << EOF
name: my/rules
default_remediation: ban
inband_rules:
 - my/rule
EOF
```{{execute T1}}

There are additional configuration options that can be used, but we will not cover them in this workshop. However, a key concept that we will be covering is inband vs outofband rules.

## Inband vs Outofband Rules

Inband rules are rules that are loaded into the CrowdSec AppSec Component and are disruptive. This means that when a rule matches, the request will be blocked. This is useful for rules that you want to block the request.

Outofband rules are rules that are loaded into the CrowdSec AppSec Component and are not disruptive. This means that when a rule matches, the request will not be blocked. This is useful for rules that you want to create an alert for, but not block the request. Rules that take a long time to process should be outofband rules.

In the next section we will create a rule our first rule using standard seclang format and then we will create a rule using the CrowdSec AppSec Rule Language.