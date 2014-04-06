use strict;
open my $fh, "< .irssi/freenode-password";
my $p = <$fh>;
close $fh;
chomp($p);
Irssi::active_server()->command("^msg nickserv identify $p");
