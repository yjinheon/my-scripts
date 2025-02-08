#!/bin/bash

grep -oE 'https?://[^ ]+' "$1"
