Let's point out a key piece of information:
- The sample data shown **MUST** have been taken from their WordPress eCommerce site.

Let's start with the web server logs. Use the search bar and search for `event.dataset : nginx.access` to filter to Apache access logs.

This is still a lot of data and can be overwhelming. KQL (Kibana Query Language) can be limiting here, so switch to Lucene query language. Do this by clicking the filter dropdown to the left of the search bar, then switch language at the bottom to **Lucene**.

Now we should filter the logs to see if any query strings have been used. Most commonly in backdoor shells you will see a query string called `cmd` or `q`. We can use the following query to filter down to logs that contain the query string `cmd` or `q`:

`event.dataset : nginx.access AND (url.query : cmd* OR url.query : q*)`

**NOTE THIS QUERY ONLY WORKS WITH LUCENE**

Now we can see suspicious logs. However, there are still too many active columns to get a clear view. Export the logs to CSV and open them in another program for easier analysis, then copy relevant details into your report.

## Let's search for attacker IP addresses in other logs

### Firewall logs
Let's search for attacker IP addresses in firewall logs. Use the search bar with `event.dataset : iptables` to filter to firewall logs.

`event.dataset : iptables.log AND (source.ip: <<IP_ADDRESS>> OR source.ip: <<IP_ADDRESS>>)`

### SSH logs

Let's search for attacker IP addresses in SSH logs. Use the search bar with `event.dataset : system.auth` to filter to SSH logs.

`event.dataset : system.auth AND (source.ip: <<IP_ADDRESS>> OR source.ip: <<IP_ADDRESS>>)`

## Let's search for IP addresses on OSINT sites

### Shodan

Go to [Shodan](https://www.shodan.io/) and search for the IP addresses.

### CrowdSec CTI

Go to [CrowdSec CTI](https://app.crowdsec.net/cti) and search for the IP addresses.

Include interesting information you find in your report.
