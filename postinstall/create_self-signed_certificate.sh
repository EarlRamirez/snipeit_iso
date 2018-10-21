#! /bin/bash

# Create a Snipe-IT Self-signed SSL certificate

COUNTRY_NAME=US
STATE=Florida
LOCALITY=Miami
ORGANISATION=Inventory
ORGANISATION_UNIT=AssetManagement
COMMON_NAME=snipeit
EMAIL=snipeit@localdomain.com




# Create SSL certificate
GEN_CERT="openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -keyout /etc/pki/tls/private/snipeit-selfsigned.key -out /etc/pki/tls/certs/snipeit-selfsigned.crt"

# Automated configuration for securing MySQL/MariaDB		
echo "* Generate Self-Signed Certificate."
GENERATE_CERT=$(expect -c "
set timeout 10
spawn $GEN_CERT
expect \"Country Name (2 letter code) \[XX\]:\"
send \"$COUNTRY_NAME\r\"
expect \"State or Province Name (full name) \[\]:\"
send \"$STATE\r\"
expect \"Locality Name (eg, city) \[Default City\]:\"
send \"$LOCALITY\r\"
expect \"Organization Name (eg, company) \[Default Company Ltd\]:\"
send \"$ORGANISATION\r\"
expect \"Organizational Unit Name (eg, section) \[\]:\"
send \"$ORGANISATION_UNIT\r\"
expect \"Common Name (eg, your name or your server's hostname) \[\]:\"
send \"$COMMON_NAME\r\"
expect \"Email Address \[\]:\"
send \"$EMAIL\r\"
expect eof
")
echo "$GENERATE_CERT"
echo ""

# Create Diffie-Hellman group
echo "Generate DH Parameters"
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
echo ""

# Append SSLOpenSSLConfCmd to the certificate
echo "Appening DH Parameters to Certificate"
cat /etc/ssl/certs/dhparam.pem | sudo tee -a /etc/ssl/certs/snipeit-selfsigned.crt
echo ""


