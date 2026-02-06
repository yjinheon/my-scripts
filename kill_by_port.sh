#!/usr/bin/env bash

lsof -ti:8001 | xargs kill -9 2> /dev/null;
