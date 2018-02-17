# Windows Domain/Network PC-2-PC File Transfer

This is an old school styled batch script I wrote to easily transfer a Windows domain user from one PC to another. It runs as a batch executable and has some basic command line inputs it will request. The included "exclusions.rcj" file is used to exclude files from the Desktop copyover process because these files were already on the PC image I was transferring people to, and were being duplicated. The basic flow is as follows:

1. The script will request the source PC. This can be the PC's name on the domain, or an IP address.
2. The script will request the users Windows account name. This is to ensure that target directories actually exist. 
3. The script will request the destination PC, with the same nuances mentioned earlier.
4. The script will request the destination Windows account name, also with the same nuances mentioned earlier.

## Files Copied Over
In my environment I was targeting very specific files, and that is the default configuration for this script. It can be edited easily enough to include more parameters, but by default it copies over the following:
- User Documents, Desktop, and Favorites(IE bookmarks) directories
- MicrosoftOutlook .pst (personal mail box file), and NK2 files.
- Firefox bookmark .sqlite file
- Chrome bookmark .html file
- TODO: Copy over Edge bookmarks, an utter nightmare in the short time I spent trying to accomplish this

## Troubleshooting

- Assuming you have a privileged administrator account, you can run this script from that account on an entirely different PC on the network. However, if you're not a privileged administrator, then this script may not work. All of my testing was done with the most elevated administrator rights on the Windows domain.
   - Network structure and segmentation is also a possible factor to consider. In my testing environment I was plugging the machines into a 4 port switch in the office I was working from.
- For both source and destination, the script will ping the host machine to make sure they can communicate before proceeding. If the ping fails, it will request a new PC.
  - Possible causes of failure and troubleshooting in the event you've accurately identified the machine, and it isn't a network topology issue, are Firewall and/or Virus software. Disabling these types of security software usually resolved this issues for me.
- Most user specific data on Windows is saved in C:\users\\< username >. The script will test this file path, and if it does not exist, it will request a new name. So attention to the correct account name, and making sure that account exists locally on the PC are paramount.