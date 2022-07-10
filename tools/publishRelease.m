function publishRelease(version, title, changelogFile, packageFile, packagerFile, repository)
%PUBLISHRELEASE Automatic release to GitHub
arguments
    version char
    title char = char.empty
    changelogFile char {mustBeFile} = 'CHANGELOG.md'
    packageFile char = 'MagicFormulaTyreLibrary.mltbx'
    packagerFile char = 'ToolboxPackager.prj'
    repository char = 'teasit/magic-formula-tyre-library'
end
pattern = 'v' + digitsPattern() + '.' + digitsPattern() + '.' + digitsPattern();
versionInvalid = ~matches(version, pattern);
if versionInvalid
    error('Invalid version pattern. Example: v1.0.1')
end
webquery = sprintf('https://api.github.com/repos/%s/releases/latest', repository);
versionLatest = webread(webquery).tag_name;
versionExists = strcmp(versionLatest, version);
if versionExists
    error('Latest release version and argument ''version'' are the same.')
end
    
results = runtests('OutputDetail', 0);
failed = [results.Failed];
if any(failed)
    error('Unit Tests failed. Aborted release publish')
end

matlab.addons.toolbox.toolboxVersion(packagerFile, erase(version, 'v'));
matlab.addons.toolbox.packageToolbox(packagerFile);

if isempty(title)
    title = version;
end

prompt = 'Do you really want to push to remote? [yes]: ';
response = input(prompt, 's');
if ~strcmp(response, 'yes')
    warning('Publication of release aborted.')
    return
end

system('git add *')
system(sprintf('git commit -m "publish release %s"', version))
system('git push')

cmd = "gh release create %s --title %s --notes-file %s";
cmd = sprintf(cmd, version, title, changelogFile);
[status, cmdout] = system(cmd);
if status == 1
    warning('Failed to create release. Command-Line output:')
    disp(cmdout)
    return
end

cmd = "gh release upload %s %s";
cmd = sprintf(cmd, version, packageFile);
[status, cmdout] = system(cmd);
if status == 1
    warning('Failed to upload packaged toolbox. Command-Line output:')
    disp(cmdout)
    return
end
end
