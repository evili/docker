FROM fedora:latest

RUN /usr/bin/dnf check-update
RUN /usr/bin/dnf upgrade
RUN /usr/bin/dnf install -y openldap-clients openldap-servers smbldap-tools 

ONBUILD ADD slapd-conf slapd-conf
ONBUILD RUN /usr/bin/rm -f /etc/openldap/slapd.d /var/lib/ldap
ONBUILD RUN /usr/bin/mkdir -pv /etc/openldap/slapd.d /var/lib/ldap
ONBUILD RUN /usr/bin/slapcat -f slapd-conf/slapd.conf -F /etc/openldap/slapd.d
ONBUILD RUN /usr/bin/chown -R ldap:ldap /etc/openldap/slapd.d /var/lib/ldap
ONBUILD RUN /usr/bin/chmod -R u=rwX,go= /etc/openldap/slapd.d /var/lib/ldap

# Expose ldap
EXPOSE 389 636

ENTRYPOINT["/usr/sbin/slapd", "-u", "ldap", "-g", "ldap", "-h", "ldapi:///", "ldap:///", "ldaps:///"]
CMD["-d", "768"]

# LDAP dir
VOLUME ["/var/lib/ldap"]
