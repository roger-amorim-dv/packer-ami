#!/usr/bin/env bash

packer init .
packer validate .
packer fmt .
packer build . # -var-file="vm-builder.auto.pkrvars.hcl" necessary if auto is not used