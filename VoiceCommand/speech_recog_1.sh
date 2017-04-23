#!/usr/bin/env perl
# Render speech to text using the google cloud speech engine.
#
# Kruft Industries Sept. 2016
#
#
# Intended to replace work by the following(not sure where this is hosted): GNU General Public License Version 2 Copyright (C) 2011 - 2012, Lefteris Zafiris 
# <zaf.000@gmail.com>
#
#
# The script takes as input flac files at 8kHz and returns the following values: status : Return status. 0 means success, non zero values indicating different 
# errors.
#
# Outputs a voice transcription that satisfies the input of sendmailmp3 for freepbx authored by the above Zafiris I am by no means an expert with the perl 
# language, Please forgive any blaring ugliness :)

use utf8;
use MIME::Base64;
use strict;
use warnings; 
use LWP::UserAgent; 

if (!@ARGV || $ARGV[0] eq '-h' || $ARGV[0] eq '--help') {
print "Speech recognition using google cloud speech api.\n\n";
print "Usage: $0 [FILES]\n\n";
exit;
}
my $url = "https://speech.googleapis.com/v1beta1/speech:syncrecognize?key=AIzaSyDuctZjjNe9rz-ATdMP_LjWfJKfXOb_fnM"; 

my @file_list = @ARGV; foreach my $file 
(@file_list) {
# print "Opening $file\n";
open(my $fh, "<", "$file") or die "Cant read file: $!";
my $audio = do { local $/; <$fh> };
close($fh);

my $flac = encode_base64url($audio);

my $json = '{"config":{"encoding":"FLAC","sample_rate":16000,"language_code":"es-CO"},"audio":{"content":"' . $flac . '"}}';

my $req = HTTP::Request->new( 'POST', $url );
$req->header( 'Content-Type' => 'application/json' );
$req->content( $json );

my $lwp = LWP::UserAgent->new;
my $response = $lwp->request($req);

#print $response->as_string; #debug output google's reply headers and message
last if (!$response->is_success);

print $response->content; #debug output the full transcript
    my $doodle = $response->content;
    $doodle =~ s/.*\"transcript\"://g;
$doodle =~ s/}\],.*//g;
$doodle =~ s/^{\"result\":\[\]}/{\"result\":/g;
$doodle =~ s/\R//g;
$doodle =~ s/\*/_/g;
#    print $doodle;


}
      sub encode_base64url{
         my($data) = @_;
         return 0 unless $data;
         $data = encode_base64($data);
         $data =~ s/\+/-/g;
         $data =~ s/\//_/g;
         $data =~ s/\=//g;
         $data =~ s/\n//g;
         return($data);
      }
exit;
