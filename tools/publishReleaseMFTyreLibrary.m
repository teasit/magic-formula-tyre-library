function [outputArg1,outputArg2] = publishReleaseMFTyreLibrary(inputArg1,inputArg2)
%PUBLISHRELEASEMFTYRELIBRARY Summary of this function goes here

Interactively create a release
gh release create

Interactively create a release from specific tag
$ gh release create v1.2.3

Non-interactively create a release
$ gh release create v1.2.3 --notes "bugfix release"

Use automatically generated release notes
$ gh release create v1.2.3 --generate-notes

Use release notes from a file
$ gh release create v1.2.3 -F changelog.md

Upload all tarballs in a directory as release assets
$ gh release create v1.2.3 ./dist/*.tgz

Upload a release asset with a display label
$ gh release create v1.2.3 '/path/to/asset.zip#My display label'

Create a release and start a discussion
$ gh release create v1.2.3 --discussion-category "General"

end

