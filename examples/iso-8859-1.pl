#! /usr/bin/perl
#---------------------------------------------------------------------
# This example is hereby placed in the public domain.
# You may copy from it freely.
#
# This displays PostScript's slightly modified version of iso-8859-1.
#---------------------------------------------------------------------

use strict;
use warnings;

use PostScript::File 1.05;      # Need iso-8859-1 support

my $ps = PostScript::File->new(
  paper    => 'letter',
  reencode => 'iso-8859-1',
  auto_hyphen => 0,             # We don't want any hyphen translation
  need_fonts  => ['Helvetica'],
  left     => 72,
  top      => 72,
);

$ps->add_to_page( <<END_PAGE );
    /Helvetica-iso findfont
    16 scalefont
    setfont

    181 700 moveto
    (PostScript's version of ISO-8859-1) show
END_PAGE

my $char = 32;

my ($xMar, $y) = ($ps->get_bounding_box)[0,3];

my $xStep = 26;
my $yStep = 24;

my $xLeft = $xMar + 50;
$y -= 2 * $yStep;

for my $i (0 .. 0xF) {
  $ps->add_to_page(sprintf "%d %d moveto\n%s show\n",
                   $xLeft + $i * $xStep, $y,
                   $ps->pstr(sprintf '%X', $i));
}

while ($char < 0x100) {
  $y -= $yStep;

  $ps->add_to_page(sprintf "%d %d moveto\n%s show\n",
                     $xMar, $y,
                     $ps->pstr(sprintf '0x%X_', $char/16));

  for my $i (0 .. 0xF) {
    $ps->add_to_page(sprintf "%d %d moveto\n%s show\n",
                     $xLeft + $i * $xStep, $y,
                     $ps->pstr(pack('C', $char++)));
  }
}

printf "Wrote %s...\n", $ps->output("iso-8859-1", $ENV{TMP});
