use ExtUtils::MakeMaker;

use YAML::Any qw(LoadFile);
my $file = "plugins/ExtraTags/config.yaml";
my $version = LoadFile($file)->{version} ||
    die "No version found in $file";

WriteMakefile(
    NAME            => 'Extra Tags for Movable Type',
    VERSION         => $version,
    DISTNAME        => 'ExtraTags',
);
