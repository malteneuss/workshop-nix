#!/bin/bash

echo "Please enter your message: "
read -r input

echo "Here's your message:"
# cowsay is a C app
cowsay "$input"
# kittysay is a Rust app
kittysay "$input"