#!/bin/sh
#
# Purpose: Create a collection to be managed by zookeeper.  
#
# IMPORTANT:
#	A collection configuration directory MUST BE setup prior to executing this script
#	See search_config_copy.sh
#
#
DTSTAMP2=$(date +"%x %X")
echo SCRIPT START - ${DTSTAMP2}

#arguments
COLLECTION=$1
SHARDS=$2

#check for arguments
dummy=${COLLECTION:?"collection name required .. prompt>$0 [collection name] [optional: # of shards]"}

#variables
COLL_CONFIGS=../solr_configs/${COLLECTION}

# was shard number passed in? 
if [ ! ${SHARDS} ]
then
#   If not then default to 1
    SHARDS=1
fi


#verifications
echo "INFO: Verifying collection name...( $COLLECTION )"
COLLECTION_LIST=`solrctl collection --list | grep $COLLECTION`

if [ ! "$COLLECTION_LIST" == "" ]
then
    echo "ERROR: Collection Name - name already exists: $COLLECTION"
    echo "$COLLECTION_LIST"
    exit 1
fi
echo "INFO: Verifying collection name...( $COLLECTION ) - ok to proceed"


echo "INFO: Verifying collection configuration...( $COLL_CONFIGS )"
if [ ! -d "$COLL_CONFIGS" ]
then
    echo "ERROR: Collection Config - configuration directory does NOT exist. $COLL_CONFIGS"
    exit 1
fi

if [ ! -d "$COLL_CONFIGS/conf" ]
then
    echo "ERROR: Collection Config - configuration ./conf directory does NOT exist.  $COLL_CONFIGS/conf" 
    exit 1
fi
echo "INFO: Verifying collection configuration...( $COLL_CONFIGS ) - ok to proceed"

echo "INFO: executing > solrctl instancedir --create $COLLECTION $COLL_CONFIGS"
echo "INFO: executing > solrctl collection --create $COLLECTION -s $SHARDS -r 1 -m 1"
#create collection
solrctl instancedir --create $COLLECTION $COLL_CONFIGS
solrctl collection --create $COLLECTION -s $SHARDS -r 1 -m 1

echo "INFO: collection list for collection:"
solrctl collection --list | grep $COLLECTION