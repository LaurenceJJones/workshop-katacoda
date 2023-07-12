## High level overview

We are going to take a high-level overview of the parsing stages CrowdSec takes when processing a log.

The concept of stages is central to data parsing in CrowdSec, as it allows to have various "steps" of parsing. All parsers belong to a given stage. While users can add or modify the stages order, the following stages exist:

- `s00-raw`{{}}: low-level parser, such as syslog
- `s01-parse`{{}}: most of the services' parsers (ssh, nginx, etc.)
- `s02-enrich`{{}}: enrichment that requires parsed events (ie. geoip-enrichment) or generic parsers that apply on parsed logs (ie. second stage HTTP parser)

Every event starts in the first stage, and moves to the next stage once it has been successfully processed by a parser that has the onsuccess directive set to `next_stage`{{}}, and so on until it reaches the last stage when it's going to start to be matched against scenarios. Thus an sshd log might follow this pipeline:

- `s00-raw`{{}}: parsed by crowdsecurity/syslog-logs (will move the event to the next stage)
- `s01-parse`{{}}: parsed by crowdsecurity/sshd-logs (will move the event to the next stage)
- `s02-enrich`{{}}: parsed by crowdsecurity/geoip-enrich and crowdsecurity/dateparse-enrich

Please click check to continue to the next step, if you get a validation error, CrowSec is not yet installed wait a few seconds and try again.