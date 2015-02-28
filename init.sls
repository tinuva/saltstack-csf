csf_install:
  cmd.run:
    {% if grains['panel'] is defined %}
      {% if grains['panel'] == "directadmin" %}
    - name: wget http://www.configserver.com/free/csf.tgz && tar xvf csf.tgz && cd csf && bash ./install.directadmin.sh && rm -rf /tmp/csf.tgz && rm -rf /tmp/csf
      {% else %}
    - name: wget http://www.configserver.com/free/csf.tgz && tar xvf csf.tgz && cd csf && bash ./install.sh && rm -rf /tmp/csf.tgz && rm -rf /tmp/csf
      {% endif %}
      {% else %}
    - name: wget http://www.configserver.com/free/csf.tgz && tar xvf csf.tgz && cd csf && bash ./install.sh && rm -rf /tmp/csf.tgz && rm -rf /tmp/csf
      {% endif %}
    - cwd: /tmp
    - creates: /etc/csf

csf:
  pkg.installed:
    - pkgs:
      - iptables
      - libwww-perl
    - require_in:
      - '*'
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/csf/csf.conf
      - file: /etc/csf/csf.allow
      - file: /etc/csf/csf.deny
      - file: /etc/csf/csf.ignore
      - file: /etc/csf/csfpre.sh

csf_reload:
  cmd.wait:
    - name: csf -r
    - watch:
      - service: csf
lfd:
  service:
    - running
    - enable: True

csf_ignore:
  file.managed:
    - source: salt://csf/config/etc/csf/csf.ignore
    - name: /etc/csf/csf.ignore
    - user: root
    - group: root
    - mode: 664
    - template: jinja

csf_allow:
  file.managed:
    - source: salt://csf/config/etc/csf/csf.allow
    - name: /etc/csf/csf.allow
    - user: root
    - group: root
    - mode: 664
    - template: jinja
csf_deny:
  file.managed:
    - source: salt://csf/config/etc/csf/csf.deny
    - name: /etc/csf/csf.deny
    - user: root
    - group: root
    - mode: 664
    - template: jinja

csf_config:
  file.managed:
    - source: salt://csf/config/etc/csf/csf.conf
    - name: /etc/csf/csf.conf
    - user: root
    - group: root
    - mode: 664
    - template: jinja

#Blank CSFPRE to allow for watch
csf_csfpre:
  file.managed:
    - source: salt://csf/config/etc/csf/csfpre.sh
    - name: /etc/csf/csfpre.sh
