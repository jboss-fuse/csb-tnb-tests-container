## note

Maven downloaded from https://archive.apache.org/dist/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz

### env credentials to inject into container
All the following credential needs to be filled as environment variables into the container during the run execution used into the settings.xml file, otherwise it is possible to mount a specific settings.xml using the variable MVN_SETTINGS_PATH.

ex:
podman .... -v /path/to/local/settings.xml:/root/custom.settings.xml:ro -e  MVN_SETTINGS_PATH=/root/custom.settings.xml....

## build

podman build --no-cache --build-arg BUILD_JDK=[11,17] --build-arg GIT_BRANCH=[git branch] -t tnb-tests:[tag] .

- BUILD_JDK=[11,17]
- GIT_BRANCH=[name of the git branch]

ex:

podman build --no-cache --build-arg BUILD_JDK=17 --build-arg GIT_BRANCH=main -t tnb-tests:jdk17 .

it generates image:
localhost/tnb:jdk17

## run

podman run --rm --privileged --userns host  -v ~/.m2/repository:/deployments/.m2/repository:Z -e MVN_PROFILES=[mvn profiles]  [name:tag of the built image]

- MVN_PROFILES=[list of the mvn profiles]
- MVN_ARGS=[maven args, -B is already there]

ex:

podman run --rm --privileged --userns host -e MVN_SETTINGS_PATH=/deployments/custom.settings.xml -v ~/.m2/settings.xml:/deployments/custom.settings.xml:ro -v ~/.m2/repository:/deployments/.m2/repository:Z -e MVN_PROFILES=springboot localhost/tnb-tests:jdk17
