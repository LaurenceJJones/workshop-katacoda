Before we can start, we have to install the preview version of `CrowdSec Security Engine`{{}}. Versions `v1.5.6-*`{{}} are preview versions of `v1.6.0`{{}}.

You can test if you are on a preview version by running `cscli version`{{}} and seeing if it matches the version on [Github](https://github.com/crowdsecurity/crowdsec/releases).

This gives us access to the preview packages:
`curl -s https://install.crowdsec.net/ | sudo sh`{{execute T1}}

Great, now we can install the `CrowdSec Security Engine`{{}}. It allows you to detect bad behaviors by analyzing log files and other data sources.

`apt install crowdsec -y`{{execute T1}}

In the next step we will configure the `CrowdSec AppSec Component`{{}}.
