# do-something-when-your-internet-ip-changed
 Linux Bash shell script to help you do something when your Internet IP Address changed.


## How to use this script

```bash
chmod +x ipwatch.sh
# For IPv4 address monitor
./ipwatch.sh
./ipwatch.sh 4
./ipwatch.sh v4
# For IPv6 address monitor
./ipwatch.sh 6
./ipwatch.sh v6
```

## Use this script for crond job
```shell
crontab -e
```
Add new line to create crontab jobs.

```bash
# check ip every 5 minutes
*/5 * * * * /SCRIPT_WORKING_PATH/ipwatch.sh
# OR
*/5 * * * * /SCRIPT_WORKING_PATH/ipwatch.sh v6
```

## What you have to do?

Change the function `DoSomeThing()`:

```bash
# What you want to do as the main business?
function DoSomeThing(){
    XLOG "(•••)IP changed.....Let's do something!"
    # .... Add your own code below:
    # curl ....
    # ...
    return 0
}
```
## Any output?

```vb
./ipwatch.sh 4


113.128.45.218


(√)Got current Internet IP:113.128.45.218
(i)13.128.45.218-->113.128.45.218


(•••)IP changed.....Let's do something!
(√√√)Job succeed!

(>>>)Caching this new IP:113.128.45.218
```

## Files generated

- **`ip.tmp.{hostname}.ipwatch_v4`**:File stored temp/current IP Address
- **`log.{hostname}.ipwatch_v4`**: Script running logs
- **`ip.cache.{hostname}.ipwatch_v4`**: File stored cached IP Address

## How to download

```bash
wget https://raw.githubusercontent.com/uf1y/do-something-when-your-internet-ip-changed/ipwatch.sh

curl -o ipwatch.sh https://raw.githubusercontent.com/uf1y/do-something-when-your-internet-ip-changed/ipwatch.sh
```