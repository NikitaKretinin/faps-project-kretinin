#!/bin/bash

# test_script

source_text="" 		#  source text/file
source_del=false	#  'delete source file' flag
recipient_del=false 	#  'delete recipient file' flag
data_del=false		#  'wipe data in slack space' flag
show_info=false 	#  'show info about recipient file slack' flag

while getopts :s:r:nmdih option
do
        case "${option}"
                in
                s ) source_text=${OPTARG};;
                r ) recipient_file=${OPTARG};;
		n ) source_del=true;;
		m ) recipient_del=true;;
		d ) data_del=true;;
		i ) show_info=true;; 
		h ) 
			echo "HELP
(c)Mykyta Kretinin, FIIT STU, 21.04.2021

DESCRIPTION
	Script for manipulations with file's slack space using bmap
	bmap: https://github.com/CameronLonsdale/bmap
SYNTAX
	$0 [-s \"<source file/text>\"] [-r \"<recipient file>\"] [-h] [-n] [-m] [-d] [-i]
ARGUMENTS
	-s <text/file address in \"\"> - source file/text to be written into slack space [optional]
	-r <file address> - recipient file [required, except with -h]
	-h - this help page
	-n - source file delete [optional]
	-m - recipient file delete [optional]
	-d - wipe data inside slack space of recipient file [optional]
	-i - show info about file's slack space, including slack space's content [optional]" | less
			exit 0
			;;
                \? ) echo "No -$OPTARG argument found" 1>&2
			exit 1
			;;
        esac
done

if [ -e $recipient_file 2>/dev/null ]
then
	if [ $data_del = true ]
	then
		sudo bmap --mode wipe $recipient_file >/dev/null
		echo "Slack space of file $recipient_file has been wiped"
	elif ! [ -z "$source_text" ]
	then
		if [ -r $source_text 2>/dev/null ]
        		then
                		echo "Writing content of the file $source_text to slack space..."
				cat "$source_text" | sudo bmap --mode putslack $recipient_file
				echo "Your text has been written to slack space of $recipient_file file."
			else
				echo "Writing text to slack space..."
				echo "$source_text" | sudo bmap --mode putslack $recipient_file 
				echo "Your text has been written to slack space of $recipient_file file."
			fi
	fi
else
	echo "$recipient_file file not found"
	exit 1
fi

if [ $source_del = true ]
then
	if ! [ -z "$source_text" ] && [ -f $source_text 2>/dev/null ]
	then
		rm $source_text
		echo "source file '$source_text' has been deleted"
	else
		echo "'$source_text' file not found"
	fi
fi

if [ $recipient_del = true ]
then
	rm $recipient_file
	echo "recipient file '$recipient_file' has been deleted"
fi

if [ $show_info = true ]
        then
                sudo bmap --mode slack "$recipient_file"
	fi


exit 0
