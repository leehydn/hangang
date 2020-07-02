#!/bin/bash

if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
	if [[ "$(git remote get-url origin 2>/dev/null)" = "" ]]; then
		while true; do
			read -p 'enter the remote address: ' ipt
			git ls-remote "$ipt" > /dev/null 2>&1
			if [ "$?" -ne 0 ]; then
				echo "error: unable to read from '$ipt'"
				exit 1;
			else
				git remote add origin $ipt
				break
			fi
		done
	else
  	git add . && git commit -m "automatic commit by gitgo: `date +"%Y-%m-%d %T"`" && git push --set-upstream origin master
	fi

else
	while true; do
		read -p "NOT a git repository. initialize? " ipt
		if [[ $ipt = 'y' ]] || [[ $ipt = 'Y' ]]; then
			git init
			while true; do
				read -p 'enter the remote address: ' ipt
				git ls-remote "$ipt" > /dev/null 2>&1
				if [ "$?" -ne 0 ]; then
					echo "error: unable to read from '$ipt'"
					exit 1;
				else
					git remote add origin $ipt
					break
				fi
			done
		elif [[ $ipt = 'n' ]] || [[ $ipt = 'N' ]]; then
			echo "operation cancelled"
			break
		else
			echo "incorrect value(y/n)"
			continue
		fi
	done
fi
