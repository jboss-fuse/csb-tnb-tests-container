#!/bin/bash
echo executing as $(whoami)
cp -Rf /artifacts/* /deployments/.m2/repository/
grep -lrnw /deployments/.m2/repository/ -e '\\u0000' | xargs rm
if [ "x$NAMESPACE_NAME" == "x" ]; then
    UUID=$(cat /proc/sys/kernel/random/uuid)
    OPENSHIFT_NAMESPACE=$NAMESPACE_PREFIX-$(echo $UUID | tail -c 5)
else
    OPENSHIFT_NAMESPACE=$NAMESPACE_NAME
fi
export OPENSHIFT_NAMESPACE
echo $OPENSHIFT_NAMESPACE > /tmp/namespace
echo "----------"
env
echo "----------"
if [ "x$TEST_EXPR" == "x" ]; then
    mvn clean verify -ntp -fn -s $MVN_SETTINGS_PATH -P$MVN_PROFILES -B $MVN_ARGS  -Dopenshift.namespace=$OPENSHIFT_NAMESPACE --projects org.jboss.fuse.tnb.tests.springboot:examples --also-make --also-make-dependents
else
    mvn clean verify -ntp -fn -s $MVN_SETTINGS_PATH -P$MVN_PROFILES -B $MVN_ARGS -Dit.test=$TEST_EXPR -Dopenshift.namespace=$OPENSHIFT_NAMESPACE --projects org.jboss.fuse.tnb.tests.springboot:examples --also-make --also-make-dependents
fi

if [ "x$FAILSAFE_REPORTS_DEST_FOLDER" == "x" ]; then
    echo "filesafe reports are not copied, please fill FAILSAFE_REPORTS_DEST_FOLDER env variable"
else
    DST_FOLDER=$FAILSAFE_REPORTS_DEST_FOLDER/$OPENSHIFT_NAMESPACE
    echo "copying failsafe reports $FAILSAFE_REPORTS_DEST_FILES from $FAILSAFE_REPORTS_FOLDER to $DST_FOLDER"
    [ ! -d $DST_FOLDER ] && mkdir -p $DST_FOLDER
    cp -ra $FAILSAFE_REPORTS_FOLDER/$FAILSAFE_REPORTS_DEST_FILES $DST_FOLDER/ 2>/dev/null || :
fi
tail -f /dev/null
