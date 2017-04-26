FROM fedora:latest

RUN /usr/bin/dnf check-update || echo "Update available"
RUN /usr/bin/dnf upgrade -y
RUN /usr/bin/dnf install -y openldap-clients openldap-servers smbldap-tools 

ONBUILD ADD slapd-conf slapd-conf
ONBUILD RUN /usr/bin/rm -f /etc/openldap/slapd.d /var/lib/ldap
ONBUILD RUN /usr/bin/mkdir -pv /etc/openldap/slapd.d /var/lib/ldap
ONBUILD RUN /usr/bin/slaptest -f slapd-conf/slapd.conf -F /etc/openldap/slapd.d
ONBUILD RUN /usr/bin/chown -R ldap:ldap /etc/openldap/slapd.d /var/lib/ldap
ONBUILD RUN /usr/bin/chmod -R u=rwX,go= /etc/openldap/slapd.d /var/lib/ldap

# Expose ldap
EXPOSE 389 636

ENTRYPOINT ["/usr/sbin/slapd", "-d", "0", "-u", "ldap", "-g", "ldap"]
CMD ["-h", "ldapi:///,ldap:///,ldaps:///"]

# LDAP dir
VOLUME ["/var/lib/ldap"]
