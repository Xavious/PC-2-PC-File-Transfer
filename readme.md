# Windows Domain/Network PC-2-PC File Transfer

This is an old school styled batch script I wrote to easily transfer a Windows domain user from one PC to another. It runs as a batch executable and has some basic command line inputs it will request. The included "exclusions.rcj" file is used to exclude files from the Desktop copyover process because these files were already on the PC image I was transferring people to, and were being duplicated. The basic flow is as follows:

1. It will request the name of the PC that the files are being transferred FROM. This can be the PC's name on the domain, or an IP address.
- Assuming you have a priviledged administrator account, you can run this script from that account on an entirely different PC on the network.
- The script will ping the host machine to make sure they can communicate before proceeding. If the ping fails, it will request a new PC.
 - Possible causes of failure and troubleshooting in the event you've accurately identifieed the machine are Firewall and/or Virus software. Disabling these types of security software usually resolved this issues for me.
2. The script will request the users Windows account name. This is to ensure that target directories actually exist. 
 - Most user specific data on Windows is saved in C:\users\<username>
 - The script will test this file path and if it does not exist, it will request a new name.
3. The script will request the destination PC, with the same nuancese mentioned earlier.
4. The script will request the destination Windows account, also with the same nuances mentioned earlier.
