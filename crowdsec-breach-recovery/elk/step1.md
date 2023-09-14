## Scenario

You are a newly employed SOC analyst at Blueteam INC. You have been tasked with investigating a breach at Marys Farm. You will be using the ELK stack to analyze the logs. Your manager has asked you to investigate the breach and determine the initial compromised location. So you must generate a report that includes the following:

- The initial compromised location
    - Include metadata about the attack
- The attacker IP address
    - Use OSINT to determine the attacker (CN, ASN, etc)
- Did the attacker gain access via ssh?
    - If so, how?
    - Do you believe they could still have access?
## Introduction to the breach

Marys Farm has reached out to us after they have been contacted by a hacker that claims to have breached their network and stolen confidential data. They have provided the company with a sample of the data they have stolen to show it is legitimate. Marys Farm have informed us the sample data shown **MUST** have been taken from their wordpress eCommerce site. They have informed us that the hacker has threatened to release the data to the public if they do not pay a ransom of 1 Bitcoin.

Marys Farm have informed us they will not pay the ransom and have asked us to investigate the breach. Our team have exported their web server, firewall and SSH.

We will be using a pre-configured ELK stack that has been setup for us.

## Accessing the ELK stack

The ELK stack has been setup for us and is available at the following [URL]({{TRAFFIC_HOST1_5601}})

The ELK stack has been configured with the following credentials:
- user: elastic
- password: crowdsec

**The setup can take sometime so if you get 502 gateway errors, please wait a few minutes and try again.**