## Preparations

Let's ensure the detection and remediation is working. Firstly lets tail the crowdsec log so we can see the detection in realtime.

`tail -f /var/log/crowdsec.log`{{exec}}

## Attack

Let's try to attack our host from another host. To do this, open a new terminal tab and connect to the attacker host:

`ssh node01`{{exec}}

Once we are connected to the attacker host and you have to install the tools needed to preform ssh and web based attacks:

`apt install -y nikto hydra`{{exec}}

## SSH attacks

Firstly we will test iptables bouncer and ssh detection:

`hydra -l admin -x 1:1:a controlplane ssh`{{exec}}

Whilst the program is running return to original tab to see if crowdsec is detecting the ssh attacks. You can also run `cscli`{{}} to see the active decision.

`cscli decisions list`{{exec interrupt}}

For the next attack to work we will need to remove the decisions so please run

```
cscli decisions delete --scenario crowdsecurity/ssh-bf
cscli decisions delete --scenario crowdsecurity/ssh-slow-bf
tail -f /var/log/crowdsec.log
```{{exec}}

## Web attacks

Once the ssh decision has been removed. Return to the attacker tab, we will run nikto web scanner. However before running this we will do a little trick to forward a local port to the control plane (so we can see the block screen). The below command must be run on node01 NOT the control plane.

`ssh -L 0.0.0.0:8080:controlplane:80 localhost`{{exec interrupt}}

Once connected we can attack the website with `nikto`{{}}: 

`nikto -h http://controlplane`{{exec}}

Then we can check if the attack has been detect by going to this [LINK]({{TRAFFIC_HOST2_8080}})