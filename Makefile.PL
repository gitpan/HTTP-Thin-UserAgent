
use strict;
use warnings;

use 5.012001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "A Thin UserAgent around some useful modules.",
  "AUTHOR" => "Chris Prather <chris\@prather.org>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::More" => 0,
    "Test::Requires::Env" => 0,
    "strict" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "HTTP-Thin-UserAgent",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "HTTP::Thin::UserAgent",
  "PREREQ_PM" => {
    "Exporter" => 0,
    "HTTP::Request::Common" => 0,
    "HTTP::Thin" => 0,
    "Import::Into" => 0,
    "JSON::Any" => 0,
    "Moo" => 0,
    "MooX::late" => 0,
    "parent" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.003",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



