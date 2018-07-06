#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Mock::Furl;
use Furl::Response;

use Presto::Metrics::Client;

# set furl mock
$Mock_furl->set_isa('Furl');
$Mock_furl->mock(get => sub {Furl::Response->new});
$Mock_furl_res->mock(content => sub {
    <<"EOF";
    [
        {
            "uri":"http://192.168.10.1:8080",
            "recentRequests":10.2,
            "recentFailures":0.0,
            "recentSuccesses":10.2,
            "lastRequestTime":"2018-06-08T02:52:25.764Z",
            "lastResponseTime":"2018-06-08T02:52:25.765Z",
            "recentFailureRatio":0.0,
            "age":"1.75d",
            "recentFailuresByType":{}
        }
    ]
EOF
});

my $suv = Presto::Metrics::Client->new(
    server => '192.168.10.1',
    port   => 8080,
);
my $actual = $suv->get_node_json();

$Mock_furl->called_pos_ok(1, 'get', 'Furl method');
$Mock_furl->called_args_pos_is(1, 2, 'http://192.168.10.1:8080/v1/node', 'Furl url parameter');

is @$actual, 1, "number of nodes";
is @$actual[0]->{'uri'}, 'http://192.168.10.1:8080', 'uri';
is @$actual[0]->{'recentRequests'}, 10.2, 'recentRequests';
is @$actual[0]->{'recentFailures'}, 0, 'recentFailures';
is @$actual[0]->{'recentSuccesses'}, 10.2, 'recentSuccesses';
is @$actual[0]->{'lastRequestTime'}, '2018-06-08T02:52:25.764Z', 'lastRequestTime';
is @$actual[0]->{'lastResponseTime'}, '2018-06-08T02:52:25.765Z', 'lastResponseTime';
is @$actual[0]->{'recentFailureRatio'}, 0, 'recentFailureRatio';
is @$actual[0]->{'age'}, '1.75d', 'age';
is_deeply @$actual[0]->{'recentFailuresByType'}, {}, 'recentFailureByType';

done_testing();
