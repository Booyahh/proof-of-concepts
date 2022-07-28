## Install SSH-Script

**_script_**
```bash
#!/usr/bin/env bash
# ssh_install.sh

package=openssh-server
MISSING=$( dpkg --get-selections ${package} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "${MISSING}" ]; then
    echo "${package} is Not installed."
    sudo apt update
    sudo apt install "${package}" -y   

else
    echo "${package} is already installed "

fi
```

**_execution_**

```bash
bash ssh_install.sh
```
