# tenpybot
Automatization scripts, e.g. for the nightly build of the online documentation

The scripts in this repo are called by cron jobs.

### Requirements
* Linux system with bash, python3, rsync, ...
* ssh-keys set up for git pull/push. For that, I have the following entry in my ~/.ssh/config:
```
Host git_tenpybot
	HostName github.com
	User git
	IdentityFile ~/.ssh/id_rsa_tenpybot
```
* virtual environment ``python3 -m virtualenv tenpybot_env``

* install necessary python packages inside this environment
```
source tenpybot_env/bin/activate
pip3 install --upgrade sphinx numpydoc yapf numpy scipy pytest matplotlib
```
* cloning the required git repositories
```
git clone git_tenpybot:tenpy/tenpy.git tenpy
git clone git_tenpybot:tenpy/tenpy.git tenpy_compile
git clone git_tenpybot:tenpy/tenpy.github.io.git tenpy.github.io
```
* The file `cronjob_run.sh` reads the email from `my_email.txt` to notify in case of an error. It requires the linux
  "mail" to be set up and able to send emails to that address.

### Crontab entry
I have added the following entry in my crontab:
``
38 4 * * * bash /path/to/repo/cronjob_run.sh &> /dev/null
``

