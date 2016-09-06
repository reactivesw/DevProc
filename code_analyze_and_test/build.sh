#!/bin/bash
#Program
#automatically build java project by Gradle 
set -e
if [ "$(uname)" == "Darwin" ];then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    EXPORT="export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH""
    if [ -n "$ZSH_VERSION" ];then
        echo "$EXPORT" >> ~/.zshrc
        source ~/.zshrc
    elif [ -n "$BASH_VERSION" ];then
        echo "$EXPORT" >> ~/.bashrc
        source ~/.bashrc 
    fi
    brew install gnu-sed --with-default-names
fi
PROJECT_DIR="../$1"
echo $PROJECT_DIR
#exit 0
if [ ! -e "$PROJECT_DIR" ];then
    echo "$PROJECT_DIR doesn't exist in the same parent directory with code-check tool"
    echo "Usage: build.sh your-project-name"
else
    if [ ! -d "$PROJECT_DIR" ];then
        echo "$PROJECT_DIR is not a Project,Please check it again"
    fi
fi
cp -a config/ $PROJECT_DIR/config/
dirs -c
#dirs -v
pushd $PROJECT_DIR
#pwd
if [ ! -e build.gradle ];then
    echo "Cannot find the build.gradle file,is it a gradle project ?"
    echo "Perhap ,you could run \" gradle init\" to initialise your project to gradle project"
    exit 1
fi
sed -i '1iapply from :\"../code_analyze_and_test/code_analyzer.gradle\"' build.gradle
sed -i '2iapply from :\"../code_analyze_and_test/code_unit_test.gradle\"' build.gradle
gradle clean
gradle wrapper
echo "Start to build Your project by Gradle(gradle wrapper"
sleep 1
./gradlew build -b build.gradle

echo "build complete,clean inserted config "
#tail -n +1 would print the whole file, tail -n +2 everything but the first line, etc. it is much faster than sed
tail -n +3 build.gradle > tmp && mv tmp build.gradle

echo "Everything is done"
rm -rf config/
popd
