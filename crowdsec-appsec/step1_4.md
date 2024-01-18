In this step, we will inspect the `crowdsecurity/virtual-patching`{{}} configuration file.

```yaml
name: crowdsecurity/virtual-patching
default_remediation: ban
inband_rules:
 - crowdsecurity/base-config 
 - crowdsecurity/vpatch-*
```{{}}

* `name: crowdsecurity/virtual-patching`{{}}: This is the name of the configuration, it can be anything you want, however, it must match what you defined within the acquisition file. If you change the name here, you must also change it in the acquisition file.

```yaml{3}
source: appsec
name: myappsec
appsec_config: crowdsecurity/virtual-patching
listen_addr: 127.0.0.1:4242
labels:
  type: appsec
```{{}}

See the highlighted line above, it matches the `name`{{}} in the configuration file we configured at the very start of the workshop.

* `default_remediation: ban|captcha|log`{{}}: This is the default remediation that will be used when a inband rule matches. In this case, we are going to provide the ban template which will block the request. It is important to note that this does not mean the requesting IP address is banned, it means that the request is blocked.

* `inband_rules: - crowdsecurity/vpatch-*`{{}}: This is a list of rule names that we want to load. In this case, there is a globing pattern to match all `crowdsecurity/vpatch-*`{{}} rules.

There are [additional configuration options](https://docs.crowdsec.net/docs/next/appsec/configuration) that can be used, but we will not cover them in this workshop.

However, a key concept that we will be covering is inband vs outofband rules and how they behave.

## Inband vs Outofband Rules

Both rules are loaded into the CrowdSec AppSec Component if supplied, however, they behave differently.

Inband rules are disruptive, this means that when a rule matches, the remediation component will be informed to act on the remediation.

Outofband rules are not disruptive, this means that when a rule matches the request will always be allowed**. This is useful for rules that you want to create an alert for, but not create a disruption.

In the next section we will create our first rule using standard seclang format and then we will create a rule again using the CrowdSec AppSec Rule Language.

**Within the codebase Outofband rules can **never** become disruptive because by the time the outofband is evaluated, the remediation component has already been informed to disrupt or not.
