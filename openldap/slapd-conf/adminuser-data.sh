/usr/sbin/slapadd -v -F /etc/openldap/slapd.d -b ${LDAP_BASE} <<EOF

dn: ${LDAP_ADMIN_USER}
${LDAP_ADMIN_DN}
userPassword: ${LDAP_ADMIN_PASSWORD}
objectClass: simpleSecurityObject
objectClass: ${LDAP_ADMIN_OBJECT_CLASS}

EOF
