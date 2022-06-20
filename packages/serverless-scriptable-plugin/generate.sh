#!/bin/sh

nix run nixpkgs#node2nix -- -i ./node-packages.json --nodejs-14
