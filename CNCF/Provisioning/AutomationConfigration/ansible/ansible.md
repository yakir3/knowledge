#### Introduction
...


#### Install 
##### Before install
```shell
# denpend
ssh protocal
python2(scp) or python3(sftp)

# network 
firewalld

```

##### Install on linux
```shell
# root dir
ANSIBLE_ROOT=/opt/ansible
mkdir $ANSIBLE_ROOT
cd $ANSIBLE_ROOT && mkdir logs keys


# option1: install on source
git clone https://github.com/ansible/ansible.git
cd ansible
python setup.py build
python setup.py install
cp -aR examples/* $ANSIBLE_ROOT
# option2: install on pip
pip install ansible==x.x.x
cp -aR examples/* $ANSIBLE_ROOT


# verify
ansible --version

```

##### Credentials
```shell
# generate private and public key
ssh-keygen -t rsa -b 1024 -C 'for ansible key' -f /opt/ansible/keys/node -q -N ""
mv /opt/ansible/keys/node /opt/ansible/keys/node.key

# if private key has password
# ssh-agent bash
# ssh-add ~/.ssh/id_rsa

# add public keys to all hosts
ssh-copy-id -i /opt/ansible/keys/node.key root@192.168.1.1
ssh-copy-id ...
```


#### Use
##### [[hosts|INVENTORY]]
```shell
# option1: /opt/ansible/hosts
# option2: /opt/ansible/inventory.yaml
```

##### ad-hoc(modules)
```shell
# ansible-doc
ansible-doc --list |grep ping
ansible-doc file
ansible-doc -s ping 


# check all hosts
ansible all --list-hosts [-i /path/hosts]
ansible all -m ping 
ansible '*' -m ping
# pattern hosts
ansible '192.*' -m ping
ansible 'db*' -m ping 
ansible 'web:&db' -m ping
ansible 'web:db' -m ping
ansible 'web:!db' -m ping
ansible "~(web|db).*\.example\.com" –m ping


# common args
-a MODULE_ARGS
-e EXTRA_VARS
-f FORKS
-i INVENTORY
-u REMOTE_USER
-k --ask-pass
-b 
--become-user=root


# common modules
# shell commands
ansible template -m command -a 'echo test'
ansible template -m shell -a 'chdir=/opt/ ls'
ansible template -m script -a /tmp/t.sh
# file or git transfer
ansible template -m copy -a "src=/tmp.t.sh dest=/tmp/t.sh mode=600 backup=yes"
ansible template -m file -a "dest=/etc/ansible/facts.d/ state=directory"
ansible webservers -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"
# managing packages
ansible template -m apt -a "name=acme state=present"
ansible template -m yum -a "name=acme state=absent"
# users and groups
ansible template -m user -a "name=u1 group=u1 state=present"
# managing services
ansible template -m service -a "name=httpd state=restarted"
# time limited background operations
ansible template -B 1800 -P 60 -a "/usr/bin/long_running_operation --do-stuff"
ansible template -m async_status -a "jid=488359678239.2844"

...

# ansible-console
ansible-console
list | ?

```

##### fact && template
```shell
# vars
ansible.cfg && env && ansible ad-hoc
playbook(vars && vars_files && vars_prompt)
hosts(inventory && include_vars && facts or registered)


# fact
# ansible setup info
ansible template -m setup
ansible template -m setup -a 'filter=ansible_eth*'
# custom fact
ansible template -m file -a "dest=/etc/ansible/facts.d/ state=directory"
ansible template -m blockinfile -a "path=/etc/ansible/facts.d/forbidden.fact create=true block=[forbid]\nfoo=bar"
ansible template -m setup -a "filter=ansible_local"
# flush cache
ansible-playbook --flush-cache simple_playbook.yaml 


# jinja2 template
# https://ansible.leops.cn/basic/Facts/
ansible template -m debug -a "msg={{ now(utc='True',fmt='%H-%m-%d %T') }}"


```

##### playbook && galaxy
```shell
# playbook
# regular file(/opt/ansible/simple_playbook.yaml)
ansible-playbook simple_playbook.yaml

# special inventory file
-i hosts | -i inventory.yaml
# list
--list-hosts
--list-tasks
# dry-run args
--syntax-check
--check 


# import and include
# import 
tasks:
  - import_tasks: tasks/other.yaml
    vars:
      wp_user: yakir
      ssh_keys:
        - keys/one.txt
        - keys/two.txt
  - import_role:
      name: nginx
# include
tasks:
  - include_tasks: "{{inventory_hostname}}.yml"
  - include_tasks: other.yaml param={{item}}
    with_items: [1, 2, 3]
  - include_role:
      name: example



# galaxy 
# online roles
ansible-galaxy list
ansible-galaxy install geerlingguy.redis
ansible-galaxy remove geerlingguy.redis

# manual init template role
ansible-galaxy role init /opt/ansible/roles/template
# define task
template/tasks/main.yml
template/tasks/setup-Debian.yml
template/tasks/setup-Redhat.yml

```


##### plugins && api
```shell
#

```


>Reference:
>1. [Official Ansible Doc](https://docs.ansible.com/ansible)
>2. [Ansible 中文文档](https://ansible-tran.readthedocs.io/en/latest/docs/intro.html)
>3. [Ansible Github](https://github.com/ansible/ansible)
>4. [Ansible Galaxy](https://galaxy.ansible.com/)
>5. [Ansible CN Wiki](https://ansible.leops.cn/basic/Introduction/)
