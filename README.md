# powerdns
Docker container to run PowerDNS Auth plus my admin WebUI using nginx

Will also maintain a catalog zone of all zones where type=`MASTER` and run an
instance of `bind` to secondary them and converting PowerDNS's AXFR to IXFR


# ToDo
- Support TYPE="Producer" for catalog zone in catalog.py script
- Add "version" TXT record when creating blank catalog zone in catalog.py script
- check bind notfies & allows transfer where told
