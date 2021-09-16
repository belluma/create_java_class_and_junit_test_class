#!/bin/bash
arguments=("$@")

for((i=0;i<${#arguments[@]};i++));do
    arg=${arguments[i]}
    if [ $arg = "--model" ];then
        if [ $((i+2)) -lt ${#arguments[@]} ];then
            echo "too many arguments for --model"
            exit
        fi
        if [ $((i+1)) == ${#arguments[@]} ];then
            echo "no argument given for --model"
            exit
        fi
        model=${arguments[$((i+1))]}
    fi
done

class_file(){
    
    if [[ -n ${model+1} ]];then
        [ ! -d "src/main/java/$model" ] && mkdir -p src/main/java/$model
        if [[ -f "src/main/java/$model/$1.java" ]]; then
            echo "$1.java already exists in $model"
            return;
        fi
        echo "package $model;

        public class $1{
        }" >> src/main/java/$model/$1.java
    else
        if [[ -f "src/main/java/$1.java" ]]; then
            echo "$1.java already exists"
            return;
        fi
        echo "public class $1{
        }" >> src/main/java/$1.java
    fi
}

test_file(){
    if [[ -n ${model+1} ]];then
        [ ! -d "src/test/java/$model" ] && mkdir -p src/test/java/$model
        if [[ -f "src/test/java/$model/$1.java" ]]; then
            return;
        fi
        echo "package $model;

import static org.junit.jupiter.api.Assertions.*;

        public class $1Test{
        }" >> src/test/java/$model/$1.java
    else
        if [[ -f "src/test/java/$1.java" ]]; 
         echo "$1Test.java already exists"
            return;
        fi
        echo "import static org.junit.jupiter.api.Assertions.*;

        public class $1{
        }" >> src/test/java/$1.java
    fi
}



if [ -f pom.xml ];then
    for ((i = 0 ; i < ${#arguments[@]} ; i++)) ;do
        echo ${arguments[$i]}
        [[ ${arguments[$i]:0:1} == - ]] && break
        class_file ${arguments[$i]}
        test_file ${arguments[$i]}
    done
else
    echo "no pom.xml found. are you in the project root?"
    
fi


