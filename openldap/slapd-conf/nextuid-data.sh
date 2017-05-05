/usr/sbin/slapadd -v -F /etc/openldap/slapd.d -b ${LDAP_BASE} <<EOF

dn: cn=nextuid,${LDAP_USER_BASE}
cn: nextuid
uidNumber: 1000
userPassword: nextuid
objectClass: simpleSecurityObject
objectClass: uidNext

EOF
