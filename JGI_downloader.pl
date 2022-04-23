#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;

#use JSON;
use XML::Simple;
#use Data::Dumper;
#sub download_file($$$);

my $out_dir='.';
my $user='xxx@xx.com';
my $passwd='xxxxx';


################
# main
################

my $login = `curl 'https://signon-old.jgi.doe.gov/signon/create' --data-urlencode 'login=$user' --data-urlencode 'password=$passwd' -c cookies -s`;
$login=~/success/ or die;

my $list_cmd="curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/get-directory?organism=PhytozomeV12' -b cookies -s";
my $list = `$list_cmd`;

my $xs = XML::Simple->new();
my $x = $xs->XMLin($list);
#die Dumper($x);

my $top_name=$x->{name};

my @cmds=();
&download_file($x, $top_name, $out_dir);

say join "\n",@cmds;
#zzRun(undef,5,\@$cmds);


sub download_file($$$) {
        my ($x_obj, $folder_name, $out_dir) = @_;
        mkdir $out_dir unless -e $out_dir;
        if (defined $x_obj->{file} && $x_obj->{file}) {
                if (ref($x_obj->{file}) eq 'HASH') {
                        $x_obj->{file} = [$x_obj->{file}];
                }
                foreach my $file ( @{$x_obj->{file}} ) {
                        my $out_file =  "$out_dir/$file->{filename}";
                        my $cmd="curl 'https://genome.jgi.doe.gov$file->{url}' -b cookies > $out_file";
                        push @cmds,$cmd;
                }
        }

        if (defined $x_obj->{folder} && $x_obj->{folder}) {
                foreach my $folder ( sort keys %{ $x_obj->{folder} } ) {
                        next if $folder eq 'name' || $folder eq 'file';
                        say STDERR "Into folder: $folder";
                        &download_file($x_obj->{folder}->{$folder}, $folder, "$out_dir/$folder");
                }
        }
}
