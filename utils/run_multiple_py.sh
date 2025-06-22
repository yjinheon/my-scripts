#!/bin/bash

python_files=(
  "test1.py"
  "test2.py"
  "test3.py"
)

# error log
error_log="error_forecast_$(date +'%Y%m%d_%H%M%S').log"

for file in "${python_files[@]}"; do
  echo "Forecasting $file..."

  # run_files and capture the error
  error_output=$(python "$file" 2>&1)

  if [ $? -ne 0]; then
    echo "Error in $file on $(date):"
    echo "$error_output" >>"$error_log"
  else
    echo "$file executed successfully at $(date +'%Y%m%d_%H%M%S')" >>run_info.log
  fi
  echo
done

echo "Script ececution complete. check $error_log for any errors"
