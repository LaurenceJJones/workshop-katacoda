Crowdsec has the ability to process "cold" logs. This can be useful if you wish to know what crowdsec could of detected in the moment or to point out IP's to investigate if you are brought in to investigate a breach.

```
crowdsec -dsn file:///root/pwn.log --type nginx -no-api
```{{exec}}

Example output

```
INFO[05-01-2023 20:35:11] Adding file /root/pwn.log to filelist         type="file:///root/pwn.log"
INFO[05-01-2023 20:35:11] Starting processing data                     
INFO[05-01-2023 20:35:11] reading /root/pwn.log at once                 type="file:///root/pwn.log"
WARN[05-01-2023 20:35:11] prometheus: listen tcp 127.0.0.1:6060: bind: address already in use 
INFO[05-01-2023 20:35:18] Ip 158.50.194.86 performed 'LePresidente/http-generic-401-bf' (7 events over 12s) at 2022-12-27 13:08:24 +0000 UTC 
INFO[05-01-2023 20:35:19] Ip 158.50.194.86 performed 'LePresidente/http-generic-401-bf' (7 events over 13s) at 2022-12-27 13:09:35 +0000 UTC 
INFO[05-01-2023 20:35:20] Ip 158.50.194.86 performed 'LePresidente/http-generic-401-bf' (7 events over 14s) at 2022-12-27 13:10:48 +0000 UTC 
INFO[05-01-2023 20:35:36] Ip 173.195.57.15 performed 'LePresidente/http-generic-401-bf' (7 events over 11s) at 2023-01-05 11:55:37 +0000 UTC 
WARN[05-01-2023 20:35:37] Acquisition is finished, shutting down       
INFO[05-01-2023 20:35:37] Killing parser routines                      
INFO[05-01-2023 20:35:38] Bucket routine exiting                       
INFO[05-01-2023 20:35:39] crowdsec shutdown
```{{}}