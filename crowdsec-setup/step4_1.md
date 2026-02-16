## Web attacks

The firewall bouncer has been disabled automatically for this step (same automation pattern as the whitelist removal). This lets us observe web remediation behavior from the NGINX bouncer.

Return to the attacker tab and run a web scan emulation. Before running it, forward a local port to the control plane so we can see the block screen. Run this on `node01` (not on the control plane):

`ssh -L 0.0.0.0:8080:controlplane:80 localhost`{{exec interrupt}}

Once connected, attack the website with the emulator:

`attack-emulator web-scan http://controlplane`{{exec}}

Then check whether the attack was detected by opening this [LINK]({{TRAFFIC_HOST2_8080}})

>I only see the default NGINX page?

>Press ctrl + shift + r to force a reload. This maps to the bouncer's internal polling interval; new decisions are fetched about every 10 seconds.
