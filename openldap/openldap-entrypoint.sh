#!/bin/bash
#
# Variable Defaults
#
set -x
set -e
LDAP_ORGANIZATION=${LDAP_ORGANIZATION:-"Example Inc."}
LDAP_DOMAIN=${LDAP_DOMAIN:-"example.com"}
LDAP_BASE=${LDAP_BASE:-$(echo ${LDAP_DOMAIN} | awk -F. -v ORS="," '{printf "dc="$1;for(i=2;i<=NF;i++){printf ",dc="$i;}}')}
LDAP_DB_DIR=${LDAP_DB_DIR:-$(echo ${LDAP_DOMAIN} | awk -F. '{print $1}')}
LDAP_TOP_DN=$(echo ${LDAP_BASE} | awk -F, '{print $1}' |awk -F'=' '{print $1": "$2}')
LDAP_TOP_OBJECT_CLASS=${LDAP_TOP_OBJECT_CLASS:-"dcObject"}
LDAP_DOMAIN=${LDAP_DOMAIN:-"example.conf"}
LDAP_ADMIN_USER=${LDAP_ADMIN_USER:-"cn=admin,${LDAP_BASE}"}
LDAP_ADMIN_PASSWORD=${LDAP_ADMIN_PASSWORD:-"admin"}
# redirect to log file
exec > /var/lib/ldap/entrypoint.log 2>&1
pushd /var/tmp/slapd-conf
#
# LDAP Main Database
#
/usr/bin/mkdir -pv /var/lib/ldap/${LDAP_DB_DIR}
/usr/bin/cat<<EOF >> ./slapd.conf

database        mdb
suffix          "${LDAP_BASE}"
rootdn          "${LDAP_ADMIN_USER}"
rootpw          ${LDAP_ADMIN_PASSWORD}
directory       /var/lib/ldap/${LDAP_DB_DIR}
index default   sub

EOF
#
# Init LDAP Database
#
/usr/sbin/slaptest -v -f ./slapd.conf -F /etc/openldap/slapd.d

#
# Add initial entriesw
#
/usr/sbin/slapadd -v -F /etc/openldap/slapd.d -b ${LDAP_BASE} <<EOF
dn: ${LDAP_BASE}
${LDAP_TOP_DN}
objectClass: ${LDAP_TOP_OBJECT_CLASS}
objectClass: organizationalUnit
ou: ${LDAP_ORGANIZATION}

dn: ou=people,${LDAP_BASE}
ou: people
objectClass: organizationalUnit

dn: ou=group,${LDAP_BASE}
ou: group
objectClass: organizationalUnit


EOF
#
# Add any other Data in directory. It should be written as a shell
# script with environment variables using the same method as the
# initial entries. That is, an slapadd with redirection so that
# environment variables are honored.
#
for d in ./*-data.sh
do
    source ${d}
done
#
# Fix owner and permissions
#
/usr/bin/chown -R ldap:ldap /etc/openldap/slapd.d /var/lib/ldap
/usr/bin/chmod -R u=rwX,go= /etc/openldap/slapd.d /var/lib/ldap
#
# Start LDAP Server
#
exec /usr/sbin/slapd -4 -d config -u ldap -g ldap -h ldap:/// "$@"
