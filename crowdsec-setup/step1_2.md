From `crowdsec`{{}} version 1.4.2 we implemented Sqlite WAL support. However, since we cannot presume where people are running `crowdsec`{{}} you will get a warning until you turn it on or off.

For the demo we will turn on WAL support, the only reason you would not enable this option if you store the Sqlite database in a network share.

```
echo "db_config:
  use_wal: true" > /etc/crowdsec/config.yaml.local
systemctl restart crowdsec.service
```{{ exec }}