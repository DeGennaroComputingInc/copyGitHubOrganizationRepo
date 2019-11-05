#!/bin/bash -e
#HR: Gratuitiously lifted ex33.sh from http://www.tldp.org/LDP/abs/html/abs-guide.html
#Variables
API_PREFIX=/api/v3
ORG_PREFIX=/orgs
ORG_SUFFIX=/repos
NO_ARGS=0
REQUIRED_ARGS=8
ALL_ARGS=10
E_OPTERROR=85

if [ $# -eq "$NO_ARGS" ] || [ $# -ne "$REQUIRED_ARGS" ] && [ $# -ne "$ALL_ARGS" ]     # Script invoked with no command-line args or not enough?
then
    echo "Usage: `basename $0` -e endpoint -o organiztion_name -r repo_name -u user_name (-h human_name)"
    echo "This script should be run in the directory where you want your code to live"
    exit $E_OPTERROR          # Exit and explain usage.
    # Usage: scriptname -options
    # Note: dash (-) necessary
fi

while getopts "e:r:o:u:h:" Option
do
    case $Option in
        e     ) ENDPOINT=$OPTARG
                echo "Your organizations endpoint (in the form of https://your.orgs.github.webinterface.org): option -e-"
                echo "with argument \"$OPTARG\"   [OPTIND=${OPTIND}]";;
        r     ) REPO=$OPTARG
                echo "The repo name to be cloned from (typically provide by instructor): option -r-"
                echo "with argument \"$OPTARG\"   [OPTIND=${OPTIND}]";;
        o     ) ORG=$OPTARG
                echo "The organization the repo to be cloned from and new repo will be in: option -o-"
                echo "with argument \"$OPTARG\"   [OPTIND=${OPTIND}]";;
        u     ) USER=$OPTARG
                echo "The username you will authenticate with to the organization: option -u-"
                echo "with argument \"$OPTARG\"   [OPTIND=${OPTIND}]";;
        h     ) HUMAN=' for '$OPTARG
                echo "Your human name to be written into the project description (optional): option -h-"
                echo "with argument \"$OPTARG\"   [OPTIND=${OPTIND}]";;
        *     ) echo "Unimplemented option chosen."
                echo "Usage: `basename $0` -e endpoint -o organiztion_name -r repo_name -u user_name (-h human_name)"
                echo "This script should be run in the directory where you want your code to live"
                exit $E_OPTERROR          # Exit and explain usage.
;;   # Default.
    esac
done

shift $(($OPTIND - 1))
CREATE_REPO_API_URL=$ENDPOINT$API_PREFIX${ORG_PREFIX}/${ORG}$ORG_SUFFIX
GIT_CLONE_URL=$ENDPOINT/${ORG}/$REPO'_'$USER.git
GIT_REMOTE_ADD_URL=$ENDPOINT/${ORG}/$REPO
curl -u "$USER" -d '{"name": "'$REPO'_'$USER'", "description": "A repository to hold the student submission of '$REPO"${HUMAN[@]:-""}"'", "private":"true", "auto_init":"true"}' -H 'Content-Type: application/json' $CREATE_REPO_API_URL
git clone $GIT_CLONE_URL
cd $REPO'_'$USER
git remote add -f $REPO $GIT_REMOTE_ADD_URL
git merge $REPO/master --allow-unrelated-histories -m 'Merging from '$REPO' into '$REPO'_'$USER
REMOTE_COUNT=$(git remote --verbose | grep "^$REPO.*$GIT_REMOTE_ADD_URL.*$" | wc -l)
if [[ "$REMOTE_COUNT" -gt 0 ]]
then
    echo "Remote count at "$REMOTE_COUNT
    echo "Removing remote by name"
    git remote remove $REPO
fi
#Sanity check
REMOTE_COUNT=$(git remote --verbose | grep "^$REPO.*$GIT_REMOTE_ADD_URL.*$" | wc -l)
if [[ $REMOTE_COUNT -eq 0 ]]
then
    echo "Remote count at "$REMOTE_COUNT
    echo "Safe to push"
    git push $GIT_CLONE_URL 
    echo "Pushed your local repo to $GIT_CLONE_URL, should contain code from $GIT_REMOTE_ADD_URL"
    exit $?
fi
echo "Remote count at "$REMOTE_COUNT
echo "Not safe to push, you should confirm there are no remotes for $GIT_REMOTE_ADD_URL"
exit $?
