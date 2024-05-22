### Build Install
```shell
# centos
yum install -y make gcc zlib-devel bzip2-devel openssl-devel ncurses-devel libffi-devel

# ubuntu
apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget libbz2-dev libsqlite3-dev

# build 
./configure --prefix=/usr/local/python3_11_1 --enable-loadable-sqlite-extensions --enable-shared --enable-optimizations
# 常用的编译参数
--enable-shared: 开启动态链接库支持，允许其他程序链接 Python 库
--enable-optimizations: 开启编译优化
--enable-ipv6: 开启 IPv6 支持
--enable-loadable-sqlite-extensions: 允许动态加载 SQLite 扩展
--with-system-expat: 使用系统的 expat 库
--with-system-ffi: 使用系统的 ffi 库
--with-openssl: 指定 OpenSSL 库的路径
--with-zlib=: 指定 zlib 库的路径
--with-bz2=: 指定 bzip2 库的路径
--with-tcltk=: 指定 Tcl/Tk 库的路径

# install
make && make install
```

### Pycharm
#### active
```shell
cat ideaActive/ja-netfilter-all/ja-netfilter/readme.txt
```

#### config
```shell
# Editor
Font
Color Scheme

# Plugins
# themes
gradianto
# json show
rainbow brackets

# Project
Python Interpreter

# Build,Execution,Deployment
Deployment

# Tools
Python Intergrated Tools -> Docstring format: Google

```

### ProjectManage
#### pip
```shell
# Install
...

# Create Virtualenv
python -m venv venv

# Output installed packages in requirements format
pip freeze > requirements.txt

# Install dependencies
pip install Django==4.1.3
pip install -r requirements.txt

```

#### poetry
##### Install
```shell
# Option 1(recommend)
# Install
curl -sSL https://install.python-poetry.org | python -
# Upgrade
poetry self update


# Option 2
# Install system binary to /usr/local/bin/pipx
pip3 install pipx
# Install shared tool poetry to /root/.local/bin/poetry
/usr/local/bin/pipx install poetry
/usr/local/bin/pipx list
export /root/.local/bin/
# Upgrade
pipx upgrade poetry
```

##### How to use
```shell
# New project
poetry new poetry-project

# Init existed project
cd my-project
poetry init


# Create Virtualenv with system Python
poetry env use /usr/bin/python3.10
poetry env info
poetry env list <--full-path>

# Add and install dependencies
poetry add <package_name==version>
# Add requirements.txt depencies
poetry add $(cat requirements.txt)
# Add depency for only dev
poetry add --dev pytest

# Add dependencies by manual
vim pyproject.toml
poetry install

# show all depencies
poetry show

# Update dependencies by manual
poetry update

# Remove Virtualenv
poetry env remove <env_name>

# Run in poetry Virtualenv
poetry run python -V
poetry run python <your_script.py>

# Active Virtualenv python shell
poetry shell

# Build and publish to PyPI
poetry build
poetry publish

# Config poetry
poetry config --list
poetry config virtualenvs.create false <--local>
```



>Reference:
>1. [Writing your pyproject.toml](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)
>2. [Poetry Official Docs](https://python-poetry.org/docs/)
>3. [toml.io](https://toml.io/cn/)
