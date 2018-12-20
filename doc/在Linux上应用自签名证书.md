Generate a certificate issued by own CA (see the script below)

Here's what I've found. Correct me where I'm wrong.

There are CA's (certificate authorities). They issue certificates (sign CSR's) for other CA's (intermediate CA's), or servers (end entity certificates). Some of them are root authorities. They have self-signed certificates, issued by themselves. That is, usually there's a chain of trust that goes from server certificate to root certificate. And there's noone to vouch for a root certicate. As such, OS'es have a root certificate store (or trust policy store), a systemwide list of trusted root certificates. Browsers have their own lists of trusted certificates, which consist of systemwide list plus certificates trusted by the user.

In Chromium you manage certificates at chrome://settings/certificates. In Firefox, Preferences > Privacy & Security > Certificates > View Certificates. Both have Authorities tab, which is a list of trusted root certificates. And Servers tab, a list of trusted server certificates.

To obtain a certificate you create CSR (certificate signing request), send it to CA. CA signs the CSR, turning it into trusted certificate in the process.

Certificates and CSR's are a bunch of fields with information plus public key. Some of the fields are called extensions. CA certificate is a certificate with "basicConstraints = CA:true".

You can inspect certificate errors in Chromium in Developer Tools > Security.

##### Trusting certificates systemwide

When you change OS' root certificate store, you've got to restart a browser. You change it with:

```
# trust anchor path/to/cert.crt
# trust anchor --remove path/to/cert.crt
```

`trust` puts CA certificates under "authority" category (`trust list`), or "other-entry" category otherwise. CA certificates appear in Authorities tab in browsers, or else in Servers tab.

##### Trusting certificates in a browser

In Chromium, and Firefox you can add (import) certificates to Authorities tab. If you try to import a non-CA certificate, you get "Not a Certificate Authority" message. After choosing a file, a dialog appears where you can specify trust settings (when to trust the certificate). The relevant setting for making a site work is "Trust this certificate for identifying websites."

In Chromium, you can add (import) certificates on Servers tab. But they end up either on Authorities tab (CA certificates, and you're not presented with trust settings dialog after choosing a file), or on Others tab (if non-CA certificate).

In Firefox, you can't exactly add a certificate to Servers tab. You add exceptions. And you can trust a certificate with no extensions at all there.

##### Self-signed certificate extensions

My system comes with the following default settings (extensions to be added) for certificates:

```
basicConstraints = critical,CA:true
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
```

Taken from /etc/ssl/openssl.cnf, section v3_ca. More on it [here](https://jlk.fjfi.cvut.cz/arch/manpages/man/core/openssl/x509v3_config.5ssl.en).

Additionally, Chromium considers a certificate invalid, when it doesn't have:

```
subjectAltName = DNS:$domain
```

##### Non-self-signed certificate extensions

From section [ usr_cert ] of /etc/ssl/openssl.cnf:

```
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
```

##### When browsers trust a self-signed certificate

For Chromium to trust to a self-signed certificate it's got to have "basicConstraints = CA:true", and "subjectAltName = DNS:$domain". For Firefox not even this is enough:

```
basicConstraints = critical,CA:true
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
subjectAltName = DNS:$domain
```

##### When browsers trust a certificate issued by own CA

Firefox needs no extensions, but Chromium requires subjectAltName.

##### Using openssl

`openssl genpkey -algorithm RSA -out "$domain".key` - generate private [key](https://jlk.fjfi.cvut.cz/arch/manpages/man/core/openssl/genpkey.1ssl.en)

`openssl req -x509 -key "$domain".key -out "$domain".crt` - generate self-signed [certificate](https://jlk.fjfi.cvut.cz/arch/manpages/man/core/openssl/req.1ssl.en)

Without `-subj` it will ask questions regarding distinguished name (DN), like common name (CN), organization (O), locality (L). You can answer them "in advance": `-subj "/CN=$domain/O=$org"`.

To add subjectAltName extension, you've got to either have a config where it all is specified, or add a section to config and tell openssl its name with `-extensions` switch:

```
    -config <(cat /etc/ssl/openssl.cnf - <<END
[ x509_ext ]
basicConstraints = critical,CA:true
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
subjectAltName = DNS:$domain
END
    ) -extensions x509_ext
```

`openssl req -new -key "$domain".key -out "$domain".csr` - generate [CSR](https://jlk.fjfi.cvut.cz/arch/manpages/man/core/openssl/req.1ssl.en), it can take `-subj` option

`openssl x509 -req -in "$domain".csr -days 365 -out "$domain".crt \
​    -CA ca.crt -CAkey ca.key -CAcreateserial` - sign [CSR](https://jlk.fjfi.cvut.cz/arch/manpages/man/core/openssl/x509.1ssl.en)

Doesn't work without `-CAcreateserial`. It creates a ca.srl file, where it keeps serial number of the last generated certificate. To add subjectAltName, you're gonna need `-extfile` switch:

```
    -extfile <(cat <<END
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
subjectAltName = DNS:$domain
END
    )
```

`openssl req -in $domain.csr -text -noout` - view [CSR](https://jlk.fjfi.cvut.cz/arch/manpages/man/core/openssl/req.1ssl.en)

`openssl x509 -in $domain.crt -text -noout` - view [certificate](https://jlk.fjfi.cvut.cz/arch/manpages/man/core/openssl/x509.1ssl.en)

##### Generate self-signed certificate

(you're gonna need an exception in Firefox for it to work)

```
#!/usr/bin/env bash
set -eu
org=localhost
domain=localhost

sudo trust anchor --remove "$domain".crt || true

openssl genpkey -algorithm RSA -out "$domain".key
openssl req -x509 -key "$domain".key -out "$domain".crt \
    -subj "/CN=$domain/O=$org" \
    -config <(cat /etc/ssl/openssl.cnf - <<END
[ x509_ext ]
basicConstraints = critical,CA:true
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
subjectAltName = DNS:$domain
END
    ) -extensions x509_ext

sudo trust anchor "$domain".crt
```

##### Generate a certificate issued by own CA

```
#!/usr/bin/env bash
set -eu
org=localhost-ca
domain=localhost

sudo trust anchor --remove ca.crt || true

openssl genpkey -algorithm RSA -out ca.key
openssl req -x509 -key ca.key -out ca.crt \
    -subj "/CN=$org/O=$org"

openssl genpkey -algorithm RSA -out "$domain".key
openssl req -new -key "$domain".key -out "$domain".csr \
    -subj "/CN=$domain/O=$org"

openssl x509 -req -in "$domain".csr -days 365 -out "$domain".crt \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -extfile <(cat <<END
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
subjectAltName = DNS:$domain
END
    )

sudo trust anchor ca.crt
```

##### Webserver configuration

Nginx:

```
server {
    listen  443  ssl;
    ssl_certificate  ssl/localhost.crt;
    ssl_certificate_key  ssl/localhost.key;
    ...
```

Morbo:

```
carton exec morbo --listen='https://*:3000?cert=localhost.crt&key=localhost.key' site.pl
```

P.S. I'm running Chromium 65.0.3325.162, Firefox 59.0, and openssl-1.1.0.g.