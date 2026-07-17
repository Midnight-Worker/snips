xset -dpms
xset s off
xset s noblank

pulseaudio --start
xrandr --output HDMI-2 --mode 800x600

while true; do
        sleep 3600
done
