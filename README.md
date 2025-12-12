# powerdns
A complete container to run PowerDNS Auth with my Admin WebUI using nginx

It also runs a copy of `bind` to convert PowerDNS's AXFR to the more standard IXFR.
For this to work you need to define all the zones you want `bind` to pick up in a catalog zone.
This can either be a PowerDNS Provider Zone, or a standard RFC Catalog Zone. The default name
`bind` will look for is `lst.zz`. You can change this with the env-var `PDNS_CATALOG_ZONE`.

If you create a Provider Zone called `lst.zz`, then to put zones in this catalog, go into the zone
you want to add, go into its Meta Data nd in the item `CATALOG` add the value `lst.zz`. As soon as you do this
`bind` should pick up the zone and you should be able to 

Port `53` will point to `bind`, but port `5353` can be used to get direct DNS access
to PowerDNS. Port `80` will be the Web Admin UI, password protected using the password
file `htpasswd`, default admin & admin.

You can map in a different password file at `/etc/nginx/htpasswd`.

# Backend
It supports either a MySQL/MariaDB backend or Sqlite3 backend.

To uee a MySQL backend you will need to define the follow env-vars

		MYSQL_CONNECT
		MYSQL_DATABASE
		MYSQL_PASSWORD
		MYSQL_USERNAME

`MYSQL_CONNECT` = `[IP]:[port]` or path to unix socket, to connect to MySQL.

With a MySQL backend it will be your responsbility to create the database and
create a login that has permission to access the database. This can not be done automatically as
it requires admin access to your database server.

If you want to use Sqlite3, you will need to map some disk space into `/opt/data`
inside the container. It will then create a sub-directory `pdns` and automatically 
create the correct database. There are no env-vars required or supported when using Sqlite3.

MySQL will be faster for a large installation and means you can update the DNS
data directly via the MySQL API, but Sqlite3 requires no external server and creates
the database automatically, but probably won't scale quite as much - tho def fine
for small installations.

# Syslog

By default it will syslog to `{{DATA}}/logs`, if you are running it under `systemd`
you may want it to log to stdout, if so set the env-var `SYSLOG_STDOUT` to `Y`.

If you are using an external syslog server (listening on port 514), you can specify it's IP Address
with the env-var `SYSLOG_SERVER`.

# Env Vars

The follow env-vars are also supported / required

| env-var | Use | default
|---------|-----|--------|
| PDNS_LOG_LEVEL | PowerDNS logging level | `5`
| PDNS_LOG_FACILITY | PowerDNS syslog facility | `6`
| PDNS_API_KEY | PowerDNS API Key | If one is not specified a random key will be generated on each run
| PDNS_CATALOG_ZONE | Name of the catalog zone that lists zones you want bind to convert too IXFR | `lst.zz`
| BIND_SECONDARY_SERVERS | Semi-Colon separated list of secondary name server IP addresses | No default, mandatory
| BIND_RNDC_KEY | Key for remote control of bind | No default, optional

NOTE: You shouldn't need to specify a PowerDNS API key. You can access
the PDNS/API through `nginx` and the user level authentication it imposes. 
This is normally better than using a shared key.

If you have no secondary name servers, or they are just not set up yet, set `127.1.1.1` as the `BIND_SECONDARY_SERVERS`
