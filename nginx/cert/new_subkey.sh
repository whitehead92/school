#!/usr/bin/bash
mkdir $1
cd $1

openssl rand -base64 12 > $1.pass
openssl ecparam -name secp384r1 -genkey -out $1.key
openssl ec -in $1.key -passout file:$1.pass -out $1.protected.key -aes256

touch $1.ext
cat >> $1.ext <<EOF
[ req ]
prompt = no
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
distinguished_name  = rdn
req_extensions      = req_ext
x509_extensions     = x509_ext

[ rdn ]
C                   = RU
ST                  = KHV
O                   = WH
CN                  = whitehead

[ x509_ext ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer
basicConstraints        = CA:FALSE
keyUsage                = digitalSignature, keyEncipherment
subjectAltName          = @alternate_names
nsComment               = "OpenSSL Generated Certificate"

[ req_ext ]
subjectKeyIdentifier    = hash
basicConstraints        = CA:FALSE
keyUsage                = digitalSignature, keyEncipherment
subjectAltName          = @alternate_names
nsComment               = "OpenSSL Generated Certificate"

[ alternate_names ]
DNS.1 = $1
EOF


openssl req -new -key $1.key -sha512 -out $1.req -config $1.ext
openssl x509 -req -in $1.req -extfile $1.ext -extensions req_ext -days 365 -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out $1.crt