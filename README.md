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

    # node metrics : see also t/01_node_metrics.t
    my $node_metrics = $client->get_node_metrics();
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
    #   {
    #     'uri' => 'http://YYY.YYY.YYY.YYY:8080',
    #     'recentRequests' => '120.002777764918',
    #     'recentFailures' => '0',
    #     'recentSuccesses' => '120.002777764918',
    #     'lastRequestTime' => '2018-06-08T06:41:10.265Z',
    #     'lastResponseTime' => '2018-06-08T06:41:10.265Z',
    #     'recentFailureRatio' => '0',
    #     'age' => '45.91d',
    #     'recentFailuresByType' => {},
    #   }
    # ]
```

