## Preparations

Let's ensure the detection and remediation is working. Firstly lets tail the crowdsec log so we can see the detection in realtime.

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
