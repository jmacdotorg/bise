use Modern::Perl;
use Test::More;
use FindBin;
use JSON;

my $config_file = "$FindBin::Bin/conf/conf.yaml";

my $results_json = `$FindBin::Bin/../bin/bise -c $config_file -j $FindBin::Bin/logs/access.log*`;
my $results_ref = decode_json( $results_json );

is( 'HASH', ref $results_ref );
is( $results_ref->{reports}->[0]->{ uniques }, 6 );
is( $results_ref->{reports}->[0]->{ regulars }, 1 );

done_testing();
