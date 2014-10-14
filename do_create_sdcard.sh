#!/bin/sh
# ==================================================================================
# Purpose: Prepare a Memory Card for deployment onto an embedded target board
#
# See also:
# http://supportnet.mentor.com/docs/201407091/docs/pdfdocs/imx6_sabre_series_qs.pdf
# ==================================================================================

#SDCARD=/dev/sdb
#SDCARD_SIZE=4000317440
TMP_MOUNT=/tmp/rootfs

IMAGES_DIR=~/tmp/builds/mx6q-mel2014.05.361-test1/tmp/deploy/images/mx6q
UBOOT_FILE=${IMAGES_DIR}/u-boot-sabre-sd-2013.04-r0.imx
UIMAGE_FILE=${IMAGES_DIR}/uImage
DTB_FILE=${IMAGES_DIR}/uImage-imx6q-sabresd.dtb
ROOTFS_FILE=${IMAGES_DIR}/ivi-image-mx6q.tar.bz2

#set -x
set -e

if [ "${SDCARD}" = "" ]; then
    echo "ERROR: Please set SDCARD environment variable"
    exit 1
fi
if [ ! -e "${SDCARD}" ]; then
    echo "ERROR: Cannot find memory card: ${SDCARD}"
    exit 1
fi
sz=$(sudo fdisk -l ${SDCARD} | grep '^Disk .* bytes$' | cut -d ' ' -f5)
if [ "$sz" = "" ]; then
    echo "ERROR: Cannot access ${SDCARD}"
    exit 1
fi
if [ "${SDCARD_SIZE}" = "" ]; then
    echo "ERROR: Please set environment variable SDCARD_SIZE=$sz"
    exit 1
fi
if [ "$sz" != "${SDCARD_SIZE}" ]; then
    echo "ERROR: Wrong SD-Card size ($sz bytes) - ${SDCARD_SIZE} expected"
    exit 1
fi

if [ ! -e "${IMAGES_DIR}" ]; then
    echo "ERROR: Cannot find directory ${IMAGES_DIR}"
    exit 1
fi

[ ! -z "${UBOOT_FILE}" ] && if [ ! -e "${UBOOT_FILE}" ]; then
    echo "ERROR: Cannot find ${UBOOT_FILE}"
    exit 1
fi
[ ! -z "${UIMAGE_FILE}" ] && if [ ! -e "${UIMAGE_FILE}" ]; then
    echo "ERROR: Cannot find ${UIMAGE_FILE}"
    exit 1
fi
[ ! -z "${DTB_FILE}" ] && if [ ! -e "${DTB_FILE}" ]; then
    echo "ERROR: Cannot find ${DTB_FILE}"
    exit 1
fi
[ ! -z "${ROOTFSFILE}" ] && if [ ! -e "${ROOTFS_FILE}" ]; then
    echo "ERROR: Cannot find ${ROOTFS_FILE}"
    exit 1
fi

# Make sure that there are no mounted partitions of ${SDCARD}
ls ${SDCARD}* | while read f; do
    sudo sh -c "umount $f 2>/dev/null || true"
done

# Start  | End     | Number of | Size   | Purpose
# sector | sector  | sectors   |        |
# --------------------------------------------------------------------------------------------------
# 0      | 8191    | 8192      | 4 MB   | Unpartitioned space for U-Boot and U-Boot envvars
# 8192   | 24575   | ?         | ? MB   | FAT32 partition for kernel and DTB
# 24576  | ?       | ?         | ? GB   | ext4 partition for the Root Filesystem
#
echo "INFO: Creating partitions on ${SDCARD}"
sudo dd if=/dev/zero of=${SDCARD} bs=512 count=1024
sudo fdisk ${SDCARD} <<END
n
p
1
8192
24575
n
p
2
24576

t
1
c
p
w
END

echo "DEBUG: Format the partition for Kernel and DTP"
sudo mkfs -t vfat ${SDCARD}1

echo "DEBUG: Format the partition for the Root Filesystem"
sudo mkfs -t ext4 ${SDCARD}2

if [ "${UBOOT_FILE}" != "" ]; then
    echo "DEBUG: Load the memory card with the U-Boot loader specific to your target board"
    sudo dd if=${UBOOT_FILE} of=${SDCARD} bs=512 seek=2
fi

mkdir -p ${TMP_MOUNT}

sudo mount ${SDCARD}1 ${TMP_MOUNT}
if [ "${UIMAGE_FILE}" != "" ]; then
    echo "DEBUG: Load the memory card with the Linux kernel image specific to your target board"
    sudo cp ${UIMAGE_FILE} ${TMP_MOUNT}/uImage
fi
if [ "${DTB_FILE}" != "" ]; then
    echo "DEBUG: Load the memory card with the Device Tree Binary (DTB) file specific to your target board"
    sudo cp ${DTB_FILE} ${TMP_MOUNT}/imx6q-sabresd.dtb
fi
sudo umount ${TMP_MOUNT}

sudo mount ${SDCARD}2 ${TMP_MOUNT}
if [ "${ROOTFS_FILE}" != "" ]; then
    echo "DEBUG: Uncompress the RFS tarball to the second partition on the memory card"
    sudo tar -C ${TMP_MOUNT} -xf ${ROOTFS_FILE}
    sync
fi
sudo umount ${TMP_MOUNT}

echo "INFO: Please install the SD-Card onto the target board"

# EOF
