#!/bin/bash -e

# Convert a set of KEY, REQ and CRT files into various formats with @OpenSSL
# Andrés Hernández - tonejito
# Released under the BSD license

KEY=private_key.key
REQ=certificate_sign_request.req
CRT=certificate.cer

echo ${KEY} ${REQ} ${CRT} | xargs -n 1 test -e

make