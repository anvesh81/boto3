#!/bin/bash

# Get the current date in the format required for the AWS CLI
current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Get all snapshots that are older than a month
snapshot_list=$(aws ec2 describe-snapshots --query "Snapshots[?StartTime<='$current_date' -30].SnapshotId" --output text)

# Loop through the snapshots and delete each one
for snapshot in $snapshot_list; do
  aws ec2 delete-snapshot --snapshot-id $snapshot
done
