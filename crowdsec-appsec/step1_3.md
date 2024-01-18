Before diving into the breakdown of the laravel debug rule, let's take a look at the directory structure of the CrowdSec AppSec Component.

```
ls -la /etc/crowdsec | grep appsec
```{{execute T1}}

#### Configs Directory

The `appsec-configs`{{}} directory is where we will store the configuration files for the CrowdSec AppSec Component. These files instruct the component how to behave and which rules to load as you may want to load different rules for different applications.

#### Rules Directory

The `appsec-rules`{{}} directory is where we will store the rules that we want to use to protect our web applications. Think of this as the rules that you would use in a WAF.

### Laravel Debug Rule

Let's take a look at the laravel debug rule:

```yaml
name: crowdsecurity/vpatch-laravel-debug-mode
description: "Detect bots exploiting laravel debug mode"
#see https://github.com/s1miii/cape/blob/main/ler.py : bot is trying to trigger a debug log to extract secrets.
rules:
  - and:
    - zones:
      - METHOD
      match:
        type: equals
        value: POST
    - zones:
        - BODY_ARGS_NAMES
      transform:
        - lowercase
      match:
        type: equals
        value: "0x[]"
labels:
...
```{{}}

We are going to ignore the `labels`{{}} section for now as I want to focus on the top section.

* `name: crowdsecurity/vpatch-laravel-debug-mode`{{}}: This is the name of the rule, it can be anything you want, however, it must match what you defined within the `AppSec`{{}} configuration file (This will be explained later in workshop). If you change the name here, you must also change it in the configuration file.

* `description: "Detect bots exploiting laravel debug mode"`{{}}: This is a description of the rule, it can be anything you want, however, it is recommended to provide a description so you know what the rule is doing.

* `rules:`{{}}: This is the start of the rules section, this is where you can define our own DSL rules.

* `- and|or:`{{}}: This is the start of the rule, it is required to state the modifier for each rules. This is the logical operator that will be used to evaluate the rules. In this case, we are using `and`{{}} which means that all conditions must be met for the rule to match.

[You can read more on SecLang chain rules](https://coraza.io/docs/seclang/actions/#chain)

* `- zones: - METHOD`{{}}: This is the start of the zone section, this is where you can define which zones you want to match against. In this case, we are matching against the `METHOD`{{}} zone. You can define multiple zones within a rule.

Within our DSL we have abstracted the SecLang zones into a more human readable format. You can see our list of supported zones [here](https://docs.crowdsec.net/docs/next/appsec/rules_syntax#target).

* `match:`{{}}: This is the start of the match section, this is where you can define which type of match you want to use. In this case, we are using `equals`{{}} which means that the value must be an exact match the zone.

Within our DSL we have abstracted the SecLang operator types into a more human readable format. You can see our list of supported match types [here](https://docs.crowdsec.net/docs/next/appsec/rules_syntax#match).

If you would like to see the generate SecLang rule you can run `cscli appsec-rules inspect crowdsecurity/vpatch-laravel-debug-mode`{{execute T1}} and see the rule within the `Modsecurity Format`{{}} section.

In the next section we will look into the `AppSec`{{}} configuration file and how it loads the rules.