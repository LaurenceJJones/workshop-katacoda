## Preparations

Let's ensure the detection and remediation is working. Firstly let's tail the crowdsec log so we can see the detection in realtime.

`tail -f /var/log/crowdsec.log`{{exec}}

## Attack

Let's try to attack our host from another host. To do this, open a new terminal tab and connect to the attacker host:

`ssh node01`{{exec}}

Once we are connected to the attacker host, verify the attack emulator is available:

`attack-emulator --help`{{exec}}

## SSH attacks

Firstly we will test iptables bouncer and ssh detection:

`attack-emulator ssh-bruteforce controlplane admin 26`{{exec}}

Whilst the program is running return to original tab to see if crowdsec is detecting the ssh attacks. You can also run `cscli`{{}} to see the active decision.

`cscli decisions list`{{exec interrupt}}

For the next attack to work we will need to remove the decisions so please run

```
cscli decisions delete --scenario crowdsecurity/ssh-bf
cscli decisions delete --scenario crowdsecurity/ssh-slow-bf
tail -f /var/log/crowdsec.log
```{{exec}}

## Web attacks

Once the ssh decision has been removed. Return to the attacker tab, we will run a web scan emulation. However before running this we will do a little trick to forward a local port to the control plane (so we can see the block screen). The below command must be run on node01 NOT the control plane.

`ssh -L 0.0.0.0:8080:controlplane:80 localhost`{{exec interrupt}}

Once connected we can attack the website with the emulator: 

`attack-emulator web-scan http://controlplane`{{exec}}

Then we can check if the attack has been detect by going to this [LINK]({{TRAFFIC_HOST2_8080}})

>I just see the default nginx page?

>Press ctrl + shift + r to force a reload. This links back to the internal timer on the bouncer it will get the new decisions within 10 seconds.
