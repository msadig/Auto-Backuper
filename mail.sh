#!/usr/bin/env bash

# Credits: 
# - http://askubuntu.com/a/12933
# - http://www.howtogeek.com/51819/how-to-setup-email-alerts-on-linux-using-gmail/
# - http://tombuntu.com/index.php/2008/10/21/sending-email-from-your-system-with-ssmtp/

# echo -e "From: Keyfiyyet Server <sender@gmail.com>\nSubject: Error on the server \nTest message from Linux server using ssmtp" | ssmtp -vvv recipient@gmail.com
# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e
ERROR_STATUS=0

install_ssmtp (){
	apt-get install ssmtp
}

setup_mail () {

	CONFIG_FILE=/etc/ssmtp/ssmtp.conf

	while (true); do

        echo -ne " # SMTP server: "
        read MAILHUB

        echo -ne " # Email address: "
        read MAIL

        echo -ne " # Password address: "
        read PSW

        #Checking the loaded data
	    if [[ $MAILHUB != "" && $MAIL != "" && PSW != ""  ]]; then
	        break;
	    fi

    done

    # Backup config file
    if [[ -e $CONFIG_FILE ]]; then
    	cp $CONFIG_FILE ${CONFIG_FILE}.old
    fi

    USER=$(echo $MAIL | cut -d "@" -f 1)
    DOMAIN=$(echo $MAIL | cut -d "@" -f 2)

    echo "root=$MAIL" > "$CONFIG_FILE"
	echo "mailhub=$MAILHUB" >> "$CONFIG_FILE"
	echo "rewriteDomain=$DOMAIN" >> "$CONFIG_FILE"
	echo "AuthUser=$USER" >> "$CONFIG_FILE"
	echo "AuthPass=$PSW" >> "$CONFIG_FILE"
	echo "FromLineOverride=YES" >> "$CONFIG_FILE"
	echo "UseTLS=YES" >> "$CONFIG_FILE"

	echo -ne "\n***************************************************************************************************\n"
	echo -ne "\n sSMTP successfully installed. Now please follow the instruction below to set up recipient mail:\n\n"
	echo -ne " 1) Open the cron job list with command: crontab -e\n"
	echo -ne " 2) Add the \"recipient email\", to the top of the file: MAILTO=recipient@mail.com\n"
	echo -ne " 3) Save & Close\n\n"

    exit $ERROR_STATUS
}

################
#### START  ####
################

COMMAND=${@:$OPTIND:1}

#CHECKING PARAMS VALUES
case $COMMAND in
	setup)

		install_ssmtp
		setup_mail

	;;

    *)

        if [[ $COMMAND != "" ]]; then
            echo "Error: Unknown command: $COMMAND"
            ERROR_STATUS=1
        fi

    ;;
esac

exit $ERROR_STATUS