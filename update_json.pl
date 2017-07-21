#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper;
sub list_files;
sub read_file;
sub snipetname;
sub write_json;

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "\nUsage: update_json.pl folder_of_json_files\n";
    exit;
}
my $path_folder = $ARGV[0];

#list all files from folder recursive

my %json_hashmap;

#meter isto a funcionar chamar as funções
list_files($path_folder);
#escrever no ficheiro de texto
write_json();





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

    (my $tabs = $json) =~ s/ /\t/g;
    (my $spaces = $tabs) =~ s/\R/\n/g;
    (my $json_concat = $spaces) =~ s/"/\"/g;

    close $fh;

    my $name = snipetname($filename);

    my %tempinfo = (
        "prefix"  => $name,
        "body" => $json_concat,
        "description"  => "snipet-$name"
    );
    (my $key = $name) =~ s/-//g;

    $json_hashmap{$name} = \%tempinfo;
}

sub snipetname{
  my $filename = $_[0];

  my @path = split(/\//,$filename);
  (my $file = $path[$#path]) =~ s/^[0-9][0-9]-//g;
  my $object;
  for (my $i = $#path; $i > 1; $i--) {
    if(($path[$i] =~ /[0-9][0-9]-atoms/) || ($path[$i] =~ /[0-9][0-9]-organism/) || ($path[$i] =~ /[0-9][0-9]-molecules/)){
      ($object = $path[$i]) =~ s/^[0-9][0-9]-//g;
      last;
    }
  }
  (my $snipetname = "$object-$file") =~ s/.json//g;
  return $snipetname;
}

sub write_json{

    my $json = JSON->new;

    open my $fh, ">", "/Users/emanuelx/file.json";
    print $fh encode_json(\%json_hashmap);
    close $fh;
    #print Dumper $json;
    print "done!"
}
