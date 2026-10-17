#!/usr/bin/env bash
set -euo pipefail

# ---------- Edit these values ----------
SSH_SERVER="root@YOUR_PUBLIC_SERVER"
SSH_PORT=22

# Public port -> service on this machine
REMOTE_PORT=46130
LOCAL_HOST="127.0.0.1"
LOCAL_PORT=8088
# ---------------------------------------

# SSH uses this socket to check or stop the background tunnel.
CONTROL_SOCKET="/tmp/ssh-reverse-relay-${REMOTE_PORT}.sock"

case "${1:-}" in
  start)
    # -R means: listen on the public server, then relay back to this machine.
    ssh -fNT -M -S "$CONTROL_SOCKET" \
      -p "$SSH_PORT" \
      -o ExitOnForwardFailure=yes \
      -o ServerAliveInterval=20 \
      -o ServerAliveCountMax=3 \
      -R "0.0.0.0:${REMOTE_PORT}:${LOCAL_HOST}:${LOCAL_PORT}" \
      "$SSH_SERVER"
    echo "started: public :${REMOTE_PORT} -> local ${LOCAL_HOST}:${LOCAL_PORT}"
    ;;

  stop)
    ssh -S "$CONTROL_SOCKET" -O exit -p "$SSH_PORT" "$SSH_SERVER"
    ;;

  status)
    ssh -S "$CONTROL_SOCKET" -O check -p "$SSH_PORT" "$SSH_SERVER"
    ;;

  restart)
    ssh -S "$CONTROL_SOCKET" -O exit -p "$SSH_PORT" "$SSH_SERVER" 2>/dev/null || true
    "$0" start
    ;;

  *)
    echo "usage: $0 {start|stop|status|restart}"
    exit 1
    ;;
esac
