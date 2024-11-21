#!/bin/bash

index=$1

if [ -z "$index" ]; then
    echo "No index provided. Doing everything"
    index=""
fi

mkdir -p data/derived2/accel
cp data/original/accel/accel-${index}* data/derived2/accel/
