#!/bin/bash


function func_rm () {
    rm -f $1
}

for x in *.log; do
    func_rm $x
done

for x in **/*.log; do
    func_rm $x;
done