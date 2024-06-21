### ansible
#### ansible(ad-hoc modules)
```bash
# command usage
# optional arguments
--vault-password-file VAULT_PASSWORD_FILES
-B --backgroud SECONDS
-C --check 
-D --diff
-P --poll POLL_INTERVAL
-a --args MODULE_ARGS
-e --extra-vars EXTRA_VARS
-f --forks FORKS
-i --inventory INVENTORY
-m --module-name MODULE_NAME
-t --tree TREE
# Privilege Escalation Options
--become-method BECOME_METHOD
--become-user BECOME_USER
-K --ask-become-pass
-b --become 
# Connection Options
--private-key PRIVATE_KEY_FILE
--ssh-extra-args SSH_EXTRA_ARGS
-T --timeout TIMEOUT
-k --ask-pass
-u --user REMOTE_USER
-vvvv --verbose


# check all hosts
ansible all --list-hosts [-i inventories/test.host]
ansible all -m ping 
ansible '*' -m ping
# pattern hosts
ansible '192.*' -m ping
ansible 'db*' -m ping 
ansible 'web:&db' -m ping
ansible 'web:db' -m ping
ansible 'web:!db' -m ping
ansible "~(web|db).*\.example\.com" –m ping


# Common modules
# shell or script
ansible test -m command -a 'echo test'
ansible test -m shell -a 'chdir=/opt/ ls'
ansible test -m script -a /tmp/t.sh
# file or git transfer
ansible test -m copy -a "src=/tmp.t.sh dest=/tmp/t.sh mode=600 backup=yes"
ansible test -m file -a "dest=/etc/ansible/facts.d/ state=directory"
ansible test -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"
ansible test -m lineinfile
ansible test -m replace
# managing packages
ansible test -m apt -a "name=acme state=present"
ansible test -m yum -a "name=acme state=absent"
ansible test -m package -a "name=ntpdate state=absent"
# users and groups
ansible test -m user -a "name=nobody group=nobody state=present"
# managing services
ansible test -m service -a "name=httpd state=restarted"
ansible web -m systemd -a "name=httpd state=started"
# managing firewall
ansible test -m iptables -a "chain=INPUT destination_port=22 protocol=tcp jump=ACCEPT"
ansible test -m firewalld -a "service=https permanent=yes state=enabled"
# time limited background operations
ansible test -B 300 -P 2 -a "sleep 30"
ansible test -m async_status -a "jid=488359678239.2844"
```

#### vars && fact && template
##### vars
```bash
# how to define
# 1. extra vars
-e "init_hosts=10.0.10.12,10.0.10.13" --check
-e '{"foo":"bar","numbers":["one","two"]}'
-e @variables.yaml
# 2. inventory vars
host1 http_port=80
[webservers:vars]
ntp_server=ntp.example.com
# 3. playbook: vars, include_vars, vars_files, vars_prompt, registered vars
- hosts: webservers
  vars:
    http_port: 80
  tasks:
    include_vars: myvars.yml
  vars_files:
    - /vars/external_vars.yml
  vars_prompt:
    - name: root_password
      prompt: 'Please input the root password:'
      private: yes
---
  tasks:
    - shell: uptime
      register: result
    - name: show uptime
      debug: var=result
# 4. role: roles/x/defaults/main.yml, roles/x/vars/main.yml
http_port: 80
# 5. fact
- host: 
  tasks:
    - command: whoami
      register: result
    - set_fact: w={{result.stdout}}
    - debug: var=w

# priority
https://ansible.leops.cn/basic/Variables/#_3

# variable range
https://ansible.leops.cn/basic/Variables/#_4

# how to use
# 1. jinja2: template, vars
- hosts: test
  template: src=foo.cfg.j2 dest={{ remote_install_path }}/foo.cfg
  vars:
    app_path: "{{ base_path }}/22"
# 2. fact
- name: yakir test
  hosts: test
  tasks:
    - name: debug test
#      debug: msg={{ ansible_facts }}
      debug: msg={{ ansible_facts["default_ipv4"]["address"] }}
# 3. Built in variables
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html
```

##### fact
```bash
# ansible setup info
ansible test -m setup
ansible test -m setup -a 'filter=ansible_eth*'


# custom fact
cat > playbooks/fact_test.yml << "EOF"
- name: facts test
  hosts: test
  tasks:
     - name: create directory for ansible custom facts
       file: state=directory recurse=yes path=/opt/ansible/facts.d
     - name: install custom test fact
       copy:
         content: |
           [forbid]
           foor=bar
         dest: /opt/ansible/facts.d/forbidden.fact
     - name: re-read facts after adding custom fact
       setup: filter=ansible_local
     - name: ansible_local vars
       debug: msg={{ansible_local}}
       # debug: var=ansible_local
EOF
ansible-playbook playbooks/fact_test.yml


# third cache: ansible.cfg
fact_caching_connection = localhost:6379:0:admin
fact_caching_connection = localhost:11211


# flush cache
ansible-playbook --flush-cache playbooks/template.yml
```

##### template
```bash
# jinja2 template
ansible test -m debug -a "msg={{ now(utc='True',fmt='%H-%m-%d %T') }}"

# use jinja2
vars:
  motd_value: "{{ lookup('file', '/etc/motd') }}"
tasks:
  - debug:
      msg: "motd value is {{ motd_value }}"
tasks:
  - shell: cat /some/path/to/file.json
    register: result

  - set_fact:
      myvar: "{{ result.stdout | from_json }}"
```

#### ansible-console
```bash
ansible-console test

root@all (1)[f:5]$ ping
10.0.0.1 | SUCCESS => {
    "changed": false, 
    "ping": "pong"

}
```

#### ansible-doc
```bash
# List available plugins
ansible-doc --list

# show infomation
ansible-doc file
ansible-doc -t become -l
ansible-doc -j ping
ansible-doc -s ping
```

#### ansible-galaxy
```bash
# collections
ansible-galaxy collection


# roles

# manual init template role and define tasks
ansible-galaxy role search nginx
ansible-galaxy role install nginx
ansible-galaxy role info nginx
ansible-galaxy role init /opt/ansible/roles/nginx

# online role
ansible-galaxy list
ansible-galaxy install geerlingguy.redis
ansible-galaxy remove geerlingguy.redis
```

#### ansible-lint
```bash
# install
pip install ansible-lint

# use
ansible-lint playbooks/template.yml
```

#### ansible-playbook
```bash
# execute example playbook
ansible-playbook playbooks/template.yml
# execute playbook use extra vars hosts
ansible-playbook -i inventories/initial.hosts playbooks/initial.yml -e "init_hosts=10.0.10.12,10.0.10.13" --check


# optional arguments
--ask-vault-pass
--flush-cache
--list-hosts
--list-tags
--list-tasks
--start-at-task START_AT_TASK
--step
--syntax-check
-C --check
-D --diff
-i --inventory INVENTORY
# Privilege Escalation Options
--become-method BECOME_METHOD
--become-user BECOME_USER
-K --ask-become-pass
-b --become 
# Connection Options
--private-key PRIVATE_KEY_FILE
--ssh-extra-args SSH_EXTRA_ARGS
-T --timeout TIMEOUT
-k --ask-pass
-u --user REMOTE_USER
-vvvv --verbose


# import 
# roles/example/tasks/main.yml
- name: added in 2.4, previously you used 'include'
  import_tasks: redhat.yml
  when: ansible_facts['os_family']|lower == 'redhat'
- import_tasks: debian.yml
  when: ansible_facts['os_family']|lower == 'debian'
# roles/example/tasks/redhat.yml
- yum:
    name: "httpd"
    state: present
# roles/example/tasks/debian.yml
- apt:
    name: "apache2"
    state: present

# include
- hosts: test
  tasks:
    - include_tasks: "{{inventory_hostname}}.yml"
    - include_tasks: other.yml param={{item}}
      loop: "{{ items | flatten(levels=1) }}"
    - include_role:
        name: example

- name: include vars
  include_vars: "{{ lookup('first_found', possible_files) }}"
  vars:
    possible_files:
      - "{{ ansible_distribution }}.yaml"
      - "{{ ansible_os_family }}.yaml"
      - default.yaml


# become


# asynchronous


# debuger


# step task
ansible-playbook playbooks/template.yml --start-at-task="install packages"
ansible-playbook playbooks/template.yml --step


```

#### ansible-vault
```bash
# file
ansible-vault create playbooks/new.yml
ansible-vault encrypt playbooks/template.yml
ansible-vault view playbooks/template.yml
ansible-vault decrypt playbooks/template.yml
--vault-id
--vault-password-file

# use encrypt playbook
ansible-vault encrypt --vault-id playbook@prompt playbooks/template.yml
ansible-playbook playbooks/template.yml --ask-vault-pass


# string
ansible-vault encrypt_string 'pwd123' --name 'root_password'
#write vars to playbook
ansible-playbook playbooks/template.yml --ask-vault-pass
```

### saltstack
#### module
```bash
# command module
salt '*' cmd.run 'ls /tmp'
salt '*' cp.get_file salt://nginx/files/nginx.conf /tmp/nginx.conf


# doc module
salt 'node1' sys.doc saltutil
```

#### state
```bash
# show state sls
salt 'node1' state.show_highstate [saltenv=dev]
salt 'node1' state.show_sls template [saltenv=dev]
salt 'node1' cp.list_states [saltenv=dev]


# execute state
salt 'node1' state.sls core.init [saltenv=dev] [test=True]


# top highstate
salt 'node1' state.highstate [--batch 10%|10] [test=True]
```

#### grains
```bash
salt '*' saltutil.refresh_grains [saltenv=base|dev|prod]
salt '*' saltutil.sync_grains
salt '*' grains.ls
salt '*' grains.items
salt '*' grains.item username
```

#### pillar
```bash
salt '*' saltutil.refresh_pillar [pillarenv=base|dev|prod]
salt '*' pillar.ls
salt '*' pillar.items
salt '*' pillar.item mysql
```