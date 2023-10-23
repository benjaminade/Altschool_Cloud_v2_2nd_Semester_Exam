This is the .md file that documents all the steps

This is the Master ip address as shown underlined below

![Alt text](Master_ip_address.PNG)


This is the Slave ip address 

![Alt text](Slave_ip_Address.PNG)


this is the process of copying the public key generated from Master into Slave to enable us 4ssh into slave:

![Alt text](Keygen_copied_to_Slave_to_enable_us_ssh.PNG)


I was able to successfully ssh from Master to Slave

![Alt text](Successful_ssh_from_Master_to_Slave.PNG)


Now, after the creation of the bash script, i then created an ansible playbook to run the script on Slave machine. The next three images shows successful deployment of the script on Slave

![Alt text](Check_run_ansible_on_slave.PNG)

![Alt text](Running_the_ansible_playbook.PNG)

![Alt text](Successful_Deployment_on_slave.PNG)


After the playbook had been executed, i checked to see if necessary applications had been installed on the Slave machine:

1. Check if Apaches2 is running and active:

![Alt text](Apache_installed_on_Slave.PNG)

![Alt text](Apache_active_and_running_on_slave.PNG)

2. Check if mysql is installed on Slave machine:

![Alt text](mysql_installed_on_slave.PNG)

3. Check php accessibility on Slave:

![Alt text](php_accessibility_slave_Exam.PNG)

![Alt text](php_accessible_Practice.PNG)


Cronjob was created to check the uptime of the Slave machine every 12am
I created the cronjob by executing the inbuilt uptime script found in /bin/uptime and i then created a log file named uptime.log in the /var/log/ directory. S3wo the script was set to run every 12am and the output is to be stored in my uptime.log file.

![Alt text](Cronjob_uptime.PNG)

In mysql configuration, i created an ansible vault to keep my password encrypted

![Alt text](Ansible_vault_that_keeps_my_password.PNG)


I also ran my bash script on Master and i checked if Apache is running:

![Alt text](Apache_running_on_Master.PNG)











