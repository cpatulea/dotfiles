#!/bin/sh
set -ex
sudo -v

ssh -S none -o BatchMode=yes localhost true || {
  echo "Can't ssh to localhost." >&2
  exit 1
}

sudo service ssh stop

sudo /usr/sbin/sshd -D -d &
SUDO_PID=$!

sleep 0.1  #  let sudo spawn sshd

SSHD_PID=$(pgrep -P $SUDO_PID sshd)

sleep 1  # let sshd settle

sudo strace -f -p $SSHD_PID -o ssh_login_trace.txt &
STRACE_PID=$!

sleep 0.1  # let strace settle

sleep 3 | ssh -S none localhost &
SSH_PID=$!

# ssh will exit in about 3 seconds
wait $SSH_PID

sudo kill -INT $STRACE_PID

# ssh is dead. strace was killed and will exit soon. sshd will see connection
# reset and die soon, then sudo will die.
wait

sudo service ssh start
