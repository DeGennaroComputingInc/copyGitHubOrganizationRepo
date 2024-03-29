# copyGitHubOrganizationRepo
A public repository for a bash script to copy the contents of a public repo within a GitHub organization to a private repo
# Description 
During my coursework in the [OMSCS](omscs.gatech.edu), forking a repository in a GitHub organization was disabled while having one's own private repository with the code from a public repository was useful for starting the project.  I thought a bash script would be handy for not only creating my own personal private repo to start work on but also for other students to use.  If you every found yourself in the same situation while dealing with a GitHub organization (although I imagine the API calls are similar for public Github) in a *nix/MacOSX environment, than this script is for you.  I tested it personally on a Mac OSX, no warranty given or implied but pull requests are always welcome.
# Usage
```
Usage: copy_repo.sh -e endpoint #Your organization's endpoint (in the form of https://your.orgs.github.webinterface.org) 
                    -o organiztion_name #The organization the repo to be cloned from and new repo will be in 
                    -r repo_name #The repo name to be cloned from 
                    -u user_name #The username you will authenticate with to the organization
                    (-h human_name) #Your human name to be written into the project description (optional)
This script should be run in a directory where the directories for the two repos (public one cloned from, private one created) will be
```
# Resources
- (https://medium.com/altcampus/how-to-merge-two-or-multiple-git-repositories-into-one-9f8a5209913f)
- (https://developer.github.com/enterprise/2.18/v3/repos/)
- (https://www.tldp.org/LDP/abs/html/internal.html)
- (https://github.com/github/hub) <== This was an interesting project and could be possible to leverage this for a more portable solution; however, my cursory reading of the README made it seem like there wasn't a solution that didn't involve some scripting.
