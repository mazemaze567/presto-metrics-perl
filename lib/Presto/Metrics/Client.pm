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


sub get_node_json {
    my $self = shift;
    my $url = sprintf 'http://%s:%d%s', $self->server, $self->port, $self->node_metrics_path;
    my $response = $self->furl->get($url);
    die $response->status_line unless $response->is_success;
    my $node_metrics = decode_json $response->content;
    return $node_metrics;
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

    # node metrics : see also t/01_node_metrics.t
    my $node_metrics = $client->get_node_json();
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

=head1 DESCRIPTION

xxx

=cut

