#!/usr/bin/perl
use strict;
use warnings;
use 5.024;
use experimental qw/ signatures /;

use Getopt::Long;
use YAML::PP;
use autodie qw/ open close /;

GetOptions(
    'license=s' => \my $license,
    'requires=s@' => \my @req,
) or die("Error in command line arguments\n");

my ($spec, $rpmlintrc) = YAML::PP->new->load_file(*DATA);

my ($name) = @ARGV;

my ($pkg, $version) = split m{/}, $name;

my $rpmlint = q{Source1:        %{name}-rpmlintrc};

$spec =~ s/\$\{\{ PACKAGE \}\}/$pkg/g;
$spec =~ s/\$\{\{ LICENSE \}\}/$license/g;
$spec =~ s/\$\{\{ VERSION \}\}/$version/g;
$spec =~ s/\$\{\{ RPMLINT \}\}/$rpmlint/;
if (@req) {
    my $req = '';
    for my $pkg (@req) {
        $req .= qq{Requires:       $pkg\n};
    }
    $spec =~ s/\$\{\{ REQUIRES \}\}/$req/;
}
else {
    $spec =~ s/\$\{\{ REQUIRES \}\} *\n//;
}

open my $fh, '>', "$pkg.spec";
print $fh $spec;
close $fh;
open $fh, '>', "$pkg-rpmlintrc";
print $fh $rpmlintrc;
close $fh;


__DATA__
--- | # spec template
  #
  # spec file for package ${{ PACKAGE }}
  #
  # Copyright (c) 2020 SUSE LINUX GmbH, Nuernberg, Germany.
  #
  # All modifications and additions to the file contributed by third parties
  # remain the property of their copyright owners, unless otherwise agreed
  # upon. The license for this file, and modifications and additions to the
  # file, is the same license as for the pristine package itself (unless the
  # license for the pristine package is not an Open Source License, in which
  # case the license is the MIT License). An "Open Source License" is a
  # license that conforms to the Open Source Definition (Version 1.9)
  # published by the Open Source Initiative.

  # Please submit bugfixes or comments via http://bugs.opensuse.org/
  #


  Name:           ${{ PACKAGE }}
  Version:        ${{ VERSION }}
  Release:        0
  Summary:        Flatpak image %{name}
  # TODO
  License:        ${{ LICENSE }}
  # group?
  Group:          Development/Libraries/Perl
  #Url:            ?
  Source0:        %{name}-%{version}.x86_64.tar.gz
  ${{ RPMLINT }}
  ${{ REQUIRES }}
  BuildRoot:      %{_tmppath}/%{name}-%{version}-build

  %description

  An rpm version of the flatpak image %{name}

  %prep
  %setup -q

  %build

  %check

  %install

  export NO_BRP_STALE_LINK_ERROR=yes
  mkdir -p %{buildroot}/var/lib/flatpak/runtime/%{name}
  cp -r x86_64 %buildroot/var/lib/flatpak/runtime/%{name}

  %files
  /var/lib/flatpak
  /var/lib/flatpak/runtime/%{name}
  /var/lib/flatpak/runtime/%{name}/*

  %changelog
--- | # rpmlintrc
  addFilter("library-without-ldconfig-postun *")
  addFilter("library-without-ldconfig-postin *")
  addFilter("name-repeated-in-summary *")
  addFilter("devel-file-in-non-devel-package *")
