# tenpybot
Automatization scripts, e.g. for the nightly build of the online documentation

The scripts in this repo are called by cron jobs.

### Requirements
* ssh-keys set up for git pull/push. For that, I have the following entry in my ~/.ssh/config:
```
Host git_tenpybot
	HostName github.com
	User git
	IdentityFile ~/.ssh/id_rsa_tenpybot
```
* python3 with the packages sphinx numpydoc yapf
```
pip3 install --user --upgrade sphinx numpydoc yapf
```
* cloning the required git repositories
* setup of the required git repositories 
```
git clone git_tenpybot:tenpy/tenpy.git tenpy
git clone git_tenpybot:tenpy/tenpy.github.io.git tenpy.github.io
```
