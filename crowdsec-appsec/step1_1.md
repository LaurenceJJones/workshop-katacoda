The AppSec Component was released as a version `1.6.0` and is apart of the main CrowdSec binary. This means that you can install the CrowdSec binary and have the AppSec Component available to you.

This gives us access to the packages:
`curl -s https://install.crowdsec.net/ | sudo sh`{{execute T1}}

Great, now we can install the `CrowdSec Security Engine`{{}}. It allows you to detect bad behaviors by analyzing log files and other data sources.

`apt install crowdsec -y`{{execute T1}}

In the next step we will configure the `CrowdSec AppSec Component`{{}}.
