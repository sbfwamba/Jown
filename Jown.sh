#!/bin/bash
#DIRECTORIES AND FILE SECTIONS
#Bashscript
Script=jown_0.1.sh  #IMPORTANT NOTICE! This is a default script name. Remember to change this name if you change the script name on your device

#Email Address, Domains and API token files
domains_path=$main_dir/domains.txt
api_token_fil_path=$main_dir/api_token.txt #The file contains API token to be used
recipaddr=$main_dir/email_address_list.txt #It contains recipients email addresses




#Main Sub-Directories
logs=$main_dir/wpscan_logs #log file, hash.txt directory



#Log file path
filelog=$logs/wpscan_script_$(date "+%Y.%m.%d").log # log file
hash=$logs/hash.txt #hash file. This hash will be used to verify the Integrity of the scanned report




#2 COMMANDS SECTION
#Checking if the script is running with a correct file name
if test -f "$Script";

then

echo "The script name is $Script " >> $filelog

else 

echo "The script file name doesn't match the script name in the script file. Enter the script name with its full path. e.g /home/test/wpscan_bashscript_0.4.sh"
read $script
echo "script=$script #This a password list file path" | cat - $Script > temp && mv temp $Script
echo "The Script name updated successfully!"
chmod +x $Script
echo "Script saving changes..."
exit
fi


echo "$(date)Starting Wpscan_bash.script_1.1.sh..."
#Checking if the main directory exists
echo "$(date)Checking if Main directory exists..."

if [ ! -d "$main_dir" ]
then
echo "Hey Buddy! It looks like you are running this script for the first time! The main directory does'nt Exist. Do you wish to create one? Type Y and Click Enter to Accept. Else you can type any key and We will proceed to create for you. Our default directory location would be ~/Wpscan"
read Option
if [ $Option == Y ]
then
echo "Enter diretory name with its full path. e.g. /home/test/Wpscan. NOTE don't use ~/ to represent home directory path this won't work out"
read main_dir_path
mkdir $main_dir_path
echo "main_dir=$main_dir_path #Created main directory path" | cat - $Script > temp && mv temp $Script
echo "Main Directory has been created! $main_dir"
else 
echo "No main directory Available!"
exit
fi
else
echo "$(date) The main directory $main_dir exists!" >> $filelog
fi

#Creating a password list path path
if test -f "$pass_words";

then

echo "The file path $passwords_path exist!" >> $filelog

else 

echo "Enter password list file full path. The password list file will be used for brute force attack"
read passwords_path
echo "pass_words=$passwords_path #This a password list file path" | cat - $Script > temp && mv temp $Script
echo "The file path $passwords_path has been Created!"
chmod +x $Script
echo "Script saving changes..."
exit
fi

if [ ! -d "$logs" ]
then 
mkdir $logs
echo "The directory $logs has been Created!"
echo "$(date) I am finally live! Keep on checking me for audits and trouble-shooting purposes. I will keep you updated!" >> $filelog 
else
echo "$(date) The directory $logs, I exist!" >> $filelog
fi


#Creating Domains list file
echo "Checking if $domains_path exists..." >> $filelog
cd $main_dir
if test -f "$domains_path";
then
 
echo "$domains_path file exist!" >> $filelog

else
echo "$(date) Creating $domains_path file..." >> $filelog 
echo "Enter domains to be scanned seperated with a single spacing"
read domains_list
echo "$domains_list" >> $domains_path
echo "The file $domains_path has been Created!"
echo "$(date) The file $domains_path  Created!" >> $filelog 

fi

#Checking API-token file
echo "Checking if $api_token_fil_path exists..." >> $filelog
if test -f "$api_token_fil_path";
then
echo "$api_token_fil_path file exist!" >> $filelog

else

echo "$(date) Creating $api_token_fil_path file..." >> $filelog 
echo "Enter Api token"
read api_token
echo "$api_token" > $api_token_fil_path
echo "The file $api_token_fil_path has been Created!"
echo "$(date) The file $api_token_fil_path  Created!" >> $filelog 
 
fi

#Creating Email Address List fIle 
echo "Checking if $recipaddr exists..." >> $filelog
if test -f "$recipaddr";
then
echo "$recipaddr file exist!" >> $filelog

else 
echo "$(date) Creating $recipaddr file..." >> $filelog 
echo "Enter Email address(es) seperated with a spacing"
read email_address
echo "$email_address" >> $recipaddr
echo "The file $recipaddr has been Created!"
echo "$(date) The file $recipaddr  Created!" >> $filelog 
fi


domains=$(cat $domains_path | tr -s '\n' ' ' )
for n in $domains; do

echo "$(date)Starting Wpscan_bash.script..."
#Section 2: Checking and Creating Reports Sub_directories
Reports=$main_dir/Wpscan_Reports #All reports directory
reports_dir_path=$Reports/Wpscan_Reports_$(date "+%Y.%m.%d") #scanned reports directory grouped by date
reports_dir=Wpscan_Reports_$(date "+%Y.%m.%d") #Scanned Reports directory
domain_reports_dir=$reports_dir_path/$n

if [ ! -d "$Reports" ]
then 
echo "$(date)Creating $Reports directory... " >> $filelog
mkdir $Reports
echo "$(date) The directory $Reports Created!" >> $filelog 
else
echo "$(date) The directory Wpscan_Reports exists!" >> $filelog
fi

echo "$(date)Creating reports_dir_path directory... " >> $filelog
mkdir $reports_dir_path
echo "$(date) The directory $reports_dir_path Created!" >> $filelog 

echo "$(date)Creating $domain_reports_dir directory... " >> $filelog
mkdir $domain_reports_dir
echo "$(date) The directory $domain_reports_dir Created!" >> $filelog  

#Wpscan Report files
plugins=$domain_reports_dir/Wpscan_Plugins_Report_$(date "+%Y.%m.%d").json #plugins report
plugin_vulns=$domain_reports_dir/Wpscan_Plugins_Vulnerability_Report_$(date "+%Y.%m.%d").json #plugins vulnerability
themes=$domain_reports_dir/Wpscan_Themes_Report_$(date "+%Y.%m.%d").json #themes report
themes_vulns=$domain_reports_dir/Wpscan_Themes_Vulnerability_Report_$(date "+%Y.%m.%d").json #theme vulnerabilities report
user_enumeration=$domain_reports_dir/Wpscan_User_Enumeration_Report_$(date "+%Y.%m.%d").json #user enumeration report
bruteforce=$domain_reports_dir/Bruteforce_Report_$(date "+%Y.%m.%d").json #bruteforce attack repors
backups=$domain_reports_dir/Detected_backups_config_$(date "+%Y.%m.%d").json #backups detection reports

#Whatweb Report files
whatweb_scan_filepath=$logs/Whatweb_Report_$n.txt #Whatweb Scanned Reports file with full path
whatweb_scan_report=Whatweb_Report_$n.txt #Whatweb Scanned Reports file
Failed_Scans=$domain_reports_dir/Failed_Scan_Reports$(date "+%Y.%m.%d").txt

#Combined and Zipped Files paths
combined_report=$reports_dir_path/Combined_Wpscan_Report.json
zipped_report=Wpscan_Reports_$(date "+%Y.%m.%d").zip
zipped_filepath=$Reports/Wpscan_Reports_$(date "+%Y.%m.%d").zip #zipped report



#Section 4: MTA/file, formats, API token section
outputformat=json 
token=$(cat $api_token_fil_path | tr -s '\n' ' ' ) #Reading the api token
mail_agent=mutt  #MTA used for sending emails


#Section 5: Commands (WPSCAN)
#Checking if the website is running WordPress
echo "$(date) Starting Whatweb.." >> $filelog
whatweb $n > $whatweb_scan_filepath #This checks type of  content management system used in the web browser 
echo "$(date) Whatweb scan done.." >> $filelog

if [ $(grep "WordPress" $whatweb_scan_filepath)==1 ] #checks if Wordpress is available

then
echo "$(date) WordPress Detected" >> $filelog
echo "$(date) Starting Wpscan.." >> $filelog
echo "$(date) Scanning for available plugins on $n..." >> $filelog
wpscan --url $n --enumerate p --output $plugins --format $outputformat  #scans for available plugins
echo "$(date) Scanning for plugins on $n done!" >> $filelog

echo "$(date) Scanning for Plugin Vulnerabilities on $n..." >> $filelog
wpscan --url $n --enumerate vp --plugins-detection mixed --api-token $token --output $plugin_vulns --format $outputformat    #Scan vulnerable plugins
echo "$(date) Scanning for Plugin vulnerabilities on $n done!" >> $filelog

echo "$(date) Scanning for available themes on $n..." >> $filelog
wpscan --url $n --enumerate at --output $themes --format $outputformat    #Scan installed themes
echo "$(date) Scanning for themes on $n done!" >> $filelog

echo "$(date) Scanning for themes Vulnerabilities on $n..." >> $filelog
wpscan --url $n --enumerate vt  --plugins-detection mixed --api-token $token --output $themes_vulns --format $outputformat    #Scan vulnerable themes
echo "$(date) Scanning for themes vulnerabilities on $n done!" >> $filelog

echo "$(date) Scanning for available users on $n..." >> $filelog
wpscan --url $n --enumerate u --output $user_enumeration --format $outputformat #Emurating users
echo "$(date) Scanning for available users on $n done!" >> $filelog

echo "$(date) Attempting bruteforce attack on $n enumerated users..." >> $filelog
wpscan --url $n -e u --passwords $pass_words --output $bruteforce --format $outputformat  #attepmting brute force attack on enumerated users
echo "$(date) Bruteforce attack on $n enumerated done!" >> $filelog

echo "$(date) Detecting backup configurations on $n..." >> $filelog
sudo wpscan --url $n --config-backups-detection mixed  --output $backups --format $outputformat  
echo "$(date) Backup detection scans on $n done!" >> $filelog

#Combining All Wpscan Reports
echo "$(date) Combining reports for $n..." >> $filelog
echo "...................$n...................." >> $combined_report

echo "Available Plugins" >> $combined_report
cat $plugins | tr -s '\n' ' '  >> $combined_report
echo "................................................................................" >> $combined_report

echo "Available Plugin Vulnerabilities" >> $combined_report
cat $plugin_vulns | tr -s '\n' ' '  >> $combined_report
echo "................................................................................" >> $combined_report

echo "Available Themes" >> $combined_report
cat $themes | tr -s '\n' ' '  >> $combined_report
echo "................................................................................" >> $combined_report

echo "Available Theme Vulnerabilities" >> $combined_report
cat $themes_vulns | tr -s '\n' ' '  >> $combined_report
echo "................................................................................" >> $combined_report

echo "Users Enumerated" >> $combined_report
cat $user_enumeration | tr -s '\n' ' '  >> $combined_report
echo "................................................................................" >> $combined_report

echo "Brute Force Attack Attempts" >> $combined_report
cat $bruteforce | tr -s '\n' ' '  >> $combined_report
echo "................................................................................" >> $combined_report

echo "Detected Backup Configuration" >> $combined_report
cat $backups | tr -s '\n' ' '  >> $combined_report
echo "...........................................Done....................................." >> $combined_report

echo "$(date) Combining reports for $n done!" >> $filelog

else

if [ $(grep "Joomla" $whatweb_scan_filepath)==1 ] #checks if Joomla is available
then
echo "$(date) Joomla Detected!" >> $filelog
echo "$(date) Starting Joomscan.." >> $filelog
echo "$(date) Scanning for vulnerabilit $n..." >> $filelog
perl joomscan.pl -u $n  #Default 
perl joomscan.pl -u $n --ec

#Combining  Joomla Report
echo "$(date) Combining reports for $n..." >> $filelog
echo "...................$n...................." >> $combined_report
echo "No WordPress Detected!" >> $combined_report
cat $Failed_Scans | tr -s '\n' ' '  >> $combined_report
echo "...........................................Done....................................." >> $combined_report
echo "$(date) Combining reports for $n done!" >> $filelog

fi

done

echo ".............................END............................................" >> $combined_report


#Section 6: Commands Zipping reports directory
echo "$(date) Zipping  reports..." >> $filelog
cd $Reports
zip -r $zipped_report $reports_dir
echo "$(date) Zipping done!" >> $filelog

#Section 7: Commands Calculating the reports MD5hash
echo "$(date) Calculating MD5 file hash..." >> $filelog
md5sum $zipped_filepath > $hash #Calculating file hash
echo "$(date) Calculating MD5 file hash done!" >> $filelog

#Section 8: Commands Sending email
echo "$(date) sending email to $(cat $recipaddr | tr -s '\n' ' ' ) ..." >> $filelog
echo "Kindly receive  attached Wpscan scan reports for $(date "+%Y.%m.%d")
Regards.
The MD5 File hash:  $(cat $hash | tr -s '\n' ' ' )" | $mail_agent -s "WPscan Scan Reports For $(date)."  $(cat $recipaddr | tr -s '\n' ' ' ) -a $zipped_filepath #sending email with csv attacment to recipients
echo "$(date) Email sent successfully!" >> $filelog
