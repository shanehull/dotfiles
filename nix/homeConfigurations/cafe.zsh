# caffeinate IV-drip helper
# usage: cafe [on|off]   (no args = status)
cafe() {
  local pidfile=/tmp/caffeinate.pid
  local running=false
  [[ -f $pidfile ]] && kill -0 "$(cat $pidfile)" 2>/dev/null && running=true

  case "$1" in
    on)
      if $running; then
        echo "already dripping (pid $(cat $pidfile))"
        return
      fi
      caffeinate -dimsu & echo $! > $pidfile; disown
      echo "cafe on (pid $(cat $pidfile))"
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
      echo "usage: cafe [on|off]" >&2
      return 1
      ;;
  esac
}
