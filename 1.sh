#!/bin/bash

# 显示当前目录下的子目录
echo "当前目录下的子目录"
ls -l | grep -E '^d' | awk '{print $8}'

# 显示当前目录下的子目录, 包含隐藏目录
echo "当前目录下的子目录, 包含隐藏目录"
ls -la | grep -E '^d' | awk '{print $8}' | grep -Ev '^\.$|^\.\.$'

# 下面的也可以, 没法现那个更简洁
# find . -maxdepth 1 -type d ! -regex '^\.$' | cut -d '/' -f2
