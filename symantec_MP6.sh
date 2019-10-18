#!/bin/sh
#script to install or uninstall symantec
#to be used inside of an rpm
#update the first two variables for newer versions
#nh

MPVER=6
UPVER="`echo $MPVER + 1 | bc`"
SYMVER=Symantec_Endpoint_Protection-12.1_RU6_MP6
NASTAR=sep-12.1RU6.MP6_NAS_v1.tar.gz
ARGUMENT="$1"

if [ $# -lt 1 ]
then
    echo
    echo "Usage : $0 <option>"
    echo "e.g. $0 install"
    echo "This script will either install or uninstall symantec. Please use install to install or uninstall to uninstall."
    exit
fi

#fix java
/usr/sbin/update-alternatives --install /usr/lib/jvm/jre-1.8.0_oracle/lib/security/local_policy.jar jce_1.8.0_oracle_local_policy.x86_64 /usr/lib/jvm-private/oracle/jce/unlimited/local_policy.jar 900000 --slave /usr/lib/jvm/jre-1.8.0_oracle/lib/security/US_export_policy.jar jce_1.8.0_oracle_us_export_policy.x86_64 /usr/lib/jvm-private/oracle/jce/unlimited/US_export_policy.jar

#clear rpm lock for symantec installer
rm -rf /var/lib/rpm/.rpm.lock

case $ARGUMENT in
    install)
        rm -rf /var/tmp/sym
        mkdir /var/tmp/sym
        echo "*** Extracting Symantec for installation ***"
        echo ""
        tar zxvf /var/tmp/${NASTAR} -C /var/tmp/sym
        #rm -rf /opt/Symantec
        /var/tmp/sym/${SYMVER}/install.sh -i
        #mv /opt/Symantec /opt/Symantec_MP${MPVER}
        #ln -s /opt/Symantec_MP${MPVER} /opt/Symantec
        /opt/Symantec/symantec_antivirus/sav scheduledscan -c NAS -f daily -i 02:05 -m 0 /u/wk /tmp
        /usr/local/adm/daily_symantec_prep_scan
        echo "*** Congratulations! You have just installed symantec version `/opt/Symantec/symantec_antivirus/sav info -p` ***"
        ;;

    uninstall)
        #rm -rf /var/tmp/sym
        #mkdir /var/tmp/sym
        #tar zxvf /var/tmp/${NASTAR} -C /var/tmp/sym
        #/var/tmp/sym/${SYMVER}/install.sh -u
        #rm -rf /opt/Symantec
        #ln -s /opt/Symantec_MP${UPVER} /opt/Symantec
        #rm -rf /opt/Symantec_MP${MPVER}
        #rm -rf /var/tmp/sym
        echo "To uninstall, run script: /opt/Symantec/symantec_antivirus/uninstall.sh"
        ;;
esac
