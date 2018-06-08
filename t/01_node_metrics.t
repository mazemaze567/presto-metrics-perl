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
$Mock_furl_res->mock(content => sub {'[{"uri":"http://192.168.10.1:8080","recentRequests":10.2,"recentFailures":0.0,"recentSuccesses":10.2,"lastRequestTime":"2018-06-08T02:52:25.764Z","lastResponseTime":"2018-06-08T02:52:25.765Z","recentFailureRatio":0.0,"age":"1.75d","recentFailuresByType":{}}]'});


my $suv = Presto::Metrics::Client->new(
    server => '192.168.10.1',
    port   => 8080,
);
my $actual = $suv->get_node_metrics();

is @$actual, 1, "get_node_metrics : number of nodes";
is @$actual[0]->{'uri'}, 'http://192.168.10.1:8080', 'get_node_metrics : uri';
is @$actual[0]->{'recentRequests'}, 10.2, 'get_node_metrics : recentRequests';
is @$actual[0]->{'recentFailures'}, 0, 'get_node_metrics : recentFailures';
is @$actual[0]->{'recentSuccesses'}, 10.2, 'get_node_metrics : recentSuccesses';
is @$actual[0]->{'lastRequestTime'}, '2018-06-08T02:52:25.764Z', 'get_node_metrics : lastRequestTime';
is @$actual[0]->{'lastResponseTime'}, '2018-06-08T02:52:25.765Z', 'get_node_metrics : lastResponseTime';
is @$actual[0]->{'recentFailureRatio'}, 0, 'get_node_metrics : recentFailureRatio';
is @$actual[0]->{'age'}, '1.75d', 'get_node_metrics : age';
is_deeply @$actual[0]->{'recentFailuresByType'}, {}, 'get_node_metrics : recentFailureByType';

done_testing();
