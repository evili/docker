FROM boot2docker/boot2docker
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash
RUN PIN_GITLAB=/etc/apt/preferences.d/pin-gitlab-runner.pref;\
    echo "Explanation: Prefer GitLab provided packages over the Debian native ones" > ${PIN_GITLAB};\
    echo "Package: gitlab-runner" >> ${PIN_GITLAB} \;
    echo "Pin: origin packages.gitlab.com" >> ${PIN_GITLAB};\
    echo "Pin-Priority: 1001" >> ${PIN_GITLAB} ;\
    apt-get update;
    apt-get install -y gitlab-runner

RUN echo "/etc/rc.d/opennebula-context" >> $ROOTFS/opt/bootscript.sh
RUN sed -i 's/^MAGIC=.*$/MAGIC=""/' $ROOTFS/etc/rc.d/automount

ADD opennebula-context $ROOTFS/etc/rc.d/opennebula-context

RUN /make_iso.sh
CMD ["cat", "boot2docker.iso"]
