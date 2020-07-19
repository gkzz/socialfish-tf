#!/bin/bash

# Ref
# AWS CLIで、最新のAMIの情報を取得する
# https://qiita.com/charon/items/18d9d582ea6c8960f274

function help {
  cat <<- EOF
    overview：get ami id with aws-cli
    usage：bash sh/setup.sh [-h|-l|-u|
    option：
      -h  this message
      -l ->> get ami id of amazon linux2
      -u ->> get ami id of ubuntu18.04
EOF
    exit 1

}


while getopts ":lu" OPT;

do
    case ${OPT} in
        l)
          OS_FLAG=1;
            ;;
        u)
          OS_FLAG=0;
            ;;
        \?)
          help
            ;;
    esac
done

shift $((OPTIND - 1))


if [ "$OS_FLAG" -eq 1  ]; then
    echo "get ami id of amazon linux2"
    aws ec2 describe-images \
        --region ap-northeast-1 \
        --query 'reverse(sort_by(Images, &CreationDate))[:1]' \
        --owners amazon \
        --filters 'Name=name,Values=amzn2-ami-hvm-2.0.*-x86_64-gp2' \
        --output table
elif [ "$OS_FLAG" -eq 0 ]; then
    echo "get ami id of ubuntu18.04"
    aws ec2 describe-images \
        --region ap-northeast-1 \
        --query 'reverse(sort_by(Images, &CreationDate))[:1]' \
        --owners 099720109477 \
        --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*' \
        --output table
else
    echo "option is unexpected."
    help
fi
