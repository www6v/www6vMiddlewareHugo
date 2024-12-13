#!/bin/bash

# project push
git add .
git commit -m "add"
git push origin master

# public push
cd public
rm -rf *

cd ..
hugo


cd public
git add .
git commit -m "add"
git push origin master
