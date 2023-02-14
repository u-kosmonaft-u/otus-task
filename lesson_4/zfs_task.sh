#!/bin/bash

############################# Best compression determination #############################

ROOT_DEVICE=$(mount | grep "on / type" | awk '{print $1}' | sed 's/[0-9]//g')

compression=(
 lzjb
 lz4
 gzip-9
 zle
)

# Show device in /dev/sd
lsblk

# Create zpool
for i in {1..4};
  do zpool create otus"$i" mirror $(find /dev/sd[a-z] | grep -v "$ROOT_DEVICE" | paste -s -d " \n" | head -n "$i" | tail -1);
done

# Show pools
zpool list

# Add compression algorithms to different pools
i=0
while [ $i -lt ${#compression[*]} ]; do
  zfs set compression=${compression[$i]} otus$(( $i + 1))
  i=$(( $i + 1));
done

# Show compression in different pools
zfs get all | grep compression

# Download file
for i in {1..4};
  do wget -q -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log;
done

# Show files capacity
ls -l /otus* && zfs list && zfs get all | grep compressratio | grep -v refotus1

############################ Define pool settings ############################

# Donwload and unarchive archive
wget --no-check-certificate -q -O- 'https://docs.google.com/uc?export=download&id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg' | tar -xzv

# Check that archive can be imported
zpool import -d zpoolexport/

# Import
zpool import -d zpoolexport/ otus && zpool status

# Check settings
zpool get all otus &&
for i in available readonly recordsize compression checksum;
  do zfs get $i otus;
done

########################### Snapshot Work ######################################

# Download and restore file
wget --no-check-certificate -O- -q 'https://docs.google.com/uc?export=download&id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG' | zfs receive otus/test@today
SECRET=$(cat $(find /otus/test -name "secret_message"))
echo $SECRET
git clone $SECRET
ls -la ./awesome