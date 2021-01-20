#!/usr/bin/env bash


# Find provided connector configs for that Kafka Connect cluster
distributedConnectors=($(find /tmp/ -maxdepth 1 -regex ".*${CONNECT_GROUP_ID}.*\.json$"))
if [[ ! ${distributedConnectors-} ]]; then
    echo "INFO" "distributed-load-connectors.sh: No connector configs found in ${CONNECTOR_CONFIGS}... ";
    echo "INFO" "distributed-load-connectors.sh: ... will not upload any configs, please send them through REST API to port ${CONNECT_REST_PORT}...";else
  # Loop over provided connector configs
  for connector in ${distributedConnectors[*]}; do
    connectorName=$(jq -r '.name' ${connector})
    connectorConfigFile=$(jq -S -c '.config' ${connector})
    connectorConfigRest=$(curl -X GET -s http://localhost:${CONNECT_REST_PORT}/connectors/${connectorName}/config | jq -S -c 'del(.name) | .')
    # Only PUT the connector config if it differs from already configured connector
    echo "INFO" "distributed-load-connectors.sh: Connector config from file ${connector}... ${connectorConfigFile}";
    echo "INFO" "distributed-load-connectors.sh: Connector config from REST for ${connectorName} ... ${connectorConfigRest}";
    if [[ "${connectorConfigFile}" != "${connectorConfigRest}" ]]; then
      echo "INFO" "distributed-load-connectors.sh: New connector config for ${connector}... uploading config using curl";
      resultConfigPut=$(curl -X PUT -s -H "Content-Type: application/json" --data ${connectorConfigFile} http://localhost:${CONNECT_REST_PORT}/connectors/${connectorName}/config);
      echo "INFO" "distributed-load-connectors.sh: Result of config PUT: ${resultConfigPut}";
    else
      echo "INFO" "distributed-load-connectors.sh: Config for connector ${connector} up to date... skipping";
    fi
  done
fi
