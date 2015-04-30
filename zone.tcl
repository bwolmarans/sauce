if { 0 } {
set mf [open zones.txt w+]
for { set i 1 } { $i <= 1000 } { incr i } {
	set x "zone \"example$i.com\" \{ type master\; file \"/etc/bind/zones/db.example$i.com\"\; \}\;"
puts $mf $x
}
close $mf

for (( i = 1 ; i <= 1000; ++i )) ; do
    touch /etc/bind/tmp/pages$i.txt;
done
}

for { set i 1 } { $i <= 1000 } { incr i } {
	set mf [open db.example$i.com w+]
	set x\
"
\;
\; BIND data file for local loopback interface
\;
\$TTL    604800
@       IN      SOA     ns.example$i.com. root.example$i.com. (
                              1         \; Serial
                         604800         \; Refresh
                          86400         \; Retry
                        2419200         \; Expire
                         604800 )       \; Negative Cache TTL
\;
@       IN      NS      ns.example$i.com.
ns      IN      A       10.10.[expr $i/4].[expr $i/4]

\;also list other computers
box     IN      A       10.11.[expr $i/4].[expr $i/4]
"
	puts $mf $x
	close $mf
}
