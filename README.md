hooks
========

Random Hooks Used to Manage Specific Types of Projects

If you are looking to manage a complex project with hooks for different languages, this may be a good starting place.
You will probably need to merge a few of these together if your project contains different file types.

# Install

Add to 
```
<path_to_hooks>/hooks and/or <path_to_hooks>/module/*/hooks
```

or 
```
git clone <repo>
```

# Configure

```
ln -s <path_to_hooks>/<hook> <path_to_modules>/<hook>

if [ -w <hook> ]; then 
  echo -e "\nbash <path_to_hooks>/<hook>" >> <path_to_hooks>/pre-commit
  chmod +x <path_to_hooks>/pre-commit
fi;

for module in <path_to_modules>/*/;
  do ln -s <path_to_shared>/pre-commit ${module}hooks/pre-commit;
done
```

