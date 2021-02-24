#!/bin/bash

set -e

exec > >(sudo tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo chmod +x /ops/scripts/server.sh
sudo bash -c "REGION=${region} DATACENTER=${datacenter} NOMAD_BINARY=${nomad_binary} /ops/scripts/server.sh \"aws\" \"${server_count}\" \"${retry_join}\""
rm -rf /ops/
