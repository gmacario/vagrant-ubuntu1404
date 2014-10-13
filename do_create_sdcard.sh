#!/bin/sh
# ==================================================================================
# Purpose: Prepare a Memory Card for deployment onto an embedded target board
#
# See also:
# http://supportnet.mentor.com/docs/201407091/docs/pdfdocs/imx6_sabre_series_qs.pdf
# ==================================================================================

SDCARD_DEV=/dev/sdb
SDCARD_SIZE=4000317440
TMP_MOUNT=/tmp/rootfs

IMAGES_DIR=builds/mx6q-mel2014.05.361-test1/tmp/deploy/images/mx6q
UBOOT_FILE=${IMAGES_DIR}/u-boot-sabre-sd-2013.04-r0.imx
#UIMAGE_FILE=${IMAGES_DIR}/uImage-mx6q.bin
#DTB_FILE=${IMAGES_DIR}/uImage-imx6q-sabresd.dtb
#ROOTFS_FILE=${IMAGES_DIR}/ivi-image-mx6q.tar.bz2

#set -x
set -e

echo "INFO: Creating image on SDCARD_DEV ${SDCARD_DEV}"

#if [ $(whoami) != root ]; then
#    echo "ERROR: The script must be run as root"
#    exit 1
#fi
if [ ! -e "${SDCARD_DEV}" ]; then
    echo "ERROR: ${SDCARD_DEV} does not exist"
    exit 1
fi
sz=$(sudo fdisk -l ${SDCARD_DEV} | grep '^Disk .* bytes$' | cut -d ' ' -f5)
if [ "$sz" = "" ]; then
    echo "ERROR: Cannot access ${SDCARD_DEV}"
    exit 1
fi
#echo "DEBUG: sz=$sz"
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

# Make sure that there are no mounted partitions of ${SDCARD_DEV}
ls ${SDCARD_DEV}* | while read f; do
    sudo sh -c "umount $f 2>/dev/null || true"
done

# Create partitions on SDCARD_DEV
#
# Start  | End     | Number of | Size   | Purpose
# sector | sector  | sectors   |        |
# --------------------------------------------------------------------------------------------------
# 0      | 16383   | 16384     | 8 MB   | Unpartitioned space for U-Boot, kernel and U-Boot envvars
# 16384  | 7744512 | 7662592   | ~3.7GB | Partitioned space for the Root Filesystem
#
sudo dd if=/dev/zero of=${SDCARD_DEV} bs=512 count=1024
sudo fdisk ${SDCARD_DEV} <<END
n
p
1
16384
7744512
w
END

# Format the RFS partition
sudo mkfs -t ext3 ${SDCARD_DEV}1

if [ "${UBOOT_FILE}" != "" ]; then
    echo "DEBUG: Load the memory card with the U-Boot loader specific to your target board"
    sudo dd if=${UBOOT_FILE} of=${SDCARD_DEV} bs=512 seek=2
fi

if [ "${UIMAGE_FILE}" != "" ]; then
    echo "DEBUG: Load the memory card with the Linux kernel image specific to your target board"
    sudo dd if=${UIMAGE_FILE} of=${SDCARD_DEV} bs=512 seek=2048
fi

if [ "${DTB_FILE}" != "" ]; then
    echo "DEBUG: Load the memory card with the Device Tree Binary (DTB) file specific to your target board"
    sudo dd if=${DTB_FILE} of=${SDCARD_DEV} bs=512 seek=1536
fi

if [ "${ROOTFS_FILE}" != "" ]; then
    echo "DEBUG: Copy and uncompress the RFS partition to the one partitioned space on the memory card"
    mkdir -p ${TMP_MOUNT}
    sudo mount ${SDCARD_DEV}1 ${TMP_MOUNT}
    sudo tar -C ${TMP_MOUNT} -xf ${ROOTFS_FILE}
    sync
    sudo umount ${TMP_MOUNT}
fi

echo "INFO: Please install the SD-Card onto the target board"

# EOF
