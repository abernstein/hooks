#!/bin/bash
#
# Quality Assurance is established at certain hooks in the SCM
# Pre-requistes:
#   git
#   A set of hooks located in an includes/ folder

# Determine Location of the Shared Hooks Repo
echo -e "Is this the location of the hooks, `pwd` [ Y | N ]:"
read toggle
if [ "${toggle}" == "Y" ]; then
  PATH_TO_HOOKS=`pwd`
else
  echo -e "What is the location?"
  read PATH_TO_HOOKS
fi
hooks=$(ls $PATH_TO_HOOKS/includes)
hook_types=$(ls $PATH_TO_HOOKS/includes | cut -d'-' -f1)
echo -e "\nWe have the following hooks available:\n${hook_types[@]}"

# Determine repository to install hooks in
echo -e "\nSCM project directory [/home/myname/repos/myproject]:"
read PATH_TO_PROJECT

if [ -d $PATH_TO_PROJECT ]; then
  filetypes=$(find $PATH_TO_PROJECT -type f -name "*.*" | awk -F. '{print $NF}' | sort -u)
  echo -e "The project has these filetypes:\n${filetypes[@]}"

  # Install Hooks
  echo -e "\nList desired hooks separated by spaces [ all | php js puppet ]:"
  read desired_hooks
  declare -a apply_hooks=($desired_hooks);

  if [ $apply_hooks ]; then
    for hook in $apply_hooks; do
      hook_dir="${PATH_TO_PROJECT}/.git/hooks"
      append=`find "${PATH_TO_HOOKS}/includes" -maxdepth 2 -iname "*${hook}*.hook"`
      file=`basename $append`

      if [ -w $append ]; then
        echo -e "\nbash $append" >> $hook_dir/pre-commit
        echo "chmod +x $PATH_TO_HOOKS/pre-commit"
      fi;

      if [ -e $PATH_TO_PROJECT/.gitmodules ]; then
        echo -e "\nWould you like us to apply hooks to the submodules too [Y/N]:"
        read install_submodules
        if [ "${install_submodules}" == "Y" ]; then
          for module in $PATH_TO_PROJECT/*/;
            do echo "ln -s <path_to_shared>/pre-commit ${module}hooks/pre-commit";
          done;
        fi;
      fi;
    done;
  fi;
else
  echo "Sorry this project doesn't seem to exist at $PATH_TO_PROJECT"
fi
