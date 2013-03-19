use strict;
use warnings;
package GF::Object::Port;
use Exporter;
use JSON;
use Data::Util qw(:check);

our @ISA = qw(Exporter);
our @EXPORT_OK = qw|port_object|;

sub port_object {
    my $obj = shift;
    my %opts = @_;
    
    if(lc $opts{type} eq "json") {
        if(ref($obj) eq "HASH" || ref($obj) eq "ARRAY") {
            return to_json($obj, {pretty => $opts{pretty}});
        } elsif (is_number($obj)) {
            return $obj;
        } elsif (is_string($obj)) {
            return "\"$obj\"";
        }
    }
    elsif (lc $opts{type} eq "html") {
        if(ref($obj) eq "HASH" || ref($obj) eq "ARRAY") {
            return _encode_html($obj, {pretty => $opts{pretty}});
        }
    }
}

sub _encode_html {
    my $obj = shift;
    my $opts = shift;
    my $nested = shift // 0;
    my $return = "";
    my $space = ' ' x 4;
    my $indent = $space x $nested;
    my $newline = "\\n";

    if(ref($obj) eq "HASH") {
        my $count = 0;
        my $size = scalar(keys $obj);
        foreach (keys $obj) {
            my $tmp = $obj->{$_};
            if(ref($tmp) eq "ARRAY" || ref($tmp) eq "HASH") {
                $tmp = _encode_html($tmp, $opts, $nested + 1);
            }
            print "Size: $size\nCount: $count";
            $return .= $indent . $_ . $tmp . (($size-1) > $count ? $newline : "");
            $count = $count + 1;
        }
    } elsif(ref($obj) eq "ARRAY") {
        foreach (@{$obj}) {
            my $tmp = $_;
            if(ref($tmp) eq "ARRAY" || ref($tmp) eq "HASH") {
                $tmp = _encode_html($tmp, $opts, $nested + 1);
            }
            $return .= $indent . $tmp . $newline;
        }
    }
    return $return;
}
