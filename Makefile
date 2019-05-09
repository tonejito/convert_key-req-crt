# Convert a set of KEY, REQ and CRT files into various formats with @OpenSSL
# Andrés Hernández - tonejito
# Released under the BSD license

SHELL=/bin/bash

OPENSSL=openssl

KEY=private_key
REQ=certificate_sign_request
CRT=certificate

FILES=$(shell echo ${KEY}.{pem,txt} ${REQ}.{csr,txt} ${CRT}.{crt,txt,p7b,p12})

all:	files extra

clean:
	rm -v ${FILES} || true

files:	${KEY}.txt ${REQ}.txt ${CRT}.txt

extra:	${CRT}.p7b ${CRT}.p12

${KEY}.pem:	${KEY}.key
	${OPENSSL} pkcs8 -inform DER -in ${KEY}.key -outform PEM -v2 des3 | \
	${OPENSSL} rsa -des3 -out ${KEY}.pem

${KEY}.txt:	${KEY}.pem
	${OPENSSL} rsa -in ${KEY}.pem -noout -text > ${KEY}.txt

${REQ}.csr:	${REQ}.req
	${OPENSSL} req -inform DER -in ${REQ}.req -outform PEM -out ${REQ}.csr

${REQ}.txt:	${REQ}.csr
	${OPENSSL} req -inform DER -in ${REQ}.req -noout -text > ${REQ}.txt

${CRT}.crt:	${CRT}.cer
	${OPENSSL} x509 -inform DER -in ${CRT}.cer -outform PEM -out ${CRT}.crt

${CRT}.txt:	${CRT}.crt
	${OPENSSL} x509 -in ${CRT}.crt -noout -text > ${CRT}.txt

${CRT}.p7b:	${CRT}.crt
	${OPENSSL} crl2pkcs7 -nocrl -certfile ${CRT}.crt -out ${CRT}.p7b

${CRT}.p12:	${KEY}.pem ${CRT}.crt
	${OPENSSL} pkcs12 -export -inkey ${KEY}.pem -in ${CRT}.crt -out ${CRT}.p12
