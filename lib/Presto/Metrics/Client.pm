package Presto::Metrics::Client;
use namespace::autoclean;
use Mouse;
use Furl;
use JSON::XS;

has server => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {'localhost'},
);

has port => (
    is      => 'ro',
    isa     => 'Int',
    default => sub {8080},
);

has furl => (
    is      => 'ro',
    isa     => 'Furl',
    default => sub {
        Furl->new(
            timeout       => 180,
            max_redirects => 3,
        );
    },
);

has node_metrics_path => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {'/v1/node'},
);

has query_metrics_path => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {'/v1/query'},
);


sub get_node_json {
    my $self = shift;
    my $url = sprintf 'http://%s:%d%s', $self->server, $self->port, $self->node_metrics_path;
    my $node_json = $self->_submit_get_request($url);
    return $node_json;
}

sub get_query_json {
    my $self = shift;
    my $url = sprintf 'http://%s:%d%s', $self->server, $self->port, $self->query_metrics_path;
    my $query_json = $self->_submit_get_request($url);
    return $query_json;
}


sub _submit_get_request {
    my ($self, $url) = @_;
    my $response = $self->furl->get($url);
    die $response->status_line unless $response->is_success;
    my $json_content = decode_json $response->content;
    return $json_content;
}


1;

__END__

=encoding utf-8

=head1 NAME

Presto::Metrics::Client - Presto metrics library for perl

=head1 SYNOPSIS

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

=head1 DESCRIPTION

xxx

=cut

