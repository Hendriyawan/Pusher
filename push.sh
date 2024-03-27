#! /bin/bash
#writen by hendriyawan

GITHUB_USERNAME="$HOME/.github_username"
GITHUB_KEY="$HOME/.github_key"
#check configuration for github username
#usage ~/.push.sh --setup for configuration
function checkConfiguration(){


    if [ ! -f $GITHUB_USERNAME ]; then
        echo "please setup configuration before usage the feature"
        echo ""
        echo "Usage : .$0 --setup"
        echo ""
        exit 1
    elif [ ! -f $GITHUB_KEY ]; then
        echo "please setup configuration before usage the feature"
        echo ""
        echo "Usage : .$0 --setup"
        echo ""
        exit 1
    fi
}

function setupConfiguration(){
    echo -n "enter github username : "
    read username
    echo -n "enter the KEY : "
    read key

    if [ -z $username ]; then
        echo "please enter github username !"
        exit 1
        elif [ -z $key ]; then
        echo "please enter the key"
        exit 1
    else
        echo "$username" > $GITHUB_USERNAME
        echo "$key" > $GITHUB_KEY
        if [ $? -eq 0 ]; then
            echo "Configuration complete !"
            exit 0
        else
            echo "Configuration failed !"
            exit 1
        fi
    fi
}
# check if a URL is provided as a command-line argument
option=$1
repository_url_or_name=$2

if [ -z $option ]; then
    echo "Usage : .$0 <option> "
    echo ""
    echo ""
    echo "Options : "
    echo "--setup                     : set configuration !"
    echo "--push <REPOSITORY NAME>    : push to repository"
    echo "--clone <REPOSITORY URL>    : clone the private repository"
    echo ""
    echo ""
else
    if [ $option == "--setup" ]; then
        setupConfiguration
        elif [ $option == "--push" ]; then
        checkConfiguration
        #check the active directory cintaining the .git folder
        if [ -z $repository_url_or_name ]; then
            echo "usage : .$0 --push <REPOSITORY NAME>"
            exit 1
        else
            if [ -d .git ]; then
                url_repository="https://github.com/$(cat $GITHUB_USERNAME)/$repository_url_or_name"
                insert_key="$(cat $GITHUB_KEY)@"
                modified_url=$(echo "$url_repository" | sed "s|github.com|${insert_key}github.com|g")
                #push to repository
                git push $modified_url
            else
                echo "active directory not containing the .git folder"
                exit 1
            fi
        fi

        elif [ $option == "--clone" ]; then
        checkConfiguration
        if [ -z $repository_url_or_name ]; then
            echo "usage : .$0 --clone <REPOSITORY URL>"
            exit 1
        else
            insert_key="$(cat ~/.github_key)@"
            modified_url=$(echo "$repository_url_or_name" | sed "s|github.com|${insert_key}github.com|g")
            #clone  private repo from url
            git clone $modified_url
        fi
    fi
fi
