In this step we will be creating the actual rule used by the underlying [Coraza engine](https://coraza.io/).

## Yaml configuration example

Here is a concise example configuration file:

```yaml
## We don't host wordpress so block bots attempting to fetch wp-login.php
name: my/rule
description: "Detect bots attempting wordpress login page"
rules:
  - and:
    - zones:
      - URI
      match:
        type: contains
        value: "wp-login.php"
```{{}}

* `name: my/rule`{{}}: This is the name of the rule, it can be anything you want, however, it must match what you defined within the configuration file. If you change the name here, you must also change it in the configuration file.

```yaml{4}
name: my/rules
default_remediation: ban
inband_rules:
 - my/rule
```{{}}

See the highlighted line above, it matches the `inband_rules`{{}} in the configuration file.

* `description: "Detect bots attempting wordpress login page"`{{}}: This is the rule description. It can be anything you want, but it is recommended to include one so you know what the rule does.

* `rules:`{{}}: This starts the rules section, where you define your own DSL rules.

We are writing a basic rule that will block any request that contains `wp-login.php`{{}} within the URI. I will break down the rule below:

* `and|or:`{{}}: This starts the rule. You must set an operator for each rule. This logical operator is used to evaluate the rule. In this case, we use `and`{{}}, which means all conditions must match.

[You can read more on SecLang chain rules](https://coraza.io/docs/seclang/actions/#chain)

* `- zones: - URI`{{}}: This starts the zone section, where you define which zones to match. In this case, we match against the `URI`{{}} zone. You can define multiple zones in one rule.

Within our DSL we have abstracted the SecLang zones into a more human readable format. You can see our list of supported zones [here](https://docs.crowdsec.net/docs/next/appsec/rules_syntax#target).

* `match:`{{}}: This starts the match section, where you define the match type. In this case, we use `contains`{{}}, which means the value must be present within the zone.

Within our DSL we have abstracted the SecLang operator types into a more human readable format. You can see our list of supported match types [here](https://docs.crowdsec.net/docs/next/appsec/rules_syntax#match).

Let's create our rule using the below snippet:

```
cat > /etc/crowdsec/appsec-rules/my_rule.yaml << EOF
## We don't host wordpress so block bots attempting to fetch wp-login.php
name: my/rule
description: "Detect bots attempting wordpress login page"
rules:
  - and:
    - zones:
      - URI
      match:
        type: contains
        value: "wp-login.php"
EOF
```{{execute T1}}

If you would like to see the generated SecLang rule, run `cscli appsec-rules inspect my/rule`{{execute T1}} and check the `Modsecurity Format`{{}} section.

Now we can reload CrowdSec service to enable the AppSec component:

```
sudo systemctl restart crowdsec
```{{execute T1}}

We can ensure the AppSec port is connectable by running a simple nc command:

```
nc -zv 127.0.0.1 4242
```{{execute T1}}

In the next section, we will install and configure Nginx to use our new AppSec component.
