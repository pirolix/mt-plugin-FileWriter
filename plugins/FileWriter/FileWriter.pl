package MT::Plugin::Util::OMV::FileWriter;
# FileWriter (C) 2013 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id: FileWriter.pl 344 2013-07-20 07:49:34Z pirolix $

use strict;
use warnings;
use MT 5;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev: 344 $') =~ s/\D//g;
$VERSION = 'v0.10'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    # Basic descriptions
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2013/11171508/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Supply template tags to write a contents to the specified file and to remove the specified files.">
HTMLHEREDOC
    l10n_class => "${FULLNAME}::L10N",

    # Registry
    registry => {
        tags => {
            help_url => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME#tag-%t",
            function => {
                RemoveFile => "${FULLNAME}::Tags::RemoveFile"
            },
            block => {
                FileWriter => "${FULLNAME}::Tags::FileWriter"
            },
        },
    },
});
MT->add_plugin ($plugin);

sub instance { $plugin; }

1;