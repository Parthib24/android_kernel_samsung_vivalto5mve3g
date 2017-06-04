#!/bin/bash
##
#  Copyright (C) 2015, Samsung Electronics, Co., Ltd.
#  Written by System S/W Group, S/W Platform R&D Team,
#  Mobile Communication Division.
##

set -e -o pipefail

DEFCONFIG=apias_defconfig
VERSION=v3.10.17
DEVICE=vivalto5mve
OWNER=Parthib
NOW=`date "+%d%m%Y-%H%M%S"`
PREFIX=RKR
OUTPUT=Output

export CROSS_COMPILE=/home/parthib/arm-eabi-4.9/bin/arm-eabi-
export ARCH=arm
export LOCALVERSION=-`echo ace4krnl`

KERNEL_PATH=$(pwd)
MODULES=${KERNEL_PATH}/drivers

JOBS=`grep processor /proc/cpuinfo | wc -l`

function build_kernel() {
    mkdir ${OUTPUT}
	make ${DEFCONFIG}
	make -j${JOBS}
	mkdir ${OUTPUT}/Modules
	find ${KERNEL_PATH}/drivers -name "*.ko" -exec cp -f {} ${KERNEL_PATH}/${OUTPUT}/Modules \;
	find ${KERNEL_PATH} -name zImage -exec cp -f {} ${KERNEL_PATH}/${OUTPUT}/zImage-${DEVICE}-${NOW} \;
	echo -e $COLOR_YELLOW"ZIMAGE IS IN OUTPUT FOLDER"
}

function rm_out() {
	rm -rf ${KERNEL_PATH}/${OUTPUT}
	echo -e $COLOR_RED"OUTPUT FOLDER IS DELETED"
}

function make_clean(){
	find ${KERNEL_PATH} -name zImage -exec rm -f {} \;
	find ${KERNEL_PATH} -name "*.ko" -exec rm -f {} \;
	make mrproper && make clean
}

COLOR_RED=$(tput bold)$(tput setaf 1)
COLOR_BLUE=$(tput bold)$(tput setaf 4)
COLOR_YELLOW=$(tput bold)$(tput setaf 3)
COLOR_NEUTRAL="\033[0m"	
COLOR_GREEN="\033[1;32m"

clear
echo
echo -e $COLOR_RED"================================================"
echo -e $COLOR_BLUE"       BUILD SCRIPT FOR BUILDING KERNEL"
echo               "             MODIFIED BY PARTHIB"
echo               "       Script By MUHAMMAD IHSAN <Ih24n>"
echo -e $COLOR_RED"================================================"
echo
echo -e $COLOR_YELLOW"  Device name     :  Ace 4 (SM-G316HU)"
echo -e $COLOR_YELLOW"  Kernel version  :  $VERSION"
echo -e $COLOR_YELLOW"  Build user      :  $USER"
echo -e $COLOR_YELLOW"  Build date      :  $NOW"
echo
echo "================================================"
echo -e $COLOR_GREEN"               Function menu flag"$COLOR_NEUTRAL
echo "================================================"
echo
echo "  1  = Delete .config/clean cache"
echo -e $COLOR_GREEN"  2  = Start building kernel"$COLOR_NEUTRAL
echo "  3  = Delete Output"
echo
echo "================================================"
echo -e $COLOR_YELLOW"       JUST CHOOSE THE NUMBER,"
echo "       AND WAIT UNTIL PROCESS DONE!"
echo "================================================"
read -p "$COLOR_BLUE Whats Your Choice? " -n 1 -s x
echo -e $COLOR_GREEN

case "$x" in
	1)
		make_clean
		exit
		;;
	2)
		build_kernel
		exit
		;;
	3)
		rm_out
		exit
		;;	
	esac

exit
