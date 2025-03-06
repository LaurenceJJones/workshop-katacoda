![CrowdSec Logo](./assets/logo_crowdsec.png)

## CrowdSec AppSec in Kubernetes Workshop

In this workshop, you will have a ready cluster (same state as you did in [Crowdsec in K8s](https://killercoda.com/iiamloz/scenario/crowdsec-kubernetes) module), you will learn how to add the Crowdsec AppSec (WAF) in this helm deployment and detect/block malicious behaviors using the CrowdSec AppSec.

For the workshop, you will :

1- Verify the Kubernetes cluster state (check if all is up and running)

2- Upgrade the Crowdsec helm chart to add the AppSec component

3- Update the remediation component to enable communication with the AppSec

4- Test the setup with a simple attack


### Crowdsec Taxonomy

Word | Description
---|---
AppSec | CrowdSec Web Application Firewall
Signal | Local information on a given attack
LAPI | Local API. Used to control the various elements of the CrowdSec stack locally
CAPI | Gets blocklists from community, sends signals to smoke Database
Log processor | Does all parsing of logs and communicating with LAPI
Security Engine | Is the stack that contains LAPI and the Log processor
Remediation Component | IPS part of CrowdSec. Mitigates risks by ‘blocking’ malicious traffic
Parser | Parses logs. Written in YAML and GROK
Scenario |Describes the attack we want to react upon
Collection | Collection of parsers and/or scenarios for one system or use case
Postoverflow | Action to execute when a given scenario has been triggered
Decision | Is generated when a scenario is triggered.
Alert | Decisions are transformed into alerts based on local preferences (e.g. a 4h ban).