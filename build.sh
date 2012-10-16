#!/bin/bash
# Copyright (c) 2011 The Regents of The University of Michigan
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met: redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer;
# redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution;
# neither the name of the copyright holders nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


if [ -z "$USE_EFFEX" ]; then
	export OpenCV_DIR="/home/jlclemon/Documents/OpenCV/OpenCV2.4.2NativeInstall"
else
	export OpenCV_DIR="/home/jlclemon/Documents/OpenCV/OpenCV2.4.2NativeCustomInstall"
fi

#"/home/jlclemon/Documents/OpenCV/OpenCV2.2NativeInstall/"
export OpenCV_STATIC_DIR="/home/jlclemon/Documents/OpenCV/OpenCV2.4.2NativeStaticInstall"
#"/home/jlclemon/Documents/OpenCV/OpenCV2.2NativeStaticInstall/"

if [ -z "$USE_EFFEX" ]; then

	export OpenCV_ARM_DIR="$HOME/Documents/OpenCV/OpenCV2.3.1ArmInstall"
	export OpenCV_ARM_STATIC_DIR="$HOME/Documents/OpenCV/OpenCV2.3.1ArmStaticInstall"
else
	export OpenCV_ARM_DIR="$HOME/Documents/OpenCV/OpenCV2.3.1ArmInstall"
	export OpenCV_ARM_STATIC_DIR="$HOME/Documents/OpenCV/OpenCV2.4.2ArmStaticSoftFloatEffexInstall"

fi


if [ -n "$XTRA_PARAMS" ]; then
	echo "Setting XTR_PARAMS=$XTRA_PARAMS based on pre defined value"
	#export XTRA_PARAMS="$XTRA_PARAMS -DUSE_MARSS"
	#export XTRA_PARAMS="$XTRA_PARAMS -DTSC_TIMING"
	#export XTRA_PARAMS="$XTRA_PARAMS -DCLOCK_GETTIME_TIMING"

else

	#export XTRA_PARAMS="-DUSE_MARSS"
	#export XTRA_PARAMS="-DTSC_TIMING"

	export XTRA_PARAMS="-DCLOCK_GETTIME_TIMING -DOPENCV_2_4"
fi
if [ -n "$USE_EFFEX" ]; then
	echo "$USE_EFFEX Using Effex"
	export XTRA_LIBS="opencv_effex"
	export XTRA_PARAMS="$XTRA_PARAMS -DUSE_EFFEX_CMAC -DUSE_EFFEX_OTM -DUSE_EFFEX_TREE -DUSE_EFFEX_MAX -DUSE_CACHE_AND_PREFETCH"

fi

export ARM_XTRA_PARAMS="-DOPENCV_2_4 -DUSE_GEM5 -DCLOCK_GETTIME_TIMING -mno-unaligned-access"
#-DOPENCV_VER_2_3
if [ -n "$USE_EFFEX_INSTR" ]; then


	export ARM_XTRA_PARAMS="$ARM_XTRA_PARAMS -DUSE_EFFEX_DATA_INSTR_CMAC -DUSE_EFFEX_DATA_INSTR_OTM -DUSE_CACHE_AND_PREFETCH_INSTR -DUSE_EFFEX_DATA_INSTR_TREE -DUSE_EFFEX_DATA_INSTR_MAX"

fi
if [ -n "$USE_EFFEX" ]; then


	export ARM_XTRA_PARAMS="$ARM_XTRA_PARAMS -DUSE_EFFEX_CMAC -DUSE_EFFEX_OTM -DUSE_EFFEX_TREE -DUSE_EFFEX_MAX -DUSE_CACHE_AND_PREFETCH"

fi


BASEDIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_ARM="FALSE"

if [ $# == 0 ]; then
    echo "Usage: $0 [cleanAll|static|dyanmic|allVersions| FeatureExtraction[Static]| FeatureClassification[Static]|ObjectRecognition[Static]|FaceDetection[Static]|AugmentedReality[Static]| [arm]]"
    echo ""
    echo " options: "
    echo "  cleanAll                        -  Clean all built files"
    echo "  static                          -  Builds static linked library versions of the benchmarks"
    echo "  dynamic                         -  Builds dynamic link library versions of the benchmarks"
    echo "  allVersions                     -  Builds both static and dynamic linked versions of the benchmarks"
    echo "  FeatureExtraction[Static]       -  Build feature extraction benchmarks"
    echo "  FeatureClassification[Static]   -  Build feature classification benchmarks"
    echo "  ObjectRecognition[Static]       -  Build object recongition benchmark"
    echo "  FaceDetection[Static]           -  Build face detection benchmark"
    echo "  AugmentedReality[Static]        -  Build augmented reality benchmark"
    echo "  [arm]                           -  Cross compile for arm7v-a"
    exit
fi

for argument in $*
do
    if [ "$argument" == "arm"  -o "$argument" == "ARM" ]; then

	BUILD_ARM="TRUE"
	#echo "Cross compiling for arm..."


    fi
done

if [ $BUILD_ARM == "FALSE" ]; then
	echo "Building for native architecture..."
	while [ $# -gt 0 ];
	do
	    if [ "${1}" == "static" ]; then

		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"


		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "dynamic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"


		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi
	    if [ "${1}" == "allVersions" ]; then
		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"


		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"





	    fi
	    if [ "${1}" == "cleanAll" ]; then

		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make clean
		make --file=makefile_static clean

		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make clean
		make --file=makefile_static clean

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make clean
		make --file=makefile_static clean

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make clean
		make --file=makefile_static clean

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make clean
		make --file=makefile_static clean

	  


	    fi

	    if [ "${1}" == "AugmentedReality" ]; then

		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "AugmentedRealityStatic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi



	    if [ "${1}" == "FaceDetection" ]; then

		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "FaceDetectionStatic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi

	    if [ "${1}" == "ObjectRecognition" ]; then

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "ObjectRecognitionStatic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi

	    if [ "${1}" == "FeatureClassification" ]; then

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "FeatureClassificationStatic" ]; then
		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi

	    if [ "${1}" == "FeatureExtraction" ]; then

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make clean
		make XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "FeatureExtractionStatic" ]; then
		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_static clean
		make --file=makefile_static XTRA_PARAMS="$XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi




	    shift
	done
else

	echo "Cross Compiling for armv7-a..."
	while [ $# -gt 0 ];
	do
	    if [ "${1}" == "static" ]; then

		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"


		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "dynamic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"


		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi
	    if [ "${1}" == "allVersions" ]; then
		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"


		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"





	    fi
	    if [ "${1}" == "cleanAll" ]; then

		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_arm clean
		make --file=makefile_arm_static clean

		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_arm clean
		make --file=makefile_arm_static clean

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_arm clean
		make --file=makefile_arm_static clean

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_arm clean
		make --file=makefile_arm_static clean

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_arm clean
		make --file=makefile_arm_static clean

	  


	    fi

	    if [ "${1}" == "AugmentedReality" ]; then

		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "AugmentedRealityStatic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/AugmentedReality"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi



	    if [ "${1}" == "FaceDetection" ]; then

		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "FaceDetectionStatic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/FaceDetection"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi

	    if [ "${1}" == "ObjectRecognition" ]; then

		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "ObjectRecognitionStatic" ]; then
		cd "$BASEDIR/Benchmarks/Applications/ObjectRecognition"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi

	    if [ "${1}" == "FeatureClassification" ]; then

		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "FeatureClassificationStatic" ]; then
		cd "$BASEDIR/Benchmarks/FeatureClassification"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi

	    if [ "${1}" == "FeatureExtraction" ]; then

		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_arm clean
		make --file=makefile_arm XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"

	    fi
	    if [ "${1}" == "FeatureExtractionStatic" ]; then
		cd "$BASEDIR/Benchmarks/FeatureExtraction"
		make --file=makefile_arm_static clean
		make --file=makefile_arm_static XTRA_PARAMS="$ARM_XTRA_PARAMS" XTRA_LIBS="$XTRA_LIBS"
	    fi




	    shift
	done




fi


