#!/bin/please-only-source-sh

scriptdir=`dirname $0`
cd ${scriptdir}
scriptdir=`pwd`


PLAT1=`uname -s`

if  [ "X${PLAT1}" == "XDarwin" ]
then
    PLAT=Darwin
else
    PLAT=`uname -s`
fi

export PLAT

### break on first failure  
set -e

GCFLAGS=""
LDFLAGS="-ldflags='-w -s'"

if [ ! -z "$DEV_MODE" ]; then
  LDFLAGS=""
  GCFLAGS="-gcflags='-N -l'"
fi

## arg1 - src directory
do_go_build()
{
    export CGO_ENABLED=0
    
    srcdir=${1}
    cd ${srcdir}
    exename=`basename ${srcdir}`

    echo
    echo "======== do_gobuild: ${exename} =========="
    echo

    if [ "$2" == "linux" ]; then
       cmd="env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $LDFLAGS $GCFLAGS"
    else
       cmd="go build $LDFLAGS $GCFLAGS"
    fi 

    echo $cmd
    eval $cmd
    echo ""


    if [ ! -z "$DEV_MODE" ] ; then
      echo -e "\t\t ======== Skipping upx step (to keep debug symbols)  ========"
    elif [ -x "$(command -v upx)" ]; then
       upx ${exename} 
    else
        echo -e "\t\t ===== Warning - upx is not present -- executable would be larger than desired - which is FINE if DEV , not ok if for a PRODUCTION build ==="
    fi
    echo
    ls -l ${exename}

    mkdir -p ${scriptdir}/bin
    echo "THIS===>" ${scriptdir}/${srcdir}/${exename}
    mv ${scriptdir}/${srcdir}/${exename} ${scriptdir}/bin/.
    chmod 755 ${scriptdir}/bin/${exename}
    cd ${scriptdir}
}

