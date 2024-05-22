### [[ansible|ansible]]
```shell
#

```


### saltstack
```shell
# show state sls
salt 'node1' state.show_highstate [saltenv=dev]
salt 'node1' state.show_sls template [saltenv=dev]
salt 'node1' cp.list_states [saltenv=dev]

# execute state
salt 'node1' state.sls core.init [saltenv=dev] [test=True]
# top highstate
salt 'node1' state.highstate [--batch 10%|10] [test=True]


# command module
salt '*' cmd.run 'ls /tmp'
salt '*' cp.get_file salt://nginx/files/nginx.conf /tmp/nginx.conf

# module doc
salt 'node1' sys.doc saltutil


# granins 
salt '*' saltutil.refresh_grains [saltenv=base|dev|prod]
salt '*' saltutil.sync_grains
salt '*' grains.ls
salt '*' grains.items
salt '*' grains.item username

# pillar 
salt '*' saltutil.refresh_pillar [pillarenv=base|dev|prod]
salt '*' pillar.ls
salt '*' pillar.items
salt '*' pillar.item mysql


```
