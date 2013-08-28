#!/usr/bin/perl

my @files = `ls results/ms_*.txt`;

open( OUTFILE, "> ms_res.data" ) or die "could not open all_res.data: $!";
print OUTFILE "run, time, tps, resp_time\n";

while( my $file = shift @files ) {
    next if $file =~ m/\.data$/;
    chomp( $file );
    
    $file =~ m'ms_(.*)\.txt';
    my $run = $1;
    
    print "parsing file: $file, $run\n";
    
    open( FILE, "< $file" ) or die "could not open $file: $!";
    

    
    while( my $line = <FILE> ) {
        # print $line;
        if( $line =~ m/^\[\s*(\d+)s\].+,\swrites\/s\:\s(\d+\.\d+).+,\sresponse\stime\:\s(\d+\.\d+)/ ) {
            print OUTFILE "$run, $1, $2, $3\n";
        }
    } 
    close( FILE );
}
close( OUTFILE );
