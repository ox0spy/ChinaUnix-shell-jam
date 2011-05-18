#!/bin/bash

ls -l | grep -E '^d' | awk '{print $8}'
