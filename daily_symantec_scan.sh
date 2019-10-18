#!/bin/sh
# parse SEP log file for threats and issues
# then email with the results.
# nh

todate=$(date +"%m%d%Y")
b=$(awk '/Threats/ {if ($4 -ge 1) print $4 }' /var/symantec/Logs/$todate.log)
a=0

if [ $b -gt $a ]
then
    echo "Threats Found:" > /var/symantec/Logs/threat-$todate.out
    awk -F , '{print $7, $8}' /var/symantec/Logs/$todate.log | awk NF >> /var/symantec/Logs/threat-$todate.out
    echo -e "\n\n\n" >> /var/symantec/Logs/threat-$todate.out
    echo "Quarantine List:" >> /var/symantec/Logs/threat-$todate.out
    /opt/Symantec/symantec_antivirus/sav quarantine -l >> /var/symantec/Logs/threat-$todate.out
    echo -e "\n\n\n" >> /var/symantec/Logs/threat-$todate.out
    echo "Other Issues Found:" >> /var/symantec/Logs/threat-$todate.out
    awk -F '"' {'print $2'} /var/symantec/Logs/$todate.log | awk NF >> /var/symantec/Logs/threat-$todate.out
    /bin/mail -s "Symantec found virus on `hostname`" < /var/symantec/Logs/threat-$todate.out nh@nh.gov
    #echo "`cat /var/symantec/Logs/threat-$todate.out`"
else
    exit
fi

rm -rf /var/symantec/Logs/threat-$todate.out
