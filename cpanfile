requires 'Mouse', '==2.5.2';
requires 'namespace::autoclean', '==0.28';
requires 'Furl';
requires 'JSON::XS';

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::Mock::Furl';
}
