#!/bin/sh

echo "Integrating latest developments (Press return to continue)" &&
read &&

echo "Pulling latest developments" &&
git pull dev master &&
echo &&

echo "Running integration script" &&
rake behaviours &&
echo &&

echo "Deploying to test and integration environments" &&
./push.sh &&
echo &&

echo "Integration successful !"
