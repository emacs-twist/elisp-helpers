{lib}: package @ {
  fetcher,
  commit ? null,
  branch ? null,
  ...
}:
with builtins; let
  repoPath = split "/" package.repo;
  vcAttrs = lib.filterAttrs (_: v: v != null) {
    rev = commit;
    ref = branch;
  };

  # These functions are defined for individual types defined in the manual:
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#types

  buildGitHubAttrs = {
    owner,
    repo,
  }: (vcAttrs
    // {
      type = "github";
      inherit owner repo;
    });

  buildSourceHutAttrs = {
    owner,
    repo,
  }: (vcAttrs
    // {
      type = "sourcehut";
      inherit owner repo;
    });

  buildGitAttrs = {url}: (vcAttrs
    // {
      type = "git";
      inherit url;
    });

  buildMercurialAttrs = {url}: (vcAttrs
    // {
      type = "mercurial";
      inherit url;
    });
in
  if fetcher == "github"
  then
    buildGitHubAttrs
    {
      owner = elemAt repoPath 0;
      repo = elemAt repoPath 2;
    }
  else if fetcher == "sourcehut"
  then
    buildSourceHutAttrs
    {
      owner = "~${elemAt repoPath 0}";
      repo = elemAt repoPath 2;
    }
  else if fetcher == "codeberg"
  then
    buildGitAttrs
    {
      url = "https://codeberg.org/${package.repo}.git";
    }
  else if fetcher == "gitlab"
  then
    buildGitAttrs
    {
      url = "https://gitlab.com/${package.repo}.git";
    }
  else if fetcher == "git"
  then
    buildGitAttrs
    {
      inherit (package) url;
    }
  else if fetcher == "hg"
  then
    buildMercurialAttrs
    {
      inherit (package) url;
    }
  else throw "Unsupported fetcher type: ${fetcher}"
