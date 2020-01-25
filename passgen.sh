#!/bin/bash

#DEFAULT VARIABLES

#password length
LENGTH=16

#password variety [1:only digit, 2:only letter, 3:digit+leter, 4:digit+letter+special
VARIETY=4

#number of passwords to be generated
COUNT=1

#Usage info
usage() {
    cat << EOF
    Usage: $0 [--length LENGTH] [--variety VARIETY] [--count COUNT]
    
    Arguments:
    -h, --help      show this help message and exit
    -l, --length    pass in the length of the password(s) to be generated
    -v, --variety   pass in the variety level of the password(s)
                    [1: only digit, 2: only letter, 3: digit+letter, 4: digit+letter+special]
    -c, --count     pass in the number of the password(s) to be generated
    
    Defaults: length:16, variety:4, count:1
EOF
}

if [[ "$#" -eq 0 ]]; then
    usage;
    exit 0;
fi

#Option processing
for arg in "$@"
do
	case $arg in
        -h|--help)
            usage;
            exit 0;;
		-l|--length)
			LENGTH=$2
			shift 2;;
    	-v|--variety)
			VARIETY=$2
			shift 2;;
    	-c|--count)
			COUNT=$2
			shift 2;;
    	-*)
			echo "Invalid argument: $1"
			echo "See --help or -h for valid arguments"
			exit 1;;
    esac
done



###############################
#         ASCII Codes         #
# Special Characters: 33-47   #
# Lower Case: 97-122          #
# Upper Case: 65-90           #
###############################

#Password generation
for i in $(seq $COUNT)
do
    echo $i
    PASS=""
    for j in $(seq $LENGTH)
    do
        case $VARIETY in
            1)
                GENERATED_CHAR_INT_VALUE=$((0 + ( RANDOM % 10 ) ))
                PASS="$PASS$GENERATED_CHAR_INT_VALUE"
                ;;
            2)
                GENERATED_CHAR_INT_VALUE=$((65 + ( RANDOM % 58 ) ))
                while [[ GENERATED_CHAR_INT_VALUE -lt 97 && GENERATED_CHAR_INT_VALUE -gt 90 ]]
                do
                    GENERATED_CHAR_INT_VALUE=$((65 + ( RANDOM % 58 ) ))
                done
                PASS="$PASS$(printf "$(printf '\\x%02x' $GENERATED_CHAR_INT_VALUE)")"
                ;;
            3)
                if [[ $((0 + ( RANDOM % 3 ) )) -eq 0 ]]; then
                    GENERATED_CHAR_INT_VALUE=$((0 + ( RANDOM % 10 ) ))
                    PASS="$PASS$GENERATED_CHAR_INT_VALUE"
                else
                    GENERATED_CHAR_INT_VALUE=$((65 + ( RANDOM % 58 ) ))
                    while [[ GENERATED_CHAR_INT_VALUE -lt 97 && GENERATED_CHAR_INT_VALUE -gt 90 ]]
                    do
                        GENERATED_CHAR_INT_VALUE=$((65 + ( RANDOM % 58 ) ))
                    done
                    PASS="$PASS$(printf "$(printf '\\x%02x' $GENERATED_CHAR_INT_VALUE)")"
                fi
                ;;
            4)
                SELECT=$((0 + ( RANDOM % 5 ) ))
                if [[ SELECT -eq 0 ]]; then
                    GENERATED_CHAR_INT_VALUE=$((0 + ( RANDOM % 10 ) ))
                    PASS="$PASS$GENERATED_CHAR_INT_VALUE"
                elif [[ SELECT -eq 1 ]]; then
                    GENERATED_CHAR_INT_VALUE=$((33 + ( RANDOM % 15 ) ))
                    PASS="$PASS$(printf "$(printf '\\x%02x' $GENERATED_CHAR_INT_VALUE)")"
                else
                    GENERATED_CHAR_INT_VALUE=$((65 + ( RANDOM % 58 ) ))
                    while [[ GENERATED_CHAR_INT_VALUE -lt 97 && GENERATED_CHAR_INT_VALUE -gt 90 ]]
                    do
                        GENERATED_CHAR_INT_VALUE=$((65 + ( RANDOM % 58 ) ))
                    done
                    PASS="$PASS$(printf "$(printf '\\x%02x' $GENERATED_CHAR_INT_VALUE)")"
                fi
                ;;
        esac
    done
    PASSES=( "${PASSES[@]}" "$PASS" )
done

#Print passwords
echo ${PASSES[@]}