In this step we will be creating the actual rule used by the underlying [Coraza engine](https://coraza.io/).

## Yaml configuration example

Here a concise example configuration file:

```yaml
## We dont host wordpress so block bots attempting to fetch wp-login.php
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

See the highlighted line above, matches the `inband_rules`{{}} in the configuration file.

* `description: "Detect bots attempting wordpress login page"`{{}}: This is a description of the rule, it can be anything you want, however, it is recommended to provide a description so you know what the rule is doing.

* `rules:`{{}}: This is the start of the rules section, this is where you can define our own DSL rules.

We are writing a basic rule that will block any request that contains `wp-login.php`{{}} within the URI. I will break down the rule below:

* `and|or:`{{}}: This is the start of the rule, it is required to state the modifier for each rules. This is the logical operator that will be used to evaluate the rules. In this case, we are using `and`{{}} which means that all conditions must be met for the rule to match.

[You can read more on SecLang chain rules](https://coraza.io/docs/seclang/actions/#chain)

* `- zones: - URI`{{}}: This is the start of the zone section, this is where you can define which zones you want to match against. In this case, we are matching against the `URI`{{}} zone. You can define multiple zones within a rule.

Within our DSL we have abstracted the SecLang zones into a more human readable format. You can see our list of supported zones [here](https://docs.crowdsec.net/docs/next/appsec/rules_syntax#target).

* `match:`{{}}: This is the start of the match section, this is where you can define which type of match you want to use. In this case, we are using `contains`{{}} which means that the value must be contained within the zone.

Within our DSL we have abstracted the SecLang operator types into a more human readable format. You can see our list of supported match types [here](https://docs.crowdsec.net/docs/next/appsec/rules_syntax#match).

Lets create our rule using the below snippet:

```
cat > /etc/crowdsec/appsec-rules/my_rule.yaml << EOF
## We dont host wordpress so block bots attempting to fetch wp-login.php
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

If you would like to see the generate SecLang rule you can run `cscli appsec-rules inspect my/rule`{{execute T1}} and see the rule within the `Modsecurity Format`{{}} section.