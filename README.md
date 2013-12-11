githooks
========

Random Git Hooks Used to Manage Specific Types of Projects

If you are looking to manage a complex project with hooks for different languages, this may be a good starting place.
You will probably need to merge a few of these together if your project contains different file types.

# Install

Add to the .git/hooks or .git/hooks/module/*/hooks

# Configure

```
ln -s githooks/<hook> <path_to_modules>/hook
for module in <path_to_modules>/*/;
  do ln -s <path_to_shared>/pre-commit ${module}hooks/pre-commit;
done
```
