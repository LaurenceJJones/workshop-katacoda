## Scenario

You are a newly employed SOC analyst at Blueteam INC. You have been tasked with investigating a breach at Marys Farm. You will be using the ELK stack to analyze the logs. Your manager has asked you to investigate the breach and determine the initial compromised location. So you must generate a report that includes the following:

- The initial compromised location
    - Include metadata about the attack
- The attacker IP address
    - Use OSINT to determine the attacker
- Did the attacker gain access via ssh?
    - If so, how?
## Introduction to the breach

Marys Farm has reached out to us after they have been contacted by a hacker that claims to have breached their network and stolen confidential data. They have provided the company with a sample of the data they have stolen to show it is legitimate.

Marys Farm does not know how the hackers got in, but they have provided us logs from their web server, firewall and SSH. We will need to analyze these logs to determine how the hackers got in and what they did.

We will be using the ELK stack to analyze the logs. The ELK stack is a collection of open source tools that are commonly used for manual log analysis. The ELK stack consists of Elasticsearch, Logstash, and Kibana. Elasticsearch is a search engine that is used to store and search logs. Logstash is a tool that is used to collect and parse logs. Kibana is a web interface that is used to visualize logs.

We will be using a pre-configured ELK stack that has been setup for us.

## Accessing the ELK stack

The ELK stack has been setup for us and is available at the following [URL]({{TRAFFIC_HOST1_5601}})

The ELK stack has been configured with the following credentials:
- user: elastic
- password: crowdsec

**The setup can take sometime so if you get 502 gateway errors, please wait a few minutes and try again.**