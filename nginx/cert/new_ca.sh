#!/usr/bin/bash
mkdir $1
cd $1

openssl rand -base64 12 > $1.pass
openssl ecparam -name secp384r1 -genkey -out $1.key
openssl ec -in $1.key -passout file:$1.pass -out $1.protected.key -aes256

touch $1.cnf
cat > $1.cnf <<EOF
[ ca ]
default_ca          = my_ca

[ my_ca ]
dir                 = .
database            = index.txt
serial              = serial
default_md          = sha512
policy              = policy_strict

[ policy_strict ]
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
prompt = no
distinguished_name  = rdn

[ rdn ]
C                   = RU
ST                  = KHV
O                   = WH
CN                  = whitehead
EOF

openssl req -new -config $1.cnf -key $1.key -sha512 -out $1.req

touch index.txt
echo '01'>serial

openssl ca -batch -days 4000 -config $1.cnf -keyfile $1.key -in $1.req -selfsign -out $1.crt -outdir .

# openssl req -x509 -new -nodes -key $1.key -sha512 -days 4000 -config $1.cnf -out $1.pem