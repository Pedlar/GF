use strict;
use warnings;
use lib "../lib";
use Test::More;
use GF::Object::Port qw/port_object/;
use Data::Dumper;

my $obj = { 'a' => 'ah', 'b' => 'bee', 'c' => 'cee', 'd' => ['a', 'b', 'c'], 'e' => [0..9]};

ok(port_object($obj, type => "json") eq qq|{"e":[0,1,2,3,4,5,6,7,8,9],"c":"cee","a":"ah","b":"bee","d":["a","b","c"]}|, qq|JSON Returned: {"e":[0,1,2,3,4,5,6,7,8,9],"c":"cee","a":"ah","b":"bee","d":["a","b","c"]}|);
ok(port_object($obj, type => "html") eq qq|e0123456789cceeaahbbeedabc|, qq|HTML Returned: e0123456789cceeaahbbeedabc|);

print port_object($obj, type => "json", pretty => 1)
