#!/usr/bin/env bash

# usage function
function usage()
{
   cat << HEREDOC

   Usage: scan-net --host HOST --port PORT [--verbose]

   optional arguments:
     -h, --help           show this help message and exit
     --host HOST          host to scan
     --port PORT          port to scan
     --verbose            increase verbosity of this bash script

HEREDOC
}

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --host)
      HOST="$2"
      shift # past argument
      shift # past value
      ;;
    --port)
      PORT="$2"
      shift # past argument
      shift # past value
      ;;
    --verbose)
      VERBOSE=YES
      shift # past argument
      ;;
    -h|--help)
      usage
      exit 0 # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

if [ -z "${HOST}" ]; then
    echo "Cannot continue: HOST variable env is not defined"
    exit 1
fi

if [ -z "${PORT}" ]; then
    echo "Cannot continue: PORT variable env is not defined"
    exit 1
fi

nc -v -z -w 1 ${HOST} ${PORT} &> /dev/null
if [[ $? == 0 ]]
then
    # Host/port is reached
    echo "Service is online!"
    exit 0
else
    # Host/port is unreachable
    echo "Service is offline!"
    exit 1
fi
