#!/bin/bash
#
# generate an app registration and try to immediately query it's application ID

timestamp=$(date +%s)
app_registration_name="my_app_registration_$timestamp"

# 1) generate app registration
echo "INFO: creating app registration $app_registration_name..."
az ad app create --display-name "$app_registration_name"

# 2) try to get the app ID immediately following creation:
app_id_query="az ad app list --display-name ${app_registration_name} --query [].appId --output tsv"
instant_result=$($app_id_query)
echo "INFO: instant_result is $instant_result"

# wait_for_query_success will loop for a configured time
# if the query passed by argument does not return results it will exit.
wait_for_query_success () {
  query=$1

  sleep_time_in_seconds=10
  max_wait_in_seconds=180
  max_retries=$((max_wait_in_seconds/sleep_time_in_seconds))

  count=1

  while [[ -z $($query)  ]]
  do
      echo "INFO: waiting for query \"$query\" to return results ($count/$max_retries)..."
      echo "INFO: trying again in $sleep_time_in_seconds seconds..."
      sleep "$sleep_time_in_seconds"

      if [[ $count -eq max_retries ]]; then
          echo "ERROR: unable to get results for query \"$query\" within $max_wait_in_seconds seconds."
          exit 1
      fi

      count=$((count +1))
  done
}

# 3) use `wait_for_query_success` to accomodate transient failures where
#    app creation completes but an immediate query for it will fail
wait_for_query_success "$app_id_query"

# 4) then after the query returns results, retrieve it's value
result_after_wait=$($app_id_query)
echo "INFO: result_after_wait is ${result_after_wait}"

# 5) clean up created resource
echo "INFO: deleting $app_registration_name by ID $result_after_wait..."
az ad app delete --id "$result_after_wait"
