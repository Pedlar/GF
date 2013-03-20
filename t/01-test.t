use strict;
use warnings;
use lib "../lib";
use Test::More;
use GF::Object::Port qw/port_object/;
use Data::Dumper;

my $obj = [ 0, 1, { 'a' => 'ah', 'b' => 'bee' }, "string" ];
ok(port_object($obj, type => "json") eq qq|[0,1,{"a":"ah","b":"bee"},"string"]|, qq|JSON Returned: [0,1,{"a":"ah","b":"bee"},"string"]|);
ok(port_object($obj, type => "html") eq qq|01aahbbeestring|, qq|HTML Returned: 01aahbbeestring|);

print "Pretty Json:\n", port_object($obj, type => "json", pretty => 1), "\n";
print "Pretty Html:\n", port_object($obj, type => "html", pretty => 1), "\n";
done_testing();
