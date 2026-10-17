#!/bin/bash

compilers=(gcc-4.8 gcc-5 gcc-6 gcc-7 gcc-8 clang-5.0 clang-6.0)
optimization_levels=(-O0 -O1 -O2 -O3)
options=(-fPIC)

function setup_compile_commands() {
  compile_commands=()
  count=0
  for cc in ${compilers[@]}; do
	for level in ${optimization_levels[@]}; do
	  for opt in ${options[@]}; do
		compile_commands=(${compile_commands[@]} "$cc,$level,$opt")
	  done
	  compile_commands=(${compile_commands[@]} "$cc,$level")
	done
  done
}

# $1:command $2:tag
function runwith() {(
  cc=`echo $1 | sed 's/,/ /g'`
  prefix=$2.$1
  # echo Runwith $1 $2 $3
  $cc -x c -w $tag.c -o $prefix -I /usr/local/include/csmith-2.4.0
  if [ $? -ne 0 ]; then
	echo "Compile With $cc failed" &> $prefix.out
	exit
  fi

  timeout 60s ./$prefix &> $prefix.out
  code=$?
  if [ $code -ne 0 ]; then
	echo "Exit Code $code.$RANDOM" > $prefix.out
  fi
)}

function diff-multiple() {(
  curr=$1
  shift
  while [ -n "$1" ]; do
	if ! diff $curr $1; then
	  return 1
	fi
	shift
  done
  return 0
)}

function main() {
  setup_compile_commands

  ulimit -s 102400

  i=0
  seed=23
  while true; do
	tag=$i.`date +{%F}{%H:%M:%S}`
	echo "Generated $tag.c with seed $seed"
	csmith --seed $seed > $tag.c

	seed=$(( $seed+1 ))

	outs=
	binarys=

	for cc in ${compile_commands[@]}; do
	  runwith $cc $tag
	  printf "Compile With [%-20s], run: " $cc
	  cat $tag.$cc.out
	  outs="$outs $tag.$cc.out"
	  binarys="$binarys $tag.$cc"
	done

	if ! diff-multiple $outs; then
	  # no difference
	  i=$(( $i+1 ))
	else
	  rm -f $tag.c $binarys $outs
	fi
  done
}

main
