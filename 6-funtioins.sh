#!/bin/bash
sample() {
    a=110
    echo HELLO world calling from the function
    echo a in Function = $a
    b=200
}

a=300
sample
echo a in sample programme = $a
echo b in sample programme= $b
