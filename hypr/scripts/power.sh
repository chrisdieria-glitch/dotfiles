choice=$(printf "Shutdown\nReboot\nLogout\nSuspend\nLock" | wofi --dmenu --prompt "Power")

case "$choice" in
Shutdown)
  systemctl poweroff
  ;;
Reboot)
  systemctl reboot
  ;;
Logout)
  hyprctl dispatch exit
  ;;
Suspend)
  systemctl suspend
  ;;
Lock)
  hyprlock
  ;;
esac
