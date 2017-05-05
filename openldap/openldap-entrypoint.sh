#!/bin/bash
#
# Variable Defaults
#

#
# Returns the LDIF pari from any DN:
# get_dn_pair   "dn: cn=something,ou=there,dc=any,dc=where"  ==
#               "cn: something"
function get_dn_pair()
{
    echo $1  | awk -F, '{print $1}' | awk -F'=' '{print $1": "$2}'
}
set -x
set -e
LDAP_ORGANIZATION=${LDAP_ORGANIZATION:-"Example Inc."}
LDAP_DOMAIN=${LDAP_DOMAIN:-"example.com"}
LDAP_BASE=${LDAP_BASE:-$(echo ${LDAP_DOMAIN} | awk -F. -v ORS="," '{printf "dc="$1;for(i=2;i<=NF;i++){printf ",dc="$i;}}')}
LDAP_USER_BASE=${LDAP_USER_BASE:-"ou=people,${LDAP_BASE}"}
LDAP_USER_BASE_DN=$(get_dn_pair ${LDAP_USER_BASE})
LDAP_GROUP_BASE=${LDAP_GROUP_BASE:-"ou=group,${LDAP_BASE}"}
LDAP_GROUP_BASE_DN=$(get_dn_pair ${LDAP_GROUP_BASE})
LDAP_DB_DIR=${LDAP_DB_DIR:-$(echo ${LDAP_DOMAIN} | awk -F. '{print $1}')}
LDAP_TOP_DN=$(get_dn_pair ${LDAP_BASE})
LDAP_TOP_OBJECT_CLASS=${LDAP_TOP_OBJECT_CLASS:-"dcObject"}
LDAP_DOMAIN=${LDAP_DOMAIN:-"example.conf"}
LDAP_ADMIN_USER=${LDAP_ADMIN_USER:-"cn=admin,${LDAP_BASE}"}
LDAP_ADMIN_DN=$(get_dn_pair ${LDAP_ADMIN_USER})
LDAP_ADMIN_OBJECT_CLASS=${LDAP_ADMIN_OBJECT_CLASS:-"organizationalRole"}
LDAP_ADMIN_PASSWORD=${LDAP_ADMIN_PASSWORD:-"admin"}
# redirect to log file
exec > /var/lib/ldap/entrypoint.log 2>&1
pushd /var/tmp/slapd-conf
#
# LDAP Main Database
#
/usr/bin/mkdir -pv /var/lib/ldap/${LDAP_DB_DIR}
/usr/bin/cat<<EOF >> ./slapd.conf
#
# Monitor database
#
database monitor

#
# Main database
#
database        mdb
suffix          "${LDAP_BASE}"
rootdn          "${LDAP_ADMIN_USER}"
rootpw          ${LDAP_ADMIN_PASSWORD}
directory       /var/lib/ldap/${LDAP_DB_DIR}
index default   sub
#
# Auth permissions
#
access to attrs=userPassword,sambaLMPassword,sambaNTPassword 
 by self write
 by * auth

#
# nextUid permissions
#
access to dn.subtree="cn=nextuid,${LDAP_USER_BASE}"
       by self write 
       by * read


#
# Generic permissions
#
access to dn.subtree="${LDAP_BASE}" 
 by * read


EOF
#
# Init LDAP Database
#
/usr/sbin/slaptest -v -f ./slapd.conf -F /etc/openldap/slapd.d || \
    /usr/sbin/slaptest -u -f ./slapd.conf -F /etc/openldap/slapd.d

#
# Add initial entriesw
#
/usr/sbin/slapadd -v -F /etc/openldap/slapd.d -b ${LDAP_BASE} <<EOF

dn: ${LDAP_BASE}
${LDAP_TOP_DN}
objectClass: ${LDAP_TOP_OBJECT_CLASS}
objectClass: organizationalUnit
ou: ${LDAP_ORGANIZATION}

dn: ${LDAP_USER_BASE}
${LDAP_USER_BASE_DN}
objectClass: organizationalUnit

dn: ${LDAP_GROUP_BASE}
${LDAP_GROUP_BASE_DN}
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
