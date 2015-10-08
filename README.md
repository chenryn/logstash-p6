# logstash-p6

Write LogStash in Perl6 -Ofun

## Plugin Design (Different with offical JRuby version)

Use `Supply` for `LogStash::Event` stream, so input plugins please use `$supply.emit($event)` instead of `$channel.send($event)`.

Perl6 don't support methodname mixin with character and symbol, so filter plugins please use `is_filter` instead of `filter?`, output plugins please use `is_output` instead of `output?`.

## Bugs

* Perl6 can't use `$*IN` in `Promise.start` thread, so `LogStash::Input::Stdin` thread is broken.

## Todo

* Grammar. Only support logstash v1.2 syntax now.
* More plugins. Maybe use `NativeCall` for grok, and JVM for elasticsearch?
