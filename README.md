# nephio-testorg-deploy

This repo contains directories representing different regional and edge
clusters. The YAML files can be used to register all of these repositories
with a Porch instance for testing, though you will likely need to change them to
point to your repo and your secret name.

NOTE: Due to https://github.com/GoogleContainerTools/kpt/issues/3870 the YAML
files now point to repos in https://github.com/nephio-test
