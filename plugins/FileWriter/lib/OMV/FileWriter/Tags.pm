package OMV::FileWriter::Tags;
# $Id: Tags.pm 345 2013-07-21 07:12:00Z pirolix $

use strict;
use warnings;
use MT;
use MT::FileMgr;
use MT::I18N;

use vars qw( $VENDOR $MYNAME $FULLNAME );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[0, 1]);

sub instance { MT->component($FULLNAME); }



### $mt:RemoveFile$ function tag
sub RemoveFile {
    my( $ctx, $args ) = @_;

    my $path = $args->{path} || '';
    if(( $path ne '' ) && ( $path !~ m!\.\.! )) {
        if( $path =~ m!^/! ) {
            # 絶対パス指定
        }
        elsif( defined( my $blog = $ctx->stash( 'blog' ))) {
            ( my $out_path  = $blog->site_path ) =~ s!/*$!/!;
                 $out_path .= $path;

            my $fmgr = $blog->file_mgr;
            if( $args->{case_insensitive}) {
                my( $pathname, $filename ) = $out_path =~ m!(.+/)(.+)!;
                if( opendir( my $dh, $pathname )) {
                    map {
                        $fmgr->delete( "$pathname$_" );
                    } grep {
                        !/^\.+$/ && /\Q$filename\E/i && $fmgr->exists( "$pathname$_" );
                    } map {
                        MT::I18N::decode_utf8($_);
                    } readdir $dh;
                    closedir $dh;
                }
            }
            else {
                $fmgr->delete( $out_path );
            }
        }
    }

    return '';
}

### mt:FileWriter block tag
sub FileWriter {
    my( $ctx, $args, $cond ) = @_;

    my $out = $ctx->slurp or return;

    my $path = $args->{path} || '';
    if(( $path ne '' ) && ( $path !~ m!\.\.! )) {
        if( $path =~ m!^/! ) {
            # 絶対パス指定
        }
        elsif( defined( my $blog = $ctx->stash( 'blog' ))) {
            ( my $out_path = $blog->site_path ) =~ s!/*$!/!;
            $out_path .= $path;

            my $fmgr = $blog->file_mgr;
            defined $fmgr->put_data( $out, $out_path )
                or return $ctx->error( MT->translate( "Writing to '[_1]' failed: [_2]", $out_path, $fmgr->errstr ));
        }
    }

    return $args->{no_output} ? '' : $out;
}

1;