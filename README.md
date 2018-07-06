# presto-metrics-perl
Presto metrics library for perl

# SYNOPSIS

```Perl

    use Presto::Metrics::Client;
    use Data::Dumper;

    my $client = Presto::Metrics::Client->new(
        server => 'localhost',
        port => 8080,
    );

    # node metrics : see also t/01_node_json.t
    my $node_json = $client->get_node_json();
    print Dumper $node_json;
    # [
    #   {
    #     'uri' => 'http://XXX.XXX.XXX.XXX:8080',
    #     'recentRequests' => '120.002777764918',
    #     'recentFailures' => '0'
    #     'recentSuccesses' => '120.002777764918',
    #     'lastRequestTime' => '2018-06-08T06:41:10.264Z',
    #     'lastResponseTime' => '2018-06-08T06:41:10.265Z',
    #     'recentFailureRatio' => '0',
    #     'age' => '45.91d',
    #     'recentFailuresByType' => {},
    #   },
    #   ...
    # ]

    # query metrics : see also t/02_get_query_json.t
    my $query_json = $client->get_query_json();
    print Dumper $query_json;
    # [
    #   {
    #     "queryId": "20180701_122015_00001_aaaaa",
    #     "session": {
    #       "queryId": "20180701_122015_00001_aaaaa",
    #       "transactionId": "aaaaaaaaaa",
    #       ...
    #     },
    #     "state": "RUNNING",
    #     "memoryPool": "general",
    #     "scheduled": true,
    #     "self": "http://192.168.10.1:8080/v1/query/20180701_122015_00001_aaaaa",
    #     "query": "select * from table1",
    #     "queryStats": {
    #       "createTime": "2018-07-01T12:20:15.123Z",
    #       "elapsedTime": "2.70s",
    #       "executionTime": "2.68s",
    #       ...
    #     },
    #     ...
    #   },
    #   ...
    # ]

```

