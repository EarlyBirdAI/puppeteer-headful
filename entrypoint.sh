#!/bin/sh

# Startup Xvfb
Xvfb -ac :99 -screen 0 1280x1024x16 > /dev/null 2>&1 &

# Export some variables
export DISPLAY=:99.0
export PUPPETEER_EXEC_PATH="$(which google-chrome-stable)"

# Wait for the X server to be ready
for i in $(seq 1 10); do
    if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
        echo "X server is ready"
        break
    fi
    echo "Waiting for X server..."
    sleep 1
done

# Generate a machine id if needed (required by D-Bus)
if [ ! -s /etc/machine-id ]; then
    dbus-uuidgen > /etc/machine-id
fi

# Start D-Bus
mkdir -p /var/run/dbus
rm -f /var/run/dbus/pid
dbus-daemon --system --fork

# Start a full xfce4 session so the clipman clipboard manager owns the CLIPBOARD
# selection (mirrors production). This lets xclip exit after setting the clipboard
# instead of staying resident and hanging the test process.
dbus-launch --exit-with-session startxfce4 > /dev/null 2>&1 &

# Ensure clipman is running even if it isn't part of the default panel layout
xfce4-clipman > /dev/null 2>&1 &

# Give the desktop / clipboard manager a moment to come up
sleep 5

# Run commands
cmd=$@
echo "Running '$cmd'!"
echo $PUPPETEER_EXEC_PATH

if $cmd; then
    # no op
    echo "Successfully ran '$cmd'"
else
    exit_code=$?
    echo "Failure running '$cmd', exited with $exit_code"
    exit $exit_code
fi
