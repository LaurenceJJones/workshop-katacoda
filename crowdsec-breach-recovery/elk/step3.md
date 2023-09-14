Lets point out a key piece of information:
- The sample data shown **MUST** have been taken from their wordpress eCommerce site.

Lets start with the web server logs. We can use the search bar to search for `event.dataset : nginx.access` to filter down to the apache access logs.

Now this is still a lot of data and can be quite overwhelming. Sometimes using KQL (Kibana query language) is quite limiting so we are going to switch our to lucence query language. You can do this by clicking on filter dropdown menu to the left of the search bar then switch language at the bottom to **Lucene**.

Now we should filter the logs to see if any query strings have been used. Most commonly in backdoor shells you will see a query string called `cmd` or `q`. We can use the following query to filter down to logs that contain the query string `cmd` or `q`:

`event.dataset : nginx.access AND (url.query : cmd* OR url.query : q*)`

**NOTE THIS QUERY ONLY WORKS WITH LUCENE**

Now we can see some suspicious logs. However, there still too many columns active to get a clear view of the logs. We can export the logs to a CSV file and then open them in another program to get a better view of the logs, we can then copy and paste them to our report.

## Lets search for the attacker IP addresses in other logs

### Firewall logs
Lets search for the attacker IP addresses in the firewall logs. We can use the search bar to search for `event.dataset : iptables` to filter down to the firewall logs.

`event.dataset : iptables.log AND (source.ip: <<IP_ADDRESS>> OR source.ip: <<IP_ADDRESS>>)`

### SSH logs

Lets search for the attacker IP addresses in the SSH logs. We can use the search bar to search for `event.dataset : system.auth` to filter down to the SSH logs.

`event.dataset : system.auth AND (source.ip: <<IP_ADDRESS>> OR source.ip: <<IP_ADDRESS>>)`

## Lets search for the IP addresses on OSINT sites

### Shodan

Go to [Shodan](https://www.shodan.io/) and search for the IP addresses.

### CrowdSec CTI

Go to [CrowdSec CTI](https://app.crowdsec.net/cti) and search for the IP addresses.

Include interesting information you find in your report.