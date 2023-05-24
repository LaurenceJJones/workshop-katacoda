![CrowdSec Logo](./assets/logo_crowdsec.png)

## CrowdSec is a free, open-source and collaborative IPS.

In this workshop, you will learn how to setup CrowdSec, Bouncers and working with CSCLI tool.
It will explain the essential aspects and the design decisions that you need to be aware of.

### Crowdsec Taxonomy

Word | Description
---|---
Signal | Local information on a given attack
LAPI | Local API. Used to control the various elements of the CrowdSec stack locally
CAPI | Gets blocklists from community, sends signals to smoke Database
Security Engine | Does all parsing of logs, controlling bouncers and communicating with CAPI
Remediation Component | IPS part of CrowdSec. Mitigates risks by ‘blocking’ malicious traffic
Parser | Parses logs. Written in YAML and GROK
Scenario |Describes the attack we want to react upon
Collection | Collection of parsers and/or scenarios for one system or use case
Postoverflow | Action to execute when a given scenario has been triggered
Decision | Is generated when a scenario is triggered.
Alert | Decisions are transformed into alerts based on local preferences (e.g. a 4h ban).
