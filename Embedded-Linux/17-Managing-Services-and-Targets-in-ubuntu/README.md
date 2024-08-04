# Managing Services and Targets in ubuntu

Systemd is a powerful system and service manager for Linux operating systems. This guide will walk you through the steps to inspect systemd targets, create and manage custom services, and control service dependencies.

### Inspecting Systemd Targets

Systemd uses targets to group units and define system states. Here's how to inspect a specific target, like `graphical.target`:

1. **View the contents of `graphical.target`**:
    ```sh
    systemctl cat graphical.target
    ```
    This command shows the unit file of the `graphical.target`, which defines what it includes and its dependencies.

2. **List services wanted by `graphical.target`**:
    ```sh
    ls /lib/systemd/system/graphical.target.wants
    ```
    This command lists the services and other units that are linked to `graphical.target`.

3. **List dependencies of `graphical.target`**:
    ```sh
    systemctl list-dependencies graphical.target
    ```
    This command shows all the units that `graphical.target` depends on, including other targets, services, and mounts.

4. **View system logs**:
    ```sh
    journalctl
    ```
    This command provides access to the system logs, which can be useful for troubleshooting services.

### Creating a Custom Service

Let's create a custom service called `myservice`.

1. **Navigate to the systemd service directory**:
    ```sh
    cd /etc/systemd/system
    ```

2. **Create and edit the service file**:
    ```sh
    sudo touch myservice.service
    sudo vim myservice.service
    ```

3. **Add the following content to `myservice.service`**:
    ```ini
    [Unit]
    Description=This is my service
    Before=tftpd-hpa.service

    [Service]
    ExecStart=/home/mina/app/a.out
    Type=simple

    [Install]
    WantedBy=multi-user.target
    ```
    - `[Unit]`: Contains metadata and dependencies.
    - `[Service]`: Specifies how the service should start, stop, and run.
    - `[Install]`: Defines how the unit should be enabled or linked.

4. **Create the executable script**:
    ```sh
    mkdir /home/mina/app/
    touch /home/mina/app/a.out
    vim /home/mina/app/a.out
    ```

5. **Add the following content to `a.out`**:
    ```C
	#include <unistd.h> 
	#include <stdio.h>

	int main() {
    	while (1) 
    	{
        	printf("Hello Mina APP service\n");
        	sleep(5);  
    	}
    	return 0;
	}
    ```

6. **Make the script executable**:
    ```sh
    chmod +x /home/mina/app/a.out
    ```

7. **Reload systemd to recognize the new service**:
    ```sh
    sudo systemctl daemon-reload
    ```

8. **Enable and start the service**:
    ```sh
    sudo systemctl enable myservice.service
    sudo systemctl start myservice.service
    sudo systemctl status myservice.service
    ```

### Managing Dependencies and Other Services

Let's create another service called `hello.service` and manage dependencies.

1. **Create and edit the service file**:
    ```sh
    sudo touch /etc/systemd/system/hello.service
    sudo vim /etc/systemd/system/hello.service
    ```

2. **Add the following content to `hello.service`**:
    ```ini
    [Unit]
    Description=This is hello service

    [Service]
    ExecStart=/usr/bin/ping -c 4 google.com
    Type=simple

    [Install]
    WantedBy=multi-user.target
    ```

3. **Reload systemd to recognize the new service**:
    ```sh
    sudo systemctl daemon-reload
    ```

4. **Enable and start the service**:
    ```sh
    sudo systemctl enable hello.service
    sudo systemctl start hello.service
    sudo systemctl status hello.service
    ```

### Updating `myservice` to Depend on `hello.service`

1. **Edit the `myservice.service` file**:
    ```sh
    sudo vim /etc/systemd/system/myservice.service
    ```

2. **Update the `[Unit]` section to add a dependency**:
    ```ini
    [Unit]
    Description=This is my service
    Before=hello.service

    [Service]
    ExecStart=/home/mina/app/a.out
    Type=simple

    [Install]
    WantedBy=multi-user.target
    ```

3. **Reload systemd to apply changes**:
    ```sh
    sudo systemctl daemon-reload
    ```

### Managing Services

1. **Start the `myservice`**:
    ```sh
    sudo systemctl start myservice.service
    sudo systemctl status myservice.service
    ```

2. **Stop the `myservice`**:
    ```sh
    sudo systemctl stop myservice.service
    sudo systemctl status myservice.service
    ```

3. **Start the `hello.service`**:
    ```sh
    sudo systemctl start hello.service
    sudo systemctl status hello.service
    ```

4. **Stop the `hello.service`**:
    ```sh
    sudo systemctl stop hello.service
    sudo systemctl status hello.service
    ```

### Summary

In this guide, we covered:
- Inspecting systemd targets and their dependencies.
- Creating custom systemd services with proper configurations.
- Managing service dependencies to ensure proper startup order.
- Starting, stopping, enabling, and checking the status of systemd services.


<br>

---

<br>

<p align="center">
	<img src="https://github.com/user-attachments/assets/98f663d1-c7dd-423c-bf1e-cf5ff5bf49b2" width=75% height=75% />
</p>




<p align="center">
	<img src="https://github.com/user-attachments/assets/88449d4e-9c08-40ff-8f99-55deb2af17fc" width=75% height=75% />
</p>

