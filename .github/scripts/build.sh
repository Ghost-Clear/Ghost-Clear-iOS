#!/bin/bash

set -eo pipefail

xcodebuild -workspace /Ghosting\ Connector.xcworkspace\
            -scheme Ghosting\ Connector\
            -destination platform=iOS\ Simulator,OS=13.5,name=iPhone\ 11 \
