#!/bin/bash

find "$1" -name "*.whl" -type f -exec pip install {} \;
