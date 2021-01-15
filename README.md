GroestlcoinAutoNode
===============

A script to run (ideally just after starting up a new server/vps) to automatically setup `groestlcoind` and have it start on boot.

This script runs `groestlcoind` under the `groestlcoin` user. An alias (`grs`) is added to the current user's `.bashrc`. Where you'd normally type `groestlcoin-cli` you can type `grs`, eg: `grs getinfo`.

It has been tested on Ubuntu Server 14.04 and 15.04. It is intended for use only on these distros.

One Liner
---------

    wget https://raw.github.com/Groestlcoin/GroestlcoinAutoNode/master/groestlcoinAutoNode.sh ; sudo bash groestlcoinAutoNode.sh

You should really check out the code before running that though.

### Super Lazy Method

If you want to run one command then disconnect (nearly) straight away, use this:

    wget https://raw.github.com/Groestlcoin/GroestlcoinAutoNode/master/stub.sh ; sudo bash stub.sh ; exit

It should drop the connection once it's started. You can view the setup with `screen -r groestlcoinInstaller` and detach (when viewing) with `Ctrl+a d`.


Notes
-----

Previously, the script would prompt you to change your password and would install the ufw (and allow ports 1331 and 22). However, I've removed that. All that happens now is installing `groestlcoind` and dependencies.
