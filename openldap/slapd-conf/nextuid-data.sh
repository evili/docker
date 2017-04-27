/usr/sbin/slapadd -v -F /etc/openldap/slapd.d -b ${LDAP_BASE} <<EOF

dn: cn=nextUid,ou=people,${LDAP_BASE}
cn: nextUid
uidNumber: 1000
userPassword: nextUid
objectClass: simpleSecurityObject
objectClass: uidNext

EOF
