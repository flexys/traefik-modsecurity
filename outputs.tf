# Lets this repo be consumed as a Terraform module so Traefik can load the plugin in
# local mode (experimental.localPlugins, type inlinePlugin) from a ConfigMap, instead of
# downloading it from GitHub via plugins.traefik.io on every pod start. That removes the
# runtime dependency on GitHub and allows this repo to be private.
#
# Usage:
#   module "modsecurity_plugin" {
#     source = "git@github.com:flexys/traefik-modsecurity.git?ref=vX.Y.Z"
#   }
#   ... source = module.modsecurity_plugin.inline_source
#
# Yaegi only reads .go files, so this file has no effect on the plugin itself.
#
# Must list every non-test .go file plus .traefik.yml and go.mod - the
# "Terraform inline source" workflow fails the PR if a .go file is missing. All files must
# stay at the repo root: the chart's ConfigMap is flat.

output "module_name" {
  description = "Go module name, for experimental.localPlugins.<name>.moduleName"
  value       = "github.com/flexys/traefik-modsecurity"
}

output "inline_source" {
  description = "Plugin files keyed by filename, for experimental.localPlugins.<name>.source with type inlinePlugin"
  value = {
    ".traefik.yml"   = file("${path.module}/.traefik.yml")
    "go.mod"         = file("${path.module}/go.mod")
    "modsecurity.go" = file("${path.module}/modsecurity.go")
  }
}
