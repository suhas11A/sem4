#!/bin/bash
rm -rf plots
mkdir plots
python3 main.py < "$1"
