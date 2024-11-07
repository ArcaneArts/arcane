#!/bin/bash

# call setup script first
./script_sync_shadcn.sh

# deploy
firebase deploy --only hosting