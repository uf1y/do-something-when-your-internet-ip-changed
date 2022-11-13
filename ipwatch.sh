#!/bin/bash
##################
# @Project: https://github.com/uf1y/do-something-when-your-internet-ip-changed
# @Download:https://raw.githubusercontent.com/uf1y/do-something-when-your-internet-ip-changed/main/ipwatch.sh
# @version: 1.0
# @date: Nov-13-2022
# @desc: THIS FILE HELPS TO DO SOMETHING WHEN YOUR INTETNET IP ADDRESS CHANGED
# @Main Process:
#  1. Get your internet IPAddress by https://testip.me
#  2. Compare with IPAddress cached before
#  3. Do something if current IP is not the same with the cached IP
#  4. crontab -e, add "*/5 * * * * /SCRIPT_WORKING_PATH/ipwatch.sh [v6|6|v4|4]"
##################
case $1 in
    6|v6)
        IP_MODE="v6"
        ;;
    *)
        IP_MODE="v4"
        ;;
esac

URL_TO_CHECK_IP="https://testip.me"
CURL_CONNECT_TIMEOUT=10

# -----------------------------------------
HOST_NAME=`hostname -s`
INSTANCE_NAME=".ipwatch"
INSTANCE_PATTERN="$HOST_NAME${INSTANCE_NAME}_$IP_MODE"
LOG_FILE="log.$INSTANCE_PATTERN"
CACHED_IP_FILE="ip.cache.$INSTANCE_PATTERN"
TEMP_IP_FILE="ip.tmp.$INSTANCE_PATTERN"
# -----------------------------------------

IP_CURRENT=""
IP_CACHED=""

WORK_PATH=$(cd "$(dirname "$0")" && pwd)
cd "$WORK_PATH"

echo -e "\n"
echo -e "\n________________" >> $LOG_FILE
date "+%Y-%m-%d %H:%M:%S" >> $LOG_FILE
echo "Woking path: $WORK_PATH" >> $LOG_FILE
# -----------------------------------------


# Extenable log function, $1:log message
function XLOG(){
    echo $1
    XTIME=$(date "+%H:%M:%S")
    echo "[$XTIME] $1" >> $LOG_FILE
}


# Get Current Internet IP Address
function getCurrentInternetIP(){
    #export http_proxy="127.0.0.1:3128"
    #export https_proxy="127.0.0.1:3128"
    unset http_proxy
    unset https_proxy
    if [ "v4" == "$IP_MODE" ]; then
        curl -4sL $URL_TO_CHECK_IP --connect-timeout $CURL_CONNECT_TIMEOUT > $TEMP_IP_FILE
        if [ 0 -eq $? ]; then
            cat $TEMP_IP_FILE | grep "^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$" > /dev/null
            if [ 0 -eq $? ]; then
                IP_CURRENT=`cat $TEMP_IP_FILE`
            fi
        else
            XLOG "getCurrentInternetIP:v4():HTTP Request Error..."
        fi
    elif [ "v6" == "$IP_MODE" ]; then
        curl -6sL $URL_TO_CHECK_IP --connect-timeout $CURL_CONNECT_TIMEOUT > $TEMP_IP_FILE
        if [ 0 -eq $? ]; then
            # You can change the regex pattern to some better one
            cat $TEMP_IP_FILE | grep "^[a-f0-9]\{1,4\}[:]\+[a-f0-9]\{1,4\}" > /dev/null
            if [ 0 -eq $? ]; then
                IP_CURRENT=`cat $TEMP_IP_FILE`
            fi
        else
            XLOG "getCurrentInternetIP:v6():HTTP Request Error..."
        fi
    fi
    echo $IP_CURRENT
}

# What you want to do as the main business?
function DoSomeThing(){
    XLOG "(•••)IP changed.....Let's do something!"
    # .... Add your own code below:
    # curl ....
    # ...
    return 0
}

# Main function to handle IP changed issue.
function main(){
    getCurrentInternetIP
    if [ "$IP_CURRENT" != "" ]; then
        echo -e "\n"
        XLOG "(√)Got current Internet IP:$IP_CURRENT"
        if [ ! -f  $CACHED_IP_FILE ]; then
            echo "NONE" > $CACHED_IP_FILE
            XLOG "(x)Cached file missed, init file: $CACHED_IP_FILE ..."
        fi
        IP_CACHED=`cat $CACHED_IP_FILE`
        XLOG "(i)$IP_CACHED-->$IP_CURRENT"]

        # Internet IP Changed...
        if [ "$IP_CACHED" != "$IP_CURRENT" ]; then
            XLOG ""
            XLOG ""
            DoSomeThing
            if [ 0 -eq $? ]; then
                XLOG "(√√√)Job succeed!"
                XLOG ""
                XLOG "(>>>)Caching this new IP:$IP_CURRENT"
                echo $IP_CURRENT > $CACHED_IP_FILE
            else
                XLOG ""
                XLOG "(xxx)Job failed."
            fi
        else
            XLOG "(˜)IP has not been changed, keep it."
        fi
    else
        XLOG "(x)No IP found!"
    fi
    echo -e "\n"
}

main