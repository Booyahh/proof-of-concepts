## Install Mysql-Script

**_File Cretaion_**
```bash

sudo vim mysql-install.sh

```



**_script_**

```bash
#usr/bin/env bash

serviceName="mysql-server"
serviceStatus=$(sudo systemctl is-active ${serviceName})

if [ $serviceStatus != "active" ]; then
    echo "${serviceName} service is not installed."
   echo
   echo
    sudo apt install  "${serviceName}" -y
    sudo systemctl start mysql.service
    sudo systemctl status mysql.service

else
    echo -e "\e[1;31mmysql server is already installed!"

fi
```


**_execution_**

```bash
bash mysql-install.sh
```

