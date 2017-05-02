/usr/sbin/slapadd -v -F /etc/openldap/slapd.d -b ${LDAP_BASE} <<EOF

dn: cn=users,ou=group,${LDAP_BASE}
cn: users
gidNumber: 1000
labeledURI: ldap:///ou=people,${LDAP_BASE}?uid?sub?(gidNumber=1000)
objectClass: posixGroup

dn: cn=ticusers,ou=group,${LDAP_BASE}
cn: ticusers
labeledURI: ldap:///ou=people,${LDAP_BASE}?uid?sub?(gidNumber=1001)
gidNumber: 1001
objectClass: posixGroup

EOF
