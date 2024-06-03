#### Introduction
...


#### Install 
##### Before Install
```shell
# Check your network ports
4505  # Event Publisher/Subscriber port
4506  # Data payloads and minion returns (file services/return data)

# Check system requirements
# already install salt-minion and config

# Check your permissions
```

##### Install On Ubuntu
```shell
# install repository key and create the apt sources list file
curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest jammy main" | tee /etc/apt/sources.list.d/salt.list

# install
apt update
apt install salt-master salt-minion [salt-api...]

```


##### Config and Boot
[[sc-saltstack|Salt Config]]

```shell
# boot
cat > /lib/systemd/system/salt-master.service << "EOF"
[Unit]
Description=The Salt Master Server
Documentation=man:salt-master(1) file:///usr/share/doc/salt/html/contents.html https://docs.saltproject.io/en/latest/contents.html
After=network.target

[Service]
LimitNOFILE=100000
Type=notify
NotifyAccess=all
ExecStart=/usr/bin/salt-master

[Install]
WantedBy=multi-user.target
EOF

cat > /lib/systemd/system/salt-minion.service << "EOF"
[Unit]
Description=The Salt Minion
Documentation=man:salt-minion(1) file:///usr/share/doc/salt/html/contents.html https://docs.saltproject.io/en/latest/contents.html
After=network.target salt-master.service

[Service]
KillMode=process
Type=notify
NotifyAccess=all
LimitNOFILE=8192
ExecStart=/usr/bin/salt-minion

[Install]
WantedBy=multi-user.target
EOF

systemctl enable salt-master && systemctl start salt-master
systemctl enable salt-minion && systemctl start salt-minion


# dependencies packages
# select all packages
salt-call pip.list
salt-pip install <package name>

```


#### Use
##### Accept the minion keys
```shell
# select all keys
salt-key -L

# accept key
salt-key -a db1
salt-key -A

# delete key
salt-key -d web1
salt-key -d 'web*'
salt-key -D

# verify
salt '*' test.version
salt '*' test.ping

```

##### match minion and groups
```shell
# regular 
salt '*' test.ping
salt 'web0[3-7]' test.ping

# regex pcre 
salt -E 'web*|db*' test.ping 

# list 
salt -L 'node1,node2' test.ping

# grains 
salt -G 'os:Ubuntu' test.version

# grains pcre 
salt -P 'os:Arch.*' test.ping

# custom groups 
cat /etc/salt/master.d/nodegroups.conf
nodegroups:
   FRONTEND: L@frontend1,frontend2,frontend3
   BACKEND: L@backend1,backend2,backend3
salt -N FRONTEND test.ping

# compound 
salt -C 'G@roles:apps or I@myname:yakir' test.ping

# pillar
salt -I 'myname:yakir' test.ping

# CIDR 
salt -S '192.168.1.0/24' test.ping


```

##### modules && state structure
```shell
# modules doc
salt 'node1' sys.doc
salt 'node1' sys.doc pkg[.install]
# pkg
salt 'node1' pkg.install wget
# cmd
salt 'node1' cmd.run "ls /opt"
# cp
salt 'node1' cp.get_file salt://tmp/files/1.conf /tmp/1.conf
salt 'node1' cp.get_file salt://{{grains.os}}/vimrc /etc/vimrc template=jinja

# custom module
mkdir /srv/salt/base/_modules
tee > /srv/salt/base/_modules/mydisk.py << "EOF"
def df():
    return __salt__['cmd.run']('df -h')
EOF
salt '*' saltutil.sync_modules
salt 'node1' mydisk.df


# state structure
# state sls files
tee > /srv/salt/base/package/tree.sls << "EOF"
install_tree_now:
  pkg.installed:
    - pkgs:
      - tree
EOF
tee > /srv/salt/base/package/nginx.sls << "EOF"
install_tree_now:
  pkg.installed:
    - pkgs:
      - nginx
EOF
tee > /srv/salt/base/tmp/init.sls << "EOF"
apache:
  pkg.installed:
    - pkgs:
      - httpd
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://tmp/files/httpd.conf
  service.running:
    - name: httpd
    - reload: true
    - enable: truej
    - watch:
      - file: apache
EOF

# show state sls 
salt 'node1' state.show_highstate 
salt 'node1' state.show_sls tmp.tree
salt 'node1' cp.list_states saltenv=dev

# execute top high state sls 
tee > /srv/salt/base/top.sls << "EOF"
base:
  'node1':
    - package.tree
    - package.nginx
  'node2':
    - tmp
  'frontend'
    - match: nodegroup
    - nginx
  'os:Ubuntu':
    - match: grain
    - apache
dev:
  'webserver*dev*':
    - webserver
  'db*dev*':
    - db
EOF
salt 'node1' state.highstate [--batch 10%|10] [test=True]

# execute regular state sls
salt '*' state.sls tmp[.init] [test=True]
salt '*' state.sls package.nginx [test=True] [saltenv=dev]

```

##### grains
```shell
# default cache dir
/var/cache/salt/master/minions/node1/data.p

# listening grains
salt '*' grains.ls
    - os
    - username
    ...
salt '*' grains.items
    os:
        Ubuntu
    osrelease:
        20.04
    ...

# target with grains
salt -G 'os:Ubuntu' test.version
salt -G 'host:node1' grains.item os
salt -G 'ip_interfaces:ens160:172.22.3.*' test.ping


# defining custom grains:
# in master
# option1 (save to minion /etc/salt/grains)
salt minion01 grains.setval roles "['web','app1','dev']"
# option2 (save to minion /var/cache/salt/minion/extmods/grains)
mkdir /srv/salt/base/_grains
tee > /srv/salt/base/_grains/mem.py << "EOF"
def my_grains():
    grains = {}
    grains['my_bool'] = True
    grains['my_str'] = 'str_test'
    return grains
EOF
salt minion01 saltutil.sync_grains

# in minion
# option1
tee > /etc/salt/minion.d/grains.conf << "EOF"
grains: 
  roles: app1
  project: frontend
EOF
systemctl restart salt-minion
# option2
tee > /etc/salt/grains << "EOF"
roles: app1
project: frontend
EOF
salt minion01 saltutil.sync_grains

# test
salt minion01 grains.item roles project
salt minion01 grains.item my_bool my_str
salt -G 'roles:app1' test.ping


# use state sls with grains
{{ salt['grains.get']('os') }}
{{ salt['grains.get']('os', ‘Debian’) }}

```

##### pillar
```shell
# pillar_roots
tee > /srv/salt/pillar/mypillar.sls << "EOF"
{% if grains['fqdn'] == 'node1' %}
myname: yakir
{% elif grains['fqdn'] == 'node2' %}
myname: andy
{% endif %}
port: 80
EOF

tee > /srv/salt/pillar/top.sls << "EOF"
base:
  '*':
    - mypillar
dev:
  'os:Debian':
    - match: grain
    - vim
test:
  '* and not G@os: Debian':
    - match: compound
    - emacs
EOF

salt '*' pillar.items
salt '*' saltutil.refresh_pillar
salt '*' pillar.item myname port

# use pillar by sls file
tee > /srv/salt/base/tmp/init.sls << "EOF"
apache:
  pkg.installed:
    - pkgs:
      - {{ pillar['myname'] }}
  service.running:
    - name: httpd
    - reload: true
    - enable: true
    - watch:
      - file: /etc/httpd/conf/httpd.conf

/etc/httpd/conf/httpd.conf:
  file.managed:
    - source: salt://apache/httpd.conf
EOF

salt '*' state.sls tmp.init

```


#### Salt Rosters
##### salt-ssh
```shell
# install 
apt install salt-ssh
pip install --upgrade salt-ssh

# config
cat /etc/salt/roster
node1:
  host: 192.168.1.1
  port: 22
  user: root
  passwd: test123
  timeout: 5

node2:
  host: 192.168.1.2
  port: 22
  user: root
  passwd: test123

# use
salt-ssh '*' test.ping

```



>Reference:
>1. [Official Salt Doc](https://docs.saltproject.io/salt/user-guide/en/latest/topics/overview.html)
>2. [Salt Github](https://github.com/saltstack/salt)
>3. [saltstack 中文文档](https://docs.saltstack.cn/topics/tutorials/starting_states.html)
>4. [saltstack 中文手册](https://github.com/watermelonbig/SaltStack-Chinese-ManualBook/blob/master/chapter05/05-11.Salt-Best-Practices.md)
>5. [saltstack-formulas](https://github.com/saltstack-formulas)