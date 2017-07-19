#!/usr/bin/perl
use strict;
use warnings;
use JSON;
sub list_files;
sub read_file;

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "\nUsage: update_json.pl folder_of_json_files\n";
    exit;
}
my $path_folder = $ARGV[0];

#list all files from folder recursive

my %json_hashmap;

#meter isto a funcionar chamar as funções
#list_files($path_folder);
#escrever no ficheiro de texto 
#write_json();

my $teste = "/Users/emanuelx/Documents/Namecheap Projects/nc.ui.bootstrap.wiki.bx_old/source/_patterns/02-organisms/20-tabs/00-tabs-vertical.json";

my @path = split(/\//,$teste);
#foreach my $x (@path) {
  my $filename = $path[$#path];
  print $path[$#path-2];
  #todo dar nome ao atomo
#}



### functions

sub list_files{
    my $path = $_[0];
    opendir(my $DIR, $path) || die "Can't open $path: $!";
    while (readdir $DIR) {
        next if $_ =~ /^\./; #remove . and hidden folders
        next if $_ =~ /[0-9][0-9]-templates/;
        next if $_ =~ /[0-9][0-9]-storefront-pages/;
        next if $_ =~ /[0-9][0-9]-account-panel-page/;
        next if $_ =~ /[0-9][0-9]-nc-admin/;
        next if $_ =~ /docs/;

        if(-d "$path$_"){
            list_files("$path$_/");
        }else{
            if ("$path$_" =~ /\.json$/i) {
                read_file("$path$_");
            }
        }

    }
    closedir $DIR;
}

sub read_file{
    my $filename = $_[0];

    my $json;
    local $/=undef; #read all file
    open my $fh, $filename or die "could open file";
    $json = <$fh>;
    #print $json;
    no warnings;
    my  %replacements = ('  ' => '\\t', '\R' => '\\n', '"'=>'\\"');
    (my $json_concat = $json) =~ s/(@{[join "|", keys %replacements]})/$replacements{$1}/g;

    close $fh;

    #print "$json_concat\n";
    print $filename;


    my %tempinfo = (
        "prefix"  => "vermelha",
        "body" => $json_concat,
        "descrition"  => "lilas"
    );

    $json_hashmap{"teste"} = %tempinfo;
}



sub write_json{
  print "write";
    my $json = JSON->new;

    #my %teste_all;
    #my %teste = ("a"=>"a", "b"=>"b");
    #$teste_all{"a"}= \%teste;
    #$teste_all{"b"}= \%teste;

  #print $json->encode(\%json_hashmap) . "\n";
#    open my $fh, ">", "/Users/emanuelx/teste.json";
#    print $fh encode_json($data);
#    close $fh;
    my $data = decode_json(%json_hashmap);
    open my $fh, ">", "/Users/emanuelx/file.json";
    print $fh encode_json($data);
    close $fh;
}
