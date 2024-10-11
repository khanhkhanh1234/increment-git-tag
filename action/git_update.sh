#!/bin/bash

VERSION=""

#get parameter
while getopts v: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
    esac
done

#get highest tag number, and add v if doesn't exist
git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`

if [[ $CURRENT_VERSION == "" ]]
then
    CURRENT_VERSION="v0.1.0"
fi
echo "Current Version: $CURRENT_VERSION"

#replace . with space so can split into an array
CURRENT_VERSION_PARTS=(${CURRENT_VERSION//./ })

#get number parts
VNUM1=${CURRENT_VERSION_PARTS[0]}
VNUM2=${CURRENT_VERSION_PARTS[1]}
VNUM3=${CURRENT_VERSION_PARTS[2]}

if [[ $VERSION == 'major' ]]
then
    VNUM1=v$((VNUM1+1))
elif [[ $VERSION == 'minor' ]]
then
    VNUM2=$((VNUM2+1))
elif [[ $VERSION == 'patch' ]]
then
    VNUM3=$((VNUM3+1))
else
    echo "Invalid version type"
    exit 1
fi

#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"
echo "Updating to Version: $NEW_TAG"

# Get the current commit hash for the new tag

GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GCM 2>/dev/null`

# Only tag if no tag already 
if [ -z "$NEEDS_TAG" ]; then
    git tag $NEW_TAG
    echo "Tagged with $NEW_TAG"
    git push --tags
    git push
else
    echo "Already a tag on this commit"
fi

echo ::set-output name=git_tag::$NEW_TAG

exit 0