#!/bin/bash

set -e

exec > >(sudo tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo chmod +x /ops/scripts/client.sh
sudo bash -c "REGION=${region} DATACENTER=${datacenter} NOMAD_BINARY=${nomad_binary} /ops/scripts/client.sh \"aws\" \"${retry_join}\" \"${node_class}\""
rm -rf /ops/
