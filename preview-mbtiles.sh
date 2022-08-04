#!/bin/bash

cd $(dirname "$0")/.. || exit 1

mbview data/out.mbtiles
