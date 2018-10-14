#!/usr/bin/perl

use warnings;
use strict;

$| = 1;

my $license = 'CC-BY-SA-4.0';
my $date = '2018';

my %config = (
    '@DEBUG_SUFFIX@' => '',
    '@CMAKE_INSTALL_PREFIX@' => '/usr',
    '@CMAKE_INSTALL_FULL_DATADIR@' => '/usr/share',
    '@CMAKE_INSTALL_FULL_SYSCONFDIR@' => '/etc',
    '@PROJECT_NAME@' => 'termysequence',

    '@FRIENDLY_NAME@' => 'TermySequence',
    '@PRODUCT_DOMAIN@' => 'termysequence.io',
    '@ENV_NAME@' => 'TERMYSEQUENCE',
    '@ABBREV_NAME@' => 'termy',

    '@SERVER_NAME@' => 'termy-server',
    '@FORWARDER_NAME@' => 'termy-forwrd',
    '@CONNECT_NAME@' => 'termy-connect',
    '@QUERY_NAME@' => 'termy-query',
    '@MONITOR_NAME@' => 'termy-monitor',
    '@APP_NAME@' => 'qtermy',
    '@PIPE_NAME@' => 'qtermy-pipe',
    '@SETUP_NAME@' => 'termy-setup',
    '@SYSTEMD_SETUP_NAME@' => 'termy-systemd-setup',
    '@WEB_NAME@' => 'termy-web',

    '@SERVER_XDG_DIR@' => '%t/termy-server',
    '@SERVER_RUN_DIR@' => '/run/user/%U/termy-server',
    '@SERVER_TMP_DIR@' => '/tmp/termy-server%U',
    '@APP_XDG_DIR@' => '%t/qtermy',
    '@APP_RUN_DIR@' => '/run/user/%U/qtermy',
    '@APP_TMP_DIR@' => '/tmp/qtermy%U',
    );

my %links = (
    'termy-server' => 'server',
    'termy-forwrd' => 'forwarder',
    'termy-monitor' => 'monitor',
    'termy-connect' => 'connect',
    'termy-query' => 'query',
    'termy-ssh' => 'ssh',
    'termy-sudo' => 'sudo',
    'termy-su' => 'su',
    'termy-download' => 'download',
    'termy-imgcat' => 'imgcat',
    'termy-imgls' => 'imgls',
    'termy-setup' => 'setup',
    'termy-systemd-setup' => 'systemd',
    'qtermy' =>'gui',
    'qtermy-pipe' =>'pipe',
    'termyctl' => 'ctl',
    'termy-web' => 'web',
    'termy-web-login' => 'login',
    );

my %websites = (
    'XTerm' => 'http://invisible-island.net/xterm',
    );

my $stem = '../man/';

sub make_redirect {
    my ($src,$dest) = @_;
    $dest =~ s|^man\d+/||;
    die "Unknown redirect destination $dest\n" unless exists $links{$dest};
    for (keys %links) {
        if ($links{$_} eq $src) {
            my $output = "$_\n";
            $output .= '=' x length($_);
            return $output . "\n\nRefer to :doc:`$dest <$links{$dest}>`\\ .";
        }
    }
    die "Unknown redirect source $src\n";
}

sub make_file {
    my $file = shift;
    $file =~ s/(\$\w+)/{$1}/;
    $file =~ s/(%\w)/{$1}/;
    return ":file:`$file`";
}

sub make_env {
    my $str = shift;
    if ($str =~ m/^\$(.*)/) {
        return "\$\\ :envvar:`$1`";
    } else {
        return ":envvar:`$str`";
    }
}

sub make_manpage {
    my ($page, $extra) = @_;
    die unless $extra =~ m/^(\(\d\S*?\))(.*)/;
    my $sect = $1;
    $extra = $2;
    return ":manpage:`${page}${sect}`$extra";
}

sub make_manpages {
    my $line = shift;
    $line =~ s/(\S+\(\d\S*\))/:manpage:`$1`/g;
    return $line;
}

sub make_mandocs {
    my $line = shift;
    $line =~ s/(\S+)(\(\d\S*\))/:doc:`$1 <${stem}$links{$1}>`\\ $2/g;
    return $line;
}

sub make_weblink {
    my $line = shift;
    die unless exists $websites{$line};
    return "`$line <$websites{$line}>`_";
}

sub process_file {
    my $infile = shift;
    die unless $infile =~ m|.*/([\w-]+)\.\d.*\.in$|;
    my $name = $1;
    my $outfile = "man/${name}.rst";
    my @para;
    my $indent = '';
    my $paramod = '';

    print "Processing: $infile -> $outfile ... ";

    open(IH, '<', $infile) or die;
    open(OH, '>', $outfile) or die;
    print OH ".. Copyright © $date TermySequence LLC\n";
    print OH ".. SPDX-License-Identifier: $license\n\n";
    while (<IH>) {
        chomp(my $line = $_);
        next if $line =~ m/^\.\\"/;
        my $directive = '';

        if ($line =~ m/^(.*?) ?\\"(.*)/) {
            $line = $1;
            $directive = $1 if $2 =~ m/m2r(\w+)/;
            last if $directive eq 'exit';
        }
        $line =~ s/$_/$config{$_}/g for keys %config;
        $line =~ s/\\([- ])/$1/g;
        $line =~ s/([\|@])/\\$1/g unless $directive eq 'pre';
        $line =~ s/(\S)\\fI/$1\\ */g;
        $line =~ s/\\fI/*/g;
        $line =~ s/\\fR(\S)/*\\ $1/g;
        $line =~ s/\\fR/*/g;

        if ($directive eq 'docs') {
            push @para, make_mandocs($line);
        }
        elsif ($directive eq 'mans') {
            push @para, make_manpages($line);
        }
        elsif ($directive eq 'web') {
            push @para, make_weblink($line);
        }
        elsif ($directive eq 'tt') {
            $line =~ s/"//g;
            push @para, "``$line``";
        }
        elsif ($directive eq 'code') {
            $line .= ':';
            push @para, $line;
        }

        elsif ($line =~ m/^\.so (\S+?)\.\d.*$/) {
            print OH make_redirect($name, $1), "\n";
            last;
        }
        elsif ($line =~ m/^\.TH (\S+)/) {
            print OH "$1\n", ('=' x length($1)), "\n\n";
            print OH ".. highlight:: none\n\n";
        }
        elsif ($line =~ m/^\.SH (\S.*)/) {
            (my $title = $1) =~ s/(\w+)/\u\L$1/g;
            print OH "$title\n", '-' x length($title), "\n\n";
            $indent = '';
        }

        elsif ($line eq '') {
            if ($paramod eq 'break') {
                $line = join(' ', @para);
                $line =~ s/ .br /\n$indent| /g;
                print OH "$indent| $line\n\n";
            } elsif ($paramod eq 'code') {
                $line = join(' ', @para);
                $line =~ s/ .br /\n$indent/g;
                print OH "$indent$line\n\n";
            } else {
                print OH $indent, join(' ', @para), "\n\n";
            }
            @para = ();
            $paramod = '';
        }
        elsif ($line eq '.OS') {
            next;
        }
        elsif ($line eq '.br') {
            if ($directive eq 'prebr') {
                $paramod = 'code';
            } else {
                $paramod = 'break';
            }
            push @para, $line;
        }
        elsif ($line eq '.I Note:') {
            push @para, ".. note::";
        }
        elsif ($line eq '.I Important:') {
            push @para, ".. important::";
        }
        elsif ($line eq '.I Caution:') {
            push @para, ".. caution::";
        }

        elsif ($line =~ m/^\.IP (.*)/) {
            ($line = $1) =~ s/^(\S+)/**$1**/;
            print OH "$line\n";
            $indent = '   ';
        }

        elsif ($line =~ m/^\.BR (\S+) (.*)/) {
            if ($directive eq 'man') {
                push @para, make_manpage($1, $2);
            } elsif ($directive eq 'doc') {
                push @para, ":doc:`$1 <${stem}$links{$1}>`\\ $2";
            } elsif ($directive eq 'prog') {
                push @para, ":program:`$1`\\ $2";
            } else {
                push @para, "**$1**\\ $2";
            }
        }
        elsif ($line =~ m/^\.B (\S.*)/) {
            if ($directive eq 'sect') {
                (my $title = $1) =~ s/(\w+)/\u\L$1/g;
                push @para, "`$title`_";
            } elsif ($directive eq 'doc') {
                push @para, ":doc:`$1 <${stem}$links{$1}>`";
            } elsif ($directive eq 'prog') {
                push @para, ":program:`$1`";
            } else {
                push @para, "**$1**";
            }
        }
        elsif ($line =~ m/^\.IR (\S+) (.*)/) {
            if ($directive eq 'file') {
                push @para, make_file($1) . $2;
            } elsif ($directive eq 'env') {
                push @para, make_env($1) . $2;
            } else {
                push @para, "*$1*\\ $2";
            }
        }
        elsif ($line =~ m/^\.I (\S+)/) {
            if ($directive eq 'file') {
                push @para, make_file($1);
            } elsif ($directive eq 'env') {
                push @para, make_env($1);
            } else {
                push @para, "*$1*";
            }
        }

        elsif ($line =~ m/^\$ /) {
            push @para, ":program:`$line`";
        }
        else {
            push @para, $line;
        }
    }
    if (@para) {
        print OH $indent, join(' ', @para), "\n";
    }

    close(OH);
    close(IH);
    print "done\n";
}

my $srcdir = $ENV{TERMY_HOME};
unless (defined($srcdir)) {
    print STDERR "TERMY_HOME not set, using \$HOME/git/termysequence\n";
    $srcdir = $ENV{HOME} . "/git/termysequence";
}
$srcdir .= "/doc";
die "termysequence/doc source folder not found\n" unless -d $srcdir;

process_file($_) for glob "${srcdir}/*.[0-9]*.in";
