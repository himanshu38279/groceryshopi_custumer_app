#!/bin/bash 
# set -e
# ---------------START:  change package name -----------------------
new_android_packagename=$1
if [ -z $new_android_packagename ] ; then
    echo "Please enter new package name"
    exit 1
fi
old_android_packagename=`xsh -q -P ./android/app/src/main/AndroidManifest.xml "ls //manifest/@package" | awk -F"'" '{print $2}'`
echo "Old package name is $old_android_packagename"

OLD_ANDROID_PACKAGE_NAME_ESCAPED="${old_android_packagename//./\.}"
NEW_ANDROID_PACKAGE_NAME_ESCAPED="${new_android_packagename//./\.}"
LC_ALL=C find "android/app" -type f \( -iname \*.gradle -o -iname \*.xml -o -iname \*.json -o -iname \*.java -o -iname \*.kt \) -exec sed -i "s/$OLD_ANDROID_PACKAGE_NAME_ESCAPED/$NEW_ANDROID_PACKAGE_NAME_ESCAPED/g" {} +


# ---------------END:  move file MainActivity.java-----------------------
