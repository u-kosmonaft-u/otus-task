#!/bin/bash

# This is a sample script that identify raw devices e.g. /dev/sdc, /dev/sdd. /dev/sde, etc.
# It will create a raid mdam volume with all available devices and
# configure auto mount on /etc/fstab
# This script is tested to work with CentOS 7.x OS

set -e

if [[ $(id -u) -ne 0 ]] ; then
    echo "Must be run as root"
    exit 1
fi

FILE_SYSTEM="ext4"
IS_RAID=true
DISABLE_FS_CHECK=false
EXPECTED_DEVICE_COUNT=0
RETRY_TIME=5
RETRIES=120

usage()
{
    echo "Usage:"
    echo "  $0 [OPTIONS]"
    echo "    -m <MOUNT_POINT>          [Required]: Destination mount point. If IS_RAID is set to true, a raid 0 volume will be mounted in this single moint point."
    echo "                              If IS_RAID is not set (default), make sure that you provide all mount points that will matches each disk, e.g. -m '/mnt/data,/mnt/db' for a 2 data disks configuration."
    echo "                              Note: don't use spaces between the mount point list."
    echo "    -f <FILE_SYSTEM>          File system, defaults to ext4."
    echo "    -d                        Sets DISABLE_FS_CHECK flag to true, this will disable the automatic filesystem check every 180 days or 30 mounts. Defaults to false."
    echo "    -e                        Expected number of devices. Zero means that this test will not be performed. Defaults to 0."
    echo "    -r                        Retry count to get new device count. Defaults to 60 retries."
    echo "    -t                        Time (in seconds) between retries to get new device count. Default to 5 seconds."
    echo "    -l                        RAID type default is 0"
}

while getopts "m:f:de:r:t:l:" opt; do
    case ${opt} in
        # Set Mount Point
        m )
            MOUNT_POINT=$OPTARG
            if [ -d $MOUNT_POINT ]; then
                echo "$MOUNT_POINT exist. Continuing..."
            else
              echo "$MOUNT_POINT don't exist. Creating..."
              mkdir $MOUNT_POINT
            fi
            echo "    Mount point: $MOUNT_POINT"
            ;;
        # Set File System
        f )
            FILE_SYSTEM=$OPTARG
            echo "    File System: $FILE_SYSTEM"
            ;;
        # Set disable filesystem check flag
        d )
            DISABLE_FS_CHECK=true
            echo "    Disable filesystem check: $DISABLE_FS_CHECK"
            ;;
        # Set the device count
        e )
            EXPECTED_DEVICE_COUNT=$OPTARG
            echo "    Expected Device Count: $EXPECTED_DEVICE_COUNT"
            ;;
        # Set retries
        r )
            RETRIES=$OPTARG
            echo "    Retry count: $RETRIES"
            ;;
        # Set retry wait time
        t )
            RETRY_TIME=$OPTARG
            echo "    Retry time in seconds: $RETRY_TIME"
            ;;
        l )
            RAID_LVL=$OPTARG
            echo "    RAID level: $RAID_LVL"
            ;;
        # Catch call, return usage and exit
        h  ) usage; exit 0;;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
    case $RAID_LVL in
    0) if [ $EXPECTED_DEVICE_COUNT -le 1 ]; then
      echo "Warning! $RAID_LVL will not work correctly with $EXPECTED_DEVICE_COUNT block device!" >&2
    fi

      ;;
    1) if [ $EXPECTED_DEVICE_COUNT -le 2 ]; then
      echo "Error! For correctly working RAID $RAID_LVL needs more then 1 block device, but only $EXPECTED_DEVICE_COUNT declared"
    fi

      ;;
    2) if [ $EXPECTED_DEVICE_COUNT -le 7 ]; then
        echo "Error! Use RAID $RAID_LVL with block device count lower than 7 is meaningless" >&2
        exit 1
    fi

      ;;

    5) if [ $EXPECTED_DEVICE_COUNT -le 3 ]; then
        echo "Error! Use RAID $RAID_LVL with block device count lower than 3 is meaningless" >&2
        exit 1
    fi

      ;;

    6) if [ $EXPECTED_DEVICE_COUNT -le 4 ]; then
        echo "Error! Use RAID $RAID_LVL with block device count lower than 3 is meaningless" >&2
        exit 1
    fi

      ;;
    esac
done

if [ $OPTIND -eq 1 ]; then echo; echo "No options were passed"; echo; usage; exit 1; fi
shift $((OPTIND -1))

if [ -z "$MOUNT_POINT" ]; then
    echo "Error: Required mount point path not provided!"
    exit 1
fi

if $(grep -q "$MOUNT_POINT $FILE_SYSTEM" /etc/fstab); then
    echo "We're already configured, exiting..."
    exit 0
fi

if [ -z "$RAID_LVL" ]; then
    RAID_LVL=0
fi

RAID_DEVICE="md0"

echo "Getting device list..."
# Get the root/OS disk so we know which device it uses and can ignore it later
# shellcheck disable=SC2006
ROOT_DEVICE=$(mount | grep "on / type" | awk '{print $1}' | sed 's/[0-9]//g')
echo "ROOT_DEVICE = $ROOT_DEVICE"

echo "Identifying devices..."
if [ $EXPECTED_DEVICE_COUNT -gt 0 ]; then
    DEVICE_LIST=()
    COUNTER=0
    while [ ! ${#DEVICE_LIST[@]} -ge $EXPECTED_DEVICE_COUNT ]
    do
        echo "Attempt # $COUNTER to identify all devices..."
        echo "   Current Device Count is ${#DEVICE_LIST[@]}"
        echo "   Expected Device Count $EXPECTED_DEVICE_COUNT"

        # Get the TMP disk so we know which device and can ignore it later
        TMP_DEVICE=$(mount | grep "on /mnt/resource type" | awk '{print $1}' | sed 's/[0-9]//g')

        if [ -z $TMP_DEVICE ]; then
            TMP_DEVICE=$(mount | grep "on /mnt type" | awk '{print $1}' | sed 's/[0-9]//g')
        fi

        echo "TMP_DEVICE = $TMP_DEVICE"

        if [ -z $TMP_DEVICE ]; then
            DATA_DISK_SIZE=$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep -v 'loop' | awk '{print $3}' | sort -n -r | tail -1)
            echo "   DATA_DISK_SIZE = $DATA_DISK_SIZE"
            DEVICE_LIST=("$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep $DATA_DISK_SIZE | grep -v 'loop' | awk '{print $2}' | awk -F: '{print $1}' | sort | tr '\n' ' ' | sed 's|/dev/||g')")
            DEVICE_LIST=($(echo $DEVICE_LIST | tr ' ' "\n"))
        else
            DATA_DISK_SIZE=$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep -v $TMP_DEVICE | grep -v 'loop' | awk '{print $3}' | sort -n -r | tail -1)
            echo "   DATA_DISK_SIZE = $DATA_DISK_SIZE"
            DEVICE_LIST=("$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep -v $TMP_DEVICE | grep $DATA_DISK_SIZE | grep -v 'loop' | awk '{print $2}' | awk -F: '{print $1}' | sort | tr '\n' ' ' | sed 's|/dev/||g')")
            DEVICE_LIST=($(echo $DEVICE_LIST | tr ' ' "\n"))
        fi

        if [ $COUNTER -gt $RETRIES ] || [ ${#DEVICE_LIST[@]} -ge $EXPECTED_DEVICE_COUNT ]; then
            break
        fi

        sleep $RETRY_TIME
        COUNTER=$((COUNTER+1))
    done
else
  if [ -z $TMP_DEVICE ]; then
    DATA_DISK_SIZE=$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep -v 'loop' | awk '{print $3}' | sort -n -r | tail -1)
    DEVICE_LIST=("$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep $DATA_DISK_SIZE | grep -v 'loop' | awk '{print $2}' | awk -F: '{print $1}' | sort | tr '\n' ' ' | sed 's|/dev/||g')")
    DEVICE_LIST=($(echo $DEVICE_LIST | tr ' ' "\n"))
  else
    DATA_DISK_SIZE=$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep -v $TMP_DEVICE | grep -v 'loop' | awk '{print $3}' | sort -n -r | tail -1)
    DEVICE_LIST=("$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep -v $TMP_DEVICE | grep $DATA_DISK_SIZE | grep -v 'loop' | awk '{print $2}' | awk -F: '{print $1}' | sort | tr '\n' ' ' | sed 's|/dev/||g')")
    DEVICE_LIST=($(echo $DEVICE_LIST | tr ' ' "\n"))
  fi
fi


if [ -z $TMP_DEVICE ]; then
  DEVICE_LIST_STRING="$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep $DATA_DISK_SIZE | grep -v 'loop' | awk '{print $2}' | awk -F: '{print $1}' | sort | tr '\n' ' ')"
else
  DEVICE_LIST_STRING="$(fdisk -l | grep '^Disk /dev/' | grep -v $ROOT_DEVICE | grep -v $TMP_DEVICE | grep $DATA_DISK_SIZE | grep -v 'loop' | awk '{print $2}' | awk -F: '{print $1}' | sort | tr '\n' ' ')"
fi

echo "Final device list...........: ${DEVICE_LIST[@]}"
echo "Final device list string....: ${DEVICE_LIST_STRING}"

DEVICE_COUNT=${#DEVICE_LIST[@]}

echo "Device Count...: $DEVICE_COUNT"

if [ $DEVICE_COUNT -gt 1 ]; then
    echo "RAID volumes ..."

    echo "Checking if mdadm is installed, will install if does not exist..."
    if [ ! -x "$(command -v mdam)" ]; then
        echo "    Installing mdadm package"

        if [ -x "$(command -v apt-get)" ]; then
            apt-get install mdadm -y
        elif [ -x "$(command -v yum)" ]; then
            yum install mdadm -y
        else
            echo "Error installing mdadm package, no identified packet manager found (yum or apt-get)"
            exit 1;
        fi
    fi

    echo "Checking if lsb_release is installed, will install if does not exist..."
    if [ ! -x "$(command -v lsb_release)" ]; then
        echo "    Installing redhat-lsb package"

        if [ -x "$(command -v apt-get)" ]; then
            apt-get install lsb-release -y
        elif [ -x "$(command -v yum)" ]; then
            yum install redhat-lsb -y
        else
            echo "Error installing lsb_release package, no identified packet manager found (yum or apt-get)"
            exit 1;
        fi
    fi

    CMD="yes | mdadm --create /dev/$RAID_DEVICE --level $RAID_LVL --force --raid-devices $DEVICE_COUNT $DEVICE_LIST_STRING"
    echo "mdadm commandline: $CMD"
    eval $CMD

    echo "Updating mdadm.conf file"

    DISTRIB=($(lsb_release -i | grep "Distributor ID:" | awk -F: '{print $2}' | tr -d $"\t" | tr '[:upper:]' '[:lower:]'))

    if [  "$DISTRIB" == "centos" ]; then
        mdadm --detail --scan >> /etc/mdadm.conf
    elif [ "$DISTRIB" == "ubuntu" ]; then
        mdadm --detail --scan >> /etc/mdadm/mdadm.conf
    else
        echo "Distribution not supported in this script"
        exit 1
    fi

    if [ -x "$(command -v update-initramfs)" ]; then
        echo "Updating Initrd"
        update-initramfs -u
    fi

    echo "Partitioning disks..."
    parted -s /dev/$RAID_DEVICE mklabel gpt
    for i in 20 40 60 80 100; do
      parted /dev/$RAID_DEVICE mkpart primary ext4 $(($i-20))% $i%;
    done

    # Setting up /etc/fstab

    if [ "$FILE_SYSTEM" == "xfs" ]; then
      for i in $(seq 1 $DEVICE_COUNT); do
        mkfs -t $FILE_SYSTEM /dev/$RAID_DEVICE"p"$i
        UUID_GUID=$(/sbin/blkid | grep /dev/$RAID_DEVICE"p"$i | cut -d " " -f 2 | cut -c 7-42)
        echo "UUID=$UUID_GUID $MOUNT_POINT $FILE_SYSTEM rw,noatime,attr2,inode64,nobarrier,sunit=1024,swidth=4096,nofail 0 2" >> /etc/fstab
      done
    else
      for i in $(seq 1 $DEVICE_COUNT); do
        mkdir "$MOUNT_POINT"/"$i"
        MOUNT_PATH="$MOUNT_POINT"/"$i"
        mkfs.ext4 /dev/$RAID_DEVICE"p"$i
        sleep 5
        tune2fs -o user_xattr /dev/$RAID_DEVICE"p"$i
        UUID_GUID=$(/sbin/blkid | grep /dev/$RAID_DEVICE"p"$i | cut -d " " -f 2 | cut -c 7-42)
        echo $UUID_GUID
        echo "UUID=$UUID_GUID $MOUNT_PATH $FILE_SYSTEM noatime,nodiratime,nobarrier,nofail 0 2" >> /etc/fstab
      done
    fi

    if $DISABLE_FS_CHECK; then
        echo "Removing boot blocking check of every 180 days with tune2fs..."
        tune2fs -c 0 /dev/$RAID_DEVICE
    fi

    echo "Mounting disk..."

    mount -a
fi