Crowdsec has the ability to process "cold" logs. This can be useful if you wish to know what crowdsec could of detected in the moment or to point out IP's to investigate if you are brought in to investigate a breach.

```
crowdsec -dsn file:///root/pwn.log --type nginx -no-api
```{{exec}}

Example output

```
INFO[21-09-2022 12:31:33] Adding file /home/workshop/pwnspoof.log to filelist  type="file:///home/workshop/pwnspoof.log"
INFO[21-09-2022 12:31:33] Starting processing data                     
INFO[21-09-2022 12:31:33] reading /home/workshop/pwnspoof.log at once   type="file:///home/workshop/pwnspoof.log"
WARN[21-09-2022 12:31:33] prometheus: listen tcp 127.0.0.1:6060: bind: address already in use 
INFO[21-09-2022 12:31:35] Ip 135.118.0.47 performed 'LePresidente/http-generic-401-bf' (7 events over 13s) at 2022-09-09 20:21:32 +0000 UTC 
INFO[21-09-2022 12:31:42] Ip 199.19.52.132 performed 'LePresidente/http-generic-401-bf' (7 events over 12s) at 2022-09-12 09:24:23 +0000 UTC 
INFO[21-09-2022 12:32:04] Ip 103.121.204.144 performed 'LePresidente/http-generic-401-bf' (7 events over 13s) at 2022-09-20 22:11:22 +0000 UTC 
…….
INFO[21-09-2022 12:32:06] Ip 23.32.183.126 performed 'LePresidente/http-generic-401-bf' (7 events over 14s) at 2022-09-20 22:14:48 +0000 UTC 
INFO[21-09-2022 12:32:07] Ip 23.32.183.126 performed 'LePresidente/http-generic-401-bf' (7 events over 11s) at 2022-09-20 22:16:01 +0000 UTC 
WARN[21-09-2022 12:32:09] Acquisition is finished, shutting down       
INFO[21-09-2022 12:32:09] Killing parser routines                      
INFO[21-09-2022 12:32:10] Bucket routine exiting                       
INFO[21-09-2022 12:32:11] crowdsec shutdown
```{{}}