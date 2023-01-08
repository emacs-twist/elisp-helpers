attrs @ {
  type,
  url ? null,
  rev ? null,
  ref ? null,
  ...
}:
with builtins; let
  branchSuffix =
    if ref != null && rev == null
    then "/${ref}"
    else "";
  query =
    if attrs ? rev && attrs ? ref
    then "?ref=${ref}&rev=${rev}"
    else if attrs ? rev
    then "?rev=${rev}"
    else if attrs ? ref && type == "git"
    then "?ref=${ref}"
    else "";
  toGitUrl = url:
    assert isString url;
      if match "git[:+].+" url == null
      then "git+" + url
      else url;
  toHgUrl = url:
    assert isString url;
      if match "hg\+.+" url == null
      then "hg+" + url
      else url;
in
  if type == "github"
  then "github:${attrs.owner}/${attrs.repo}" + branchSuffix + query
  else if type == "sourcehut"
  then "sourcehut:${attrs.owner}/${attrs.repo}" + branchSuffix + query
  else if type == "gitlab"
  then "gitlab:${attrs.owner}/${attrs.repo}" + branchSuffix + query
  else if type == "git"
  then toGitUrl url + query
  else if type == "mercurial"
  then toHgUrl url + query
  else if type == "tarball"
  then url
  else throw "Unsupported type: ${type}"
