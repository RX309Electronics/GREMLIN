#!/bin/sh

SERVICES_DIR="/System/Services"
PIDS_FILE="/tmp/stage2_init.pids"
LOG_DIR="/var/log/services"
APP_DIR="/System/App"
APP_EXEC="App_init.sh"
APP_LOG="/var/log/RootApp.log"
APP_PID_FILE="/tmp/rootapp.pid"

mkdir -p "$LOG_DIR"
: > "$PIDS_FILE"

start() {
    echo "[Init Stage2 Started]"
    sleep 1

    [ ! -d "$SERVICES_DIR" ] && {
        echo "$SERVICES_DIR not found. Exiting."
        return 1
    }

    for service in "$SERVICES_DIR"/S[0-9][0-9]*; do
        [ ! -f "$service" ] && continue
        [ ! -x "$service" ] && {
            echo "$(basename "$service") disabled. Skipping."
            continue
        }

        service_name=$(basename "$service")
        logfile="$LOG_DIR/$service_name.log"

        echo -n "Starting Service: $service_name ... "

        "$service" start >> "$logfile" 2>&1
        status=$?

        if [ $status -eq 0 ]; then
            echo "[OK]"
        else
            echo "[FAILED]"
            echo "  ↳ see $logfile"
        fi

        sleep 0.2
    done

    echo "[Init Stage2 Completed!]"
    echo "[Start APP]"
    sleep 1

    if [ -d "$APP_DIR" ] && [ -x "$APP_DIR/$APP_EXEC" ]; then
        echo "Launching Application '$APP_EXEC'..."

        matchbox-window-manager -use_titlebar no >> "$APP_LOG" 2>&1 &
        sleep 0.5

        # Launch application
        "$APP_DIR/$APP_EXEC" 2>&1 | tee -a "$APP_LOG" &
        APP_PID=$!
        echo "$APP_PID" > "$APP_PID_FILE"


        sleep 1

        if kill -0 "$APP_PID" 2>/dev/null; then
            echo "[App Launch SUCCESS]"
        else
            echo "[App Launch FAIL]"
            echo "Falling back to developer shell... Please look at the logfile '$APP_LOG' to see what failed"
            exit 1
        fi


    else
        echo "[App Launch FAIL]"
        echo "ERROR: Failed to Launch Application. Application directory is not available. Falling back to developer shell."
        exit 1
    fi
}

stop() {
    echo "[Init Stage2 Shutting down...]"

    if [ -f "$APP_PID_FILE" ]; then
        APP_PID=$(cat "$APP_PID_FILE")
        if kill -0 "$APP_PID" 2>/dev/null; then
            echo "Stopping application (PID $APP_PID)..."
            kill "$APP_PID"
        fi
        rm -f "$APP_PID_FILE"
    fi

    echo "[Init Stage2 Shutdown Completed!]"
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) stop; start ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
