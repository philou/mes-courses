#!/bin/sh

rake file_system:to_files:layouts_and_snippets &&
git add design
