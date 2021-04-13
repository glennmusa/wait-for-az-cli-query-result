# wait-for-az-cli-query-result

Create some identity and try to immediately query for the result, waiting until the result comes back.

## create_app_registration

As of 20210413, in AzureCloud this works without issue, but in AzureUsGovernment we must wait an intederminate amount of time for results to come back.

From AzureCloud:

```bash
az cloud set -n AzureCloud
az login
./create_app_registration.sh
INFO: creating app registration my_app_registration_1618328543...
INFO: instant_result is abcde123-4567-90fg-hi12-345jklm6789n
INFO: result_after_wait is abcde123-4567-90fg-hi12-345jklm6789n
INFO: deleting my_app_registration_1618328543 by ID abcde123-4567-90fg-hi12-345jklm6789n...
```

From AzureGovernment:

```plaintext
az cloud set -n AzureUsGovernment
az login
./create_app_registration.sh
INFO: creating app registration my_app_registration_1618328543...
INFO: instant_result is
INFO: waiting for query "az ad app list --display-name my_app_registration_1618328588 --query [].appId --output tsv" to return results (1/18)...
INFO: trying again in 10 seconds...
INFO: result_after_wait is abcde123-4567-90fg-hi12-345jklm6789n
INFO: deleting my_app_registration_1618328543 by ID abcde123-4567-90fg-hi12-345jklm6789n...
```
