## Scenario

You are a newly employed SOC analyst at Blueteam INC. You have been tasked with investigating a breach at Mary's Farm. You will use the ELK stack to analyze logs. Your manager has asked you to investigate the breach and determine the initial point of compromise. Your report must include:

- The initial compromised location
    - Include metadata about the attack
- The attacker IP address
    - Use OSINT to determine the attacker (CN, ASN, etc)
- Did the attacker gain access via ssh?
    - If so, how?
    - Do you believe they could still have access?

You can copy the points above and use them as a guide for your report.
## Introduction to the breach

Mary's Farm reached out after being contacted by a hacker who claims to have breached their network and stolen confidential data. The attacker provided a sample to prove the breach. Mary's Farm informed us that the sample data **MUST** have come from their WordPress eCommerce site. The attacker has threatened to release the data publicly unless they are paid a 1 Bitcoin ransom.

Mary's Farm will not pay the ransom and has asked us to investigate the breach. Our team has exported their web server, firewall, and SSH logs.

We will use a pre-configured ELK stack that has already been set up for us.

## Accessing the ELK stack

The ELK stack is available at [URL]({{TRAFFIC_HOST1_5601}}).

The ELK stack has been configured with the following credentials:
- user: elastic
- password: crowdsec

**The setup can take some time. If you get 502 gateway errors, wait a few minutes and try again.**
