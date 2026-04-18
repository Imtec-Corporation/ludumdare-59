#!/bin/bash

PROJECT_PATH="$PWD"
SRC_PATH="$PROJECT_PATH/src"
TEST_PATH="$PROJECT_PATH/test"
TEST_COMMAND="godot --headless -s --path \"$PROJECT_PATH\" addons/gut/gut_cmdln.gd -glog=1 -gexit"

echo "Watching for file changes in: $SRC_PATH and $TEST_PATH"

inotifywait --monitor --recursive "$SRC_PATH" "$TEST_PATH" -e close_write | while IFS= read -r event; do
    if [[ -n "$event" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - File change detected: $event. Running tests..."
        eval "$TEST_COMMAND"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Tests finished."
    fi
done

echo "Stopping file watcher."