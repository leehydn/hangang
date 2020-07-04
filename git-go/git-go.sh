#!/bin/bash
NAME="gitgo"
INGIT="false"
INREMOTE="false"
READY="false"
HASARG="false"

usage() 
{
cat << EOF
usage [<options>] [-r <remoterepo>]
$NAME: Automatically writes the commit message and push, based on the timestamp.

OPTIONS:
	-c, --commit Only commits the change
	-p, --push Commit and push
	-b, --branch Change the branch
	-h, --help Help
EOF
}

checkInGit()
{
echo ">> INIT"
echo "checking git init..."
if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ]]; then
	while true; do
		read -p "error: NOT a git repository. initialize? " inpt
		if [[ $inpt = 'y' ]] || [[ $inpt = 'Y' ]]; then
			git init
			while true; do
				read -p "enter the remote address: " ixpt
				git ls-remote "$ixpt" > /dev/null 2>&1
				if [ "$?" -ne 0 ]; then
					echo >&2 "fatal: unable to read from '$ixpt'"
					exit 1;
				else
					git remote add origin $inpt
					INGIT="true"
					break;
				fi
			done
		elif [[ $inpt = 'n' ]] || [[ $inpt = 'N' ]]; then
			echo >&2 "fatal: operation cancelled"
			exit 1;
		else
			echo "error: incorrect value(y/n)"
			continue
		fi
	done
else
	INGIT="true"
fi
}

checkAvailRemote()
{
echo "checking git remote..."
if [[ "$(git ls-remote --heads origin master 2> /dev/null | wc -l)" = "0" ]]; then
	while true; do
		read -p "enter the remote address: " ipt
		git ls-remote "$ipt" > /dev/null 2>&1
		if [[ "$?" -ne 0 ]]; then
			echo >&2 "fatal: unable to read from $ipt"
			exit 1;
		else
			git remote add origin $ipt
			INREMOTE="true"
			break;
		fi
	done
else
	INREMOTE="true"
fi
}

gitcommit()
{
echo ">> COMMITTING "
git add . 
echo "automatic commit by $NAME: `date +"%Y-%m-%d %T"`"
git commit -m "automatic commit by $NAME: `date +"%Y-%m-%d %T"`"
}

gitpush()
{
echo ">> PUSH"
if [[ "$1" =~ ^\-.+ ]] || [[ ! "$1" ]]; then
	echo "pushing to $(git branch --show-current)..."
	git push origin $(git branch --show-current)
else
	HASARG="true"
	echo "pushing to $1"
	git push origin "$1"
fi
}

initd()
{
if [[ "$INGIT" = "false" ]]; then
	checkInGit
fi
echo "INGIT passed"
if [[ "$INREMOTE" = "false" ]]; then
	checkAvailRemote
fi
echo "RMOTE passed"

if [[ "$INGIT" = "true" ]] && [[ "$INREMOTE" = "true" ]]; then
	READY="true"
fi

}

# MAIN
if [[ ! $@ =~ ^\-.+ ]]; then
	while [[ "$READY" = "false" ]]; do
	initd
	done
	gitcommit
	gitpush
else
	while true; do
		HASARG="false"
		case $1 in
			-h|--help)
				usage
				exit 0 ;;
			-c|--commit)
				initd
				gitcommit
				shift ;;
			-p|--push)
				initd
				gitcommit
				gitpush
				if [[ HASARG = "true" ]]; then
					shift 2
				else
					shift
				fi ;;
			-b|--branch)
				echo ">> BRANCH CHANGE"
				git checkout "$2"
				shift 2;;
			--)
				shift
				break ;;

			*)
				if [[ "$#" < 1 ]]; then
					exit 0
				fi
				echo >&2 "fatal: wrong option: $1"
				exit 1 ;;
		esac
	done
fi