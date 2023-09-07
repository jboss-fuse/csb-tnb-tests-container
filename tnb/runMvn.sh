#!/bin/bash
echo executing as $(whoami)
cp -Rf /artifacts-tnb/* /deployments/.m2/repository/
grep -lrnw /deployments/.m2/repository/ -e '\\u0000' | xargs rm
echo "----------"
env
echo "----------"

mvn -s $MVN_SETTINGS_PATH clean install -P$MVN_PROFILES $MVN_ARGS -DskipTests

tail -f /dev/null