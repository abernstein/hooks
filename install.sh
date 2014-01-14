#!/bin/bash
#
# Quality Assurance is established at certain hooks in the SCM
# Pre-requistes:
#   git
#   A set of hooks located in an includes/ folder
#
# Determine Location of the Shared Hooks Repo
echo -e "Is this the location of the hooks, `pwd` [ Y | N ]:"
read toggle

if [ `echo ${toggle} | tr '[:lower:]' '[:upper:]'` == "Y" ]; then
  PATH_TO_HOOKS=`pwd`
else
  echo -e "What is the location?"
  read PATH_TO_HOOKS
fi
hooks=$(ls $PATH_TO_HOOKS/includes)
hook_types=$(ls $PATH_TO_HOOKS/includes | cut -d'-' -f1)

# Determine repository to install hooks in
echo -e "\nSCM project directory [${HOME}/repos/myproject]:"
read PATH_TO_PROJECT

if [ -d $PATH_TO_PROJECT ]; then
  if [ -e $PATH_TO_PROJECT/.gitmodules ]; then
    echo -e "\nWould you like us to apply hooks to the submodules too [Y/N]:"
    read install_submodules
  fi;

  filetypes=$(find $PATH_TO_PROJECT -type f -name "*.*" | awk -F. '{print $NF}' | sort -u)
  echo -e "\nThe project has these filetypes:\n${filetypes[@]}"
  echo -e "\nWe have the following hooks available:\n${hook_types[@]/*.md/}"

  # Install Hooks
  echo -e "\nList desired hooks separated by spaces:"
  read -a apply_hooks

  if [ "${#apply_hooks[@]}" -gt 0 ]; then
    for hook in ${apply_hooks[@]}; do
      hook_dir="${PATH_TO_PROJECT}/.git/hooks"
      append=`find "${PATH_TO_HOOKS}/includes" -maxdepth 2 -iname "*${hook}*.hook"`

      if [ -a $hook_dir/pre-commit ]; then
        if [ -w $append ]; then
          dups=`grep "${append}" $hook_dir/pre-commit`
          if [ "${dups}" == "" ]; then
            echo -e "\nApplying $hook to pre-commit chain"
            echo -e "bash $append" >> $hook_dir/pre-commit
            chmod +x $hook_dir/pre-commit
          else
            echo -e "\n$hook is already established"
          fi
        fi
      else
        echo -e "#!/bin/bash\n" > $hook_dir/pre-commit
      fi
    done;

    if [ `echo ${install_submodules} | tr '[:lower:]' '[:upper:]'` == "Y" ]; then
      for module in $PATH_TO_PROJECT/modules/*/; do
        submodule_dir=`egrep "path" $PATH_TO_PROJECT/.gitmodules | head -1 | cut -d'=' -f2 | tr -d ' '`
        ln -s $hook_dir/pre-commit $PATH_TO_PROJECT/.git/modules/${submodule_dir}/hooks/pre-commit 2>/dev/null;
        if [ $? -gt 0 ]; then
          echo -e "There seems to already be hooks installed here";
        fi;
      done;
    fi;
  fi;
else
  echo "Sorry this project doesn't seem to exist at $PATH_TO_PROJECT"
fi
