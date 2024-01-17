In this step, we will create the configuration file for the CrowdSec AppSec Component.

## Yaml configuration example

Here a concise example configuration file:

```yaml
name: my/rules
default_remediation: ban
inband_rules:
 - my/rule
```{{}}

* `name: my/rules`{{}}: This is the name of the configuration, it can be anything you want, however, it must match what you defined within the acquisition file. If you change the name here, you must also change it in the acquisition file.

```yaml{3}
source: appsec
name: myappsec
appsec_config: my/rules
listen_addr: 127.0.0.1:4242
labels:
  type: appsec
```{{}}

See the highlighted line above, it matches the `name`{{}} in the configuration file.

* `default_remediation: ban|captcha|log`{{}}: This is the default remediation that will be used when a inband rule matches. In this case, we are going to provide the ban template which will block the request. It is important to note that this does not mean the requesting IP address is banned, it means that the request is blocked.

* `inband_rules: - my/rule`{{}}: This is a list of rule names that we want to load. In this case, we are going to create one from scratch called `my/rule`{{}}.

Let's create our configuration file using the below snippet:

```
cat > /etc/crowdsec/appsec-configs/my_rules.yaml << EOF
name: my/rules
default_remediation: ban
inband_rules:
 - my/rule
EOF
```{{execute T1}}

There are [additional configuration options](https://docs.crowdsec.net/docs/next/appsec/configuration) that can be used, but we will not cover them in this workshop. However, a key concept that we will be covering is inband vs outofband rules.

## Inband vs Outofband Rules

Both rules are loaded into the CrowdSec AppSec Component if supplied, however, they behave differently.

Inband rules are disruptive, this means that when a rule matches, the remediation component will be informed to act on the remediation.

Outofband rules are not disruptive, this means that when a rule matches the request will always be allowed**. This is useful for rules that you want to create an alert for, but not create a disruption.

In the next section we will create our first rule using standard seclang format and then we will create a rule again using the CrowdSec AppSec Rule Language.

**Within the codebase Outofband rules can **never** become disruptive because by the time the outofband is evaluated, the remediation component has already been informed to disrupt or not.
