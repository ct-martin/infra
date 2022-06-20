# infra
My config management

Directories:
* `k3os-bootstrap/nodes/<node>` - Configs to Bootstrap a K3OS cluster. Contains only the minimum installation needed to get set up; other tools (e.g. Argo CD) will take over after bootstrapping is complete.
* `argocd-apps/nodes/<node>/<app>` - Argo CD Applications
  * `argocd-apps/nodes/<node>/apps` - Argo CD ["App of Apps"](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/)
