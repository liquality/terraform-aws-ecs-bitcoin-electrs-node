#!/bin/bash

set -x

echo

# ------------------------------------------------------------------------------
# Configure ECS agent
# ------------------------------------------------------------------------------
echo "Configuring ECS agent for cluster \"${CLUSTER_NAME}\"" >> init-ec2-log.txt

# Add cluster name to ECS config
echo ECS_CLUSTER=${CLUSTER_NAME} >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"

sed -i '/After=cloud-final.service/d' /usr/lib/systemd/system/ecs.service
systemctl daemon-reload

# Verify that the ECS cluster agent is running
until curl -s http://localhost:51678/v1/metadata
do
	sleep 1s
done

# ------------------------------------------------------------------------------
# Mount bitcoin chain data volume
# ------------------------------------------------------------------------------
sleep 5s
echo "Preparing to mount \"${CHAIN_MOUNT_POINT}\" onto EBS device \"${CHAIN_DEVICE_NAME}\"" >> init-ec2-log.txt

lsblk -f >> init-ec2-log.txt # for debugging

# Linux uses the final character from the volume device name (onto /xvd*)
device_char=`echo -n ${CHAIN_DEVICE_NAME} | tail -c 1`
true_device_name="/dev/xvd$device_char"
echo "Using device \"$true_device_name\"" >> init-ec2-log.txt

# Check file system format
fs_type=$(sudo file -s $true_device_name | awk '{print $2}')
echo "File system determined to be \"$fs_type\"" >> init-ec2-log.txt

# Returns "data" when no file system exists on the partition
if [ "$fs_type" = "data" ]
then
  echo "Creating file system (ext4) on \"$true_device_name\"" >> init-ec2-log.txt
  sudo mkfs -t ext4 $true_device_name >> init-ec2-log.txt
fi

# Mount directory to volume
echo "Mounting volume" >> init-ec2-log.txt
sudo mkdir ${CHAIN_MOUNT_POINT}
sudo mount $true_device_name ${CHAIN_MOUNT_POINT}
sudo chown ec2-user ${CHAIN_MOUNT_POINT}
stat -c '%U' ${CHAIN_MOUNT_POINT} >> init-ec2-log.txt # validate owner change

# Save mount on restart (in /etc/fstab)
echo "Saving mount for restart" >> init-ec2-log.txt
blk_id="$(sudo blkid -s UUID -o value $true_device_name)"
echo "UUID=$blk_id    ${CHAIN_MOUNT_POINT}    ext4    defaults,nofail    1    2" | sudo tee -a /etc/fstab

# ------------------------------------------------------------------------------
# Mount electrs indexer data volume
# ------------------------------------------------------------------------------
echo "Preparing to mount \"${ELECTRS_MOUNT_POINT}\" onto EBS device \"${ELECTRS_DEVICE_NAME}\"" >> init-ec2-log.txt

lsblk -f >> init-ec2-log.txt # for debugging

# Linux uses the final character from the volume device name (onto /xvd*)
device_char=`echo -n ${ELECTRS_DEVICE_NAME} | tail -c 1`
true_device_name="/dev/xvd$device_char"
echo "Using device \"$true_device_name\"" >> init-ec2-log.txt

# Check file system format
fs_type=$(sudo file -s $true_device_name | awk '{print $2}')
echo "File system determined to be \"$fs_type\"" >> init-ec2-log.txt

# Returns "data" when no file system exists on the partition
if [ "$fs_type" = "data" ]
then
  echo "Creating file system (ext4) on \"$true_device_name\"" >> init-ec2-log.txt
  sudo mkfs -t ext4 $true_device_name >> init-ec2-log.txt
fi

# Mount directory to volume
echo "Mounting volume" >> init-ec2-log.txt
sudo mkdir ${ELECTRS_MOUNT_POINT}
sudo mount $true_device_name ${ELECTRS_MOUNT_POINT}
sudo chown ec2-user ${ELECTRS_MOUNT_POINT}
stat -c '%U' ${ELECTRS_MOUNT_POINT} >> init-ec2-log.txt # validate owner change

# Save mount on restart (in /etc/fstab)
echo "Saving mount for restart" >> init-ec2-log.txt
blk_id="$(sudo blkid -s UUID -o value $true_device_name)"
echo "UUID=$blk_id    ${ELECTRS_MOUNT_POINT}    ext4    defaults,nofail    1    2" | sudo tee -a /etc/fstab

# ------------------------------------------------------------------------------
# Install the Docker volume plugin for EBS (REX-Ray)
# ------------------------------------------------------------------------------
echo "Installing REX-Ray plugin" >> init-ec2-log.txt
docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${REGION} --grant-all-permissions

# ------------------------------------------------------------------------------
# Start container
# ------------------------------------------------------------------------------
echo "Starting container" >> init-ec2-log.txt
systemctl restart docker
systemctl restart ecs
