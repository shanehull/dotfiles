# caffeinate IV-drip helper
# usage: cafe [on [timeout]|off]   (no args = status)
#   timeout: seconds to stay awake, 0 = forever (default: $CAFE_TIMEOUT or 7200)
#   passing a timeout while running restarts with the new timeout
cafe() {
  local pidfile=/tmp/caffeinate.pid
  local running=false
  [[ -f $pidfile ]] && kill -0 "$(cat $pidfile)" 2>/dev/null && running=true

  case "$1" in
    on)
      local timeout=${2:-${CAFE_TIMEOUT:-7200}}
      if [[ ! $timeout =~ ^[0-9]+$ ]]; then
        echo "cafe: timeout must be a non-negative integer (seconds), got '$timeout'" >&2
        return 1
      fi
      if $running; then
        if [[ -z $2 ]]; then
          echo "already dripping (pid $(cat $pidfile))"
          return
        fi
        kill "$(cat $pidfile)"
      fi
      if (( timeout > 0 )); then
        caffeinate -dimsu -t "$timeout" > /dev/null &!
        echo $! > $pidfile
        echo "cafe on (pid $(cat $pidfile), ${timeout}s)"
      else
        caffeinate -dimsu > /dev/null &!
        echo $! > $pidfile
        echo "cafe on (pid $(cat $pidfile), no timeout)"
      fi
      ;;
    off)
      if ! $running; then
        echo "not dripping"
        rm -f $pidfile
        return
      fi
      kill "$(cat $pidfile)" && rm -f $pidfile && echo "cafe off"
      ;;
    "")
      $running && echo "dripping (pid $(cat $pidfile))" || echo "not dripping"
      ;;
    *)
      echo "usage: cafe [on [timeout]|off]   (no args = status)" >&2
      echo "  timeout: seconds to stay awake, 0 = forever (default: \$CAFE_TIMEOUT or 7200)" >&2
      echo "  passing a timeout while running restarts with the new timeout" >&2
      return 1
      ;;
  esac
}
