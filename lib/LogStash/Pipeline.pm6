#!/usr/bin/env perl6-m
use v6;
unit class LogStash::Pipeline;
use LogStash::Config::Grammar;
use LogStash::Config::Actions;

has Int $.filterworker = 1;
has Str $.conf;
has Hash $!config;

has %.plugins;
has Supply $.input_to_filter = .new;
has Supply $.filter_to_output is rw = .new;
has Promise @.inputArray;
has Promise @.filterArray;

method load_plugin (Str $type, Pair $plugin) {
    my $name = $plugin.key;
    my %options = $plugin.value;
    my $className = "LogStash::" ~ tc($type) ~ "::" ~ tc($name);
    return %.plugins{$className} if %.plugins{$className}:exists;
    if %options{'codec'}:exists {
        %options{'codec'} = load_plugin('codec', %options{'codec'});
    }
    require ::($className);
    my $obj = ::($className).new(%options);
    $obj.register();
    %.plugins{$className} = $obj;
    return %.plugins{$className};
}

# seems like `require` can't work inside `start {}`
method start_inputs {
    my @input_plugins = @($!config{'inputs'}).map: -> $input {
        $.load_plugin('input', $input)
    };
    for @input_plugins -> $plugin {
        my $inputPromise = start {
            $plugin.run($.input_to_filter);
        };
        @.inputArray.push($inputPromise);
    }
}

#|{use channel for multiple workers}
method start_filters {
    my @filter_plugins = @($!config{'filters'}).map: -> $filter {
        $.load_plugin('filter', $filter)
    };
    for ^$!filterworker {
        my $filterPromise = start {
            loop {
                earliest $.input_to_filter.Channel {
                    more * -> $event {
                        for @filter_plugins -> $plugin {
                            $plugin.filter($event);
                        }
                        $.filter_to_output.emit($event);
                    }
                    done * {
                        last;
                    }
                }
            }
        };
        @.filterArray.push($filterPromise);
    }
}

#|{each output plugin tap the Supply}
method start_outputs {
    my @output_plugins = @($!config{'outputs'}).map: -> $output {
        $.load_plugin('output', $output)
    };
    for @output_plugins -> $plugin {
        $.filter_to_output.tap( -> $event {
            $plugin.receive($event);
        });
    };
}

method run {
    if !$!config {
        my $grammar = LogStash::Config::Grammar.new;
        my $actions = LogStash::Config::Actions.new;
        $!config = $grammar.parse($!conf, :actions($actions)).made;
    }
    if $!config{'filters'}:exists {
        $.start_filters
    } else {
        $.filter_to_output = $.input_to_filter;
    }
    $.start_outputs;
    # start input loop at last
    $.start_inputs;
    my $p = Promise.allof(@.inputArray, @.filterArray);
    say $p.status;
    $.input_to_filter.done();
    $.filter_to_output.done();
    await $p;
}

# vim:filetype=perl6
