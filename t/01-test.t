use strict;
use warnings;
use lib "../lib";
use Test::More;
use GF::Object::Port qw/port_object/;
use Data::Dumper;

ok(port_object([ 0, 1, { 'a' => 'ah', 'b' => 'bee' }, "string" ], type => "json") eq qq|[0,1,{"a":"ah","b":"bee"},"string"]|, qq|JSON Returned: [0,1,{"a":"ah","b":"bee"},"string"]|);
ok(port_object([ 0, 1, { 'a' => 'ah', 'b' => 'bee' }, "string" ], type => "html") eq qq|01aahbbeestring|, qq|HTML Returned: 01aahbbeestring|);

print port_object([ 0, 1, { 'a' => 'ah', 'b' => 'bee' }, "string" ], type => "html");
