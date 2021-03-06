#!/bin/bash
base_dir=$(git rev-parse --show-toplevel)
cpplint=${base_dir}/utils/cpplint/cpplint.py

if [[ ! -x "$cpplint" ]]; then
  echo "$cpplint is not executable or found!"
  exit 1
fi

lint_errs=0

# Find all files ending with .h / .hpp / .cpp / .cc files for cpplint
# echo "cpplint starts..."
for file in $(git ls-files .. | grep -E '^.+\.(h|hpp|cpp|cc)$'); do
  if [ -f "$file" ]; then
    $cpplint $file
    if [ $? -eq 0 ]; then
      echo -e "$file cpplint \033[32mok\033[0m"
    else
      lint_errs=$(expr ${lint_errs} + $?)
    fi
  fi
done

if [ ${lint_errs} -eq 0 ]; then
  # echo -e "\033[32mAll files pass cpplint\033[0m"
  exit 0
else
  echo -e "\033[31mTotal ${lint_errs} files fail cpplint\033[0m"
  exit 1
fi
