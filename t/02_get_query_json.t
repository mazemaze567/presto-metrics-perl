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
            "queryId": "20180701_122015_00001_aaaaa",
            "session": {
                "queryId": "20180701_122015_00001_aaaaa",
                "transactionId": "aaaaaaaaaa"
            },
            "state": "RUNNING",
            "memoryPool": "general",
            "scheduled": true,
            "self": "http://192.168.10.1:8080/v1/query/20180701_122015_00001_aaaaa",
            "query": "select * from table1",
            "queryStats": {
                "createTime": "2018-07-01T12:20:15.123Z",
                "elapsedTime": "2.70s",
                "executionTime": "2.68s"
            }
        },
        {
            "queryId": "20180701_122015_00002_bbbbb",
            "session": {
                "queryId": "20180701_122015_00002_bbbbb",
                "transactionId": "bbbbbbbbbb"
            },
            "state": "FINISHED",
            "memoryPool": "general",
            "scheduled": true,
            "self": "http://192.168.10.1:8080/v1/query/20180701_122015_00002_bbbbb",
            "query": "show tables",
            "queryStats": {
                "createTime": "2018-07-01T12:20:15.123Z",
                "endTime": "2018-07-01T12:20:16.123Z",
                "elapsedTime": "1.00s",
                "executionTime": "489.09ms"
            }
        }
    ]
EOF
});

my $suv = Presto::Metrics::Client->new(
    server => '192.168.10.1',
    port   => 8080,
);
my $actual = $suv->get_query_json();

$Mock_furl->called_pos_ok(1, 'get', 'Furl method');
$Mock_furl->called_args_pos_is(1, 2, 'http://192.168.10.1:8080/v1/query', 'Furl url parameter');

is @$actual, 2, 'number of queries';
is @$actual[0]->{'queryId'}, '20180701_122015_00001_aaaaa', '[0].queryId';
is @$actual[0]->{'state'}, 'RUNNING', '[0].state';
is @$actual[0]->{'query'}, 'select * from table1', '[0].query';
is @$actual[0]->{'queryStats'}->{'elapsedTime'}, '2.70s', '[0].queryStats.elapsedTime';
is @$actual[1]->{'queryId'}, '20180701_122015_00002_bbbbb', '[1].queryId';
is @$actual[1]->{'state'}, 'FINISHED', '[1].state';
is @$actual[1]->{'query'}, 'show tables', '[1].query';
is @$actual[1]->{'queryStats'}->{'elapsedTime'}, '1.00s', '[1].queryStats.elapsedTime';

done_testing();
