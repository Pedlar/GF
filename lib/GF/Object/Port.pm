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
    $opts{type} ||= "json";

    if(lc $opts{type} eq "json") {
        if(ref($obj) eq "HASH" || ref($obj) eq "ARRAY") {
            return _encode_json($obj, {pretty => $opts{pretty}});
        } elsif (is_number($obj)) {
            return $obj;
        } elsif (is_string($obj)) {
            return "\"$obj\"";
        }
    }
    elsif (lc $opts{type} eq "html") {
        if(ref($obj) eq "HASH" || ref($obj) eq "ARRAY") {
            return _encode_html($obj, {pretty => $opts{pretty}});
        } else {
            return $obj;
	}
    }
}

sub _encode_json {
    my $obj = shift;
    my $opts = shift;
    my $nested = shift // 1;
    my $return = "";
    my $space = $opts->{pretty} ? ' ' x 4 : '';
    my $indent = $space x $nested;
    my $newline = $opts->{pretty} ? "\n" : "";
   

    if(ref($obj) eq "HASH") {
        my $count = 0;
        my $size = scalar(keys $obj);
	$return = "{" . ($opts->{pretty} ? "\n" : "");
        foreach (keys $obj) {
            my $tmp = $obj->{$_};
            if(ref($tmp) eq "ARRAY" || ref($tmp) eq "HASH") {
                $tmp = _encode_json($tmp, $opts, $nested + 1);
            } else {
	        $tmp = is_number($tmp) ? $tmp : qq|"$tmp"|;
	    }
            $return .= "$indent\"$_\":$tmp" . (($size-1) > $count ? "," : "") . (($size-1) > $count ? $newline : "");
            $count = $count + 1
        }
	
	$return .= $newline . ($space x ($nested - 1)) . "}";
    } elsif(ref($obj) eq "ARRAY") {
	$return = "[" . ($opts->{pretty} ? "\n" : "");
	my $count = 0;
        my $size = scalar(@{$obj});
        my $recurse = 0;
        foreach (@{$obj}) {
            my $tmp = $_;
            if(ref($tmp) eq "ARRAY" || ref($tmp) eq "HASH") {
                $tmp = _encode_json($tmp, $opts, $nested + 1);
		$recurse = 1;
            } else { 
	        $tmp = is_number($tmp) ? $tmp : qq|"$tmp"|;
	    }
            $return .= $indent . $tmp . (($size-1) > $count ? "," : "") . $newline ;
	    $count = $count + 1;
        }
	$return .= ($nested > 1 ? $indent : "") . "]";
    }
    return $return;
}
my $html = {
              sol => "<ol>",
              eol => "</ol>",
              sli => "<li>",
              eli => "</li>",
              sdl => "<dl>",
              edl => "</dl>",
              sdt => "<dt>",
              edt => "</dt>",
              sdd => "<dd>",
              edd => "</dd>",
           };

sub html_wrap {
    my $data = shift;
    my $tag_type = shift;
    my $pretty = shift;
    return $data unless $pretty;
    return $html->{"s".$tag_type} . $data . $html->{"e".$tag_type};
}

sub _encode_html {
    my $obj = shift;
    my $opts = shift;
    my $nested = shift // 1;
    my $return = "";
    my $space = $opts->{pretty} ? ' ' x 4 : '';
    my $indent = $space x $nested;
    my $newline = $opts->{pretty} ? "\n" : "";

    if(ref($obj) eq "HASH") {
        my $count = 0;
        my $size = scalar(keys $obj);
        $return = ($opts->{pretty} ? "$html->{sdl}\n" : "");
        foreach (keys $obj) {
            my $tmp = $obj->{$_};
            if(ref($tmp) eq "ARRAY" || ref($tmp) eq "HASH") {
                $tmp = _encode_html($tmp, $opts, $nested + 1);
            } 
            $return .= "$indent" . html_wrap($_, "dt", $opts->{pretty}) . html_wrap($tmp, "dd", $opts->{pretty}) .(($size-1) > $count ? $newline : "");
            $count = $count + 1
        }

        $return .= $newline . ($space x ($nested - 1)) . ($opts->{pretty} ? $html->{edl} : "");
    } elsif(ref($obj) eq "ARRAY") {
        $return = ($opts->{pretty} ? "$html->{sol}\n" : "");
        my $count = 0;
        my $size = scalar(@{$obj});
        my $recurse = 0;
        foreach (@{$obj}) {
            my $tmp = $_;
            if(ref($tmp) eq "ARRAY" || ref($tmp) eq "HASH") {
                $tmp = _encode_html($tmp, $opts, $nested + 1);
                $recurse = 1;
            }
            my $stag = $opts->{pretty} ? $html->{sli} : "";
            my $etag = $opts->{pretty} ? $html->{eli} : "";
            $return .= $indent . $stag . $tmp . $etag . $newline ;
            $count = $count + 1;
        }
        $return .= ($nested > 1 ? $indent : "") . ($opts->{pretty} ? $html->{eol} : "");
    }
    return $return;
}

1;
