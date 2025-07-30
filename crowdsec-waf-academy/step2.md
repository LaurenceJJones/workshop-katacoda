Now that crowdsec is up and running, we can configure the WAF.

First, we'll need to install some rules to detect malicious traffic.

In this section, we will be using virtual patching rules: rules that detect specific vulnerabilities with a low-to-none false positive rate.

`cscli collections install crowdsecurity/appsec-virtual-patching`{{execute T1}}

Now that we have installed the collection, we can inspect it to see its content:

`cscli collections inspect crowdsecurity/appsec-virtual-patching`{{execute T1}}

As you can see, the collection comes with various rules, appsec configs, parsers and scenarios.

Let's have a look at the default appsec config:

`cat /etc/crowdsec/appsec-configs/appsec-default.yaml`{{execute T1}}

The config tells the Security Engine to load the various WAF rules.

Let's have a look at a specific rule, `crowdsecurity/vpatch-env-access`:

`cat /etc/crowdsec/appsec-rules/vpatch-env-access.yaml`{{execute T1}}

This rule will block any requests that ends with `.env`.

Final step is to tell the Security Engine to load the appsec-config.

To do so, we need to create a new acquisition configuration file:

```
cat > /etc/crowdsec/acquis.d/appsec.yaml << EOF
source: appsec
appsec_config: crowdsecurity/appsec-default
labels:
  type: appsec
EOF
```{{execute T1}}

Finally, simply restart crowdsec:

`systemctl restart crowdsec`{{execute T1}}