#!/usr/bin/env perl

$input = "$ARGV[0]";

$links{"RFC-1034"}="https://tools.ietf.org/html/rfc1034";
$links{"RFC-2673"}="https://tools.ietf.org/html/rfc2673";
$links{"RFC-3339"}="https://tools.ietf.org/html/rfc3339";
$links{"RFC-3986"}="https://tools.ietf.org/html/rfc3986";
$links{"RFC-4122"}="https://tools.ietf.org/html/rfc4122";
$links{"RFC-4627"}="https://tools.ietf.org/html/rfc4627";
$links{"RFC-4648"}="https://tools.ietf.org/html/rfc4648";
$links{"RFC-5322"}="https://tools.ietf.org/html/rfc5322";
$links{"RFC-6570"}="https://tools.ietf.org/html/rfc6570";
$links{"RFC-6585"}="https://tools.ietf.org/html/rfc6585";
$links{"RFC-6648"}="https://tools.ietf.org/html/rfc6648";
$links{"RFC-6838"}="https://tools.ietf.org/html/rfc6838";
$links{"RFC-6901"}="https://tools.ietf.org/html/rfc6901";
$links{"RFC-6902"}="https://tools.ietf.org/html/rfc6902";
$links{"RFC-7159"}="https://tools.ietf.org/html/rfc7159";
$links{"RFC-7230"}="https://tools.ietf.org/html/rfc7230";
$links{"RFC-7231"}="https://tools.ietf.org/html/rfc7231";
$links{"RFC-7232"}="https://tools.ietf.org/html/rfc7232";
$links{"RFC-7233"}="https://tools.ietf.org/html/rfc7233";
$links{"RFC-7234"}="https://tools.ietf.org/html/rfc7234";
$links{"RFC-7240"}="https://tools.ietf.org/html/rfc7240";
$links{"RFC-7396"}="https://tools.ietf.org/html/rfc7396";
$links{"RFC-7493"}="https://tools.ietf.org/html/rfc7493";
$links{"RFC-7807"}="https://tools.ietf.org/html/rfc7807";
$links{"RFC-8288"}="https://tools.ietf.org/html/rfc8288";
$links{"RFC-8594"}="https://tools.ietf.org/html/rfc8594";
$links{"link-relations"}="http://www.iana.org/assignments/link-relations";
$links{"BCP47"}="https://tools.ietf.org/html/bcp47";
$links{"ECMA-262"}="http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf";
$links{"GTIN"}="https://en.wikipedia.org/wiki/Global_Trade_Item_Number";
$links{"IEEE-754-2008"}="https://en.wikipedia.org/wiki/IEEE_754";
$links{"ISO-8601"}="https://en.wikipedia.org/wiki/ISO_8601";
$links{"ISO-3166-1-a2"}="https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2";
$links{"ISO-639-1"}="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes";
$links{"ISO-4217"}="https://en.wikipedia.org/wiki/ISO_4217";
$links{"SRE-Tracing"}="https://github.bus.zalan.do/SRE/opentracing";

open(INPUT, "<$input") or die $!;

while(<INPUT>) {

  # skip init mark
  if (m/^\[#(\d+)\]$/) {
    $rule = $1;
    next;
  }

  # header marker from '=' to '#'
  s/^(=+) /("#" x length("$1")) . " "/e;

  s#{MUST}#[$rule] <font style='color: red;'>MUST</font>#;
  s#{SHOULD}#[$rule] <font style='color: orange;'>SHOULD</font>#;
  s#{MAY}#[$rule] <font style='color: green;'>MAY</font>#;
  s#<<(\S*)>>#[$1]($1.md)#g;
  s#<<(\w*),\s?(.*)>>#[$2]($1.md)#g;

  s#\[\[(\w+)\]\]{\1}#`$1`#;

  # entering source block, keep the lang
  if (m/^\[source,(\w+)\]|\[source\]$/) {
    $source = $1;
    next;
  }
  # start of md source block
  if (m/^----/ && !$in_source) {
    print("```$source\n");
    $in_source++;
    next;
  }
  # close of source block
  if (m/^----/ && $in_source) {
    print "```\n";
    undef($in_source);
    undef($source);
    next;
  }

  # pre-def links
  if (m/{(\S+)}(?:\[(.*)\])?/ && defined($links{$1})) {
    my $l = $1;
    my $c = $2 || $l;
    s/{\S+}(?:\[.*\])?/[$c]($links{$l})/;
  }

  # sub {T} to `T`
  if (m/{(\S+)}/ && ! defined($links{$1}) && ! defined($in_source)) {
    my $l = $1;
    s/{$l}/`$l`/;
  }

  s/^\[\[\S+\]\]$//; # remove ids on chapters

  # raw links
  s/\b(https?\S+)\[(.*)\]/[$2]($1)/;

  # detect we entered a table
  if(m/^\|={3,}$/) {
    if(!$in_table) {
      $in_table++;
    } else {
      undef($in_table);
    }
    next;
  }

  # remove table [cols...
  next if m/^\[,?cols=/;

  # create md table def from header size
  if($in_table == 1) {
    $in_table++;
    ($headers = $_) =~ s/([^\|]+)/'-' x length("$1")/ge;
    chomp;
    print("$_|\n$headers|\n");
    next;
  }

  # close rows in table
  if($in_table > 1) {
    s/(.*)$/$1|/;
  }

  print $_;

}

close(INPUT);
