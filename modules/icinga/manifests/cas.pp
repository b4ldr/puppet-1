class icinga::cas (
    Stdlib::Host               $virtual_host     = 'icinga.example.com',
    Stdlib::Unixpath           $cookie_path      = '/var/cache/apache2/mod_auth_cas/',
    Stdlib::Unixpath           $certificate_path = '/etc/ssl/certs/',
    Stdlib::HTTPUrl            $login_url        = 'https://idp.example.org/cas/login',
    Stdlib::HTTPUrl            $validate_url     = 'https://idp.example.org/cas/samlValidate',
    String[1]                  $authn_header     = 'CAS-User',
    String[1]                  $attribute_prefix = 'X-CAS-',
    Boolean                    $debug            = false,
    Boolean                    $validate_saml    = true,
    String[1]                  $apache_owner     = 'www-data',
    String[1]                  $apache_group     = 'www-data',
    Optional[Array[String[1]]] $required_groups  = [],
) {
    $ssl_settings = ssl_ciphersuite('apache', 'strong', true)

    ensure_packages(['libapache2-mod-auth-cas'])
    httpd::mod_conf{'auth_cas':}
    file{$cookie_path:
        ensure => directory,
        owner  => $apache_owner,
        group  => $apache_group,
    }
    httpd::site {$virtual_host:
        content => template('icinga/apache-cas.erb')
    }
}


