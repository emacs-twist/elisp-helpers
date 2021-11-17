# Build a URL-like representation of flake reference from a recipe string.
{ parseRecipe }: recipe:
with builtins;
let
  package = parseRecipe recipe;
  inherit (package) fetcher;
  branchSuffix =
    if package.branch != null && package.commit == null
    then "/${package.branch}"
    else "";
  query =
    if package.commit != null && package.branch != null
    then "?ref=${package.branch}&rev=${package.commit}"
    else if package.commit != null
    then "?rev=${package.commit}"
    else if package.branch != null && fetcher == "git"
    then "?ref=${package.branch}"
    else "";
  toGitRef = url:
    if match "git[:+].+" url == null
    then "git+" + url
    else url;
in
if fetcher == "github"
then "github:${package.repo}" + branchSuffix + query
else if fetcher == "gitlab"
then toGitRef "https://gitlab.com/${package.repo}" + branchSuffix + query
else if fetcher == "git"
then toGitRef package.url + query
else throw "Unsupported fetcher: ${fetcher}"
