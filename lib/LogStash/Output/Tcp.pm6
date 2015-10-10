#!/usr/bin/env perl6-m
use v6;
use LogStash::Output::Base;
class LogStash::Output::Tcp does LogStash::Output::Base {
    has $.host is rw;
    has $.port is rw = 3333;

    multi method client(&code) {
        my $p = Promise.new;
        my $v = $p.vow;

        my $client = IO::Socket::Async.connect($.host, $.port).then(-> $sr {
            if $sr.status == Kept {
                my $socket = $sr.result;
                code($socket, $v);
            } else {
                $v.break($sr.cause);
            }
        });
        $p
    }
    
    multi method client(Str $message) {
        $.client(-> $socket, $vow {
            $socket.print($message).then(-> $wr {
                if $wr.status == Broken {
                    $vow.break($wr.cause);
                    $socket.close();
                }
            });
            my @chunks;
            $socket.chars-supply.tap(-> $chars { @chunks.push($chars) },
                done => {
                    $socket.close();
                    $vow.keep([~] @chunks);
                },
                quit => { $vow.break($_); }
            )
        });
    }
    method register () {
        $.host //= gethostname;
        $.codec.on_event = sub ($event) {
            await $.client($event);
        };
    }
    method receive ( $event ) {
        return unless $.is_output($event);
        $.codec.encode($event);
    }
}
# set filetype=perl6
