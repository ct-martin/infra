# infra
My config management

## Directories
* `ansible` - Ansible playbooks for configuring nodes
* `k3os-bootstrap/nodes/<node>` (not in use) - Configs to Bootstrap a K3OS cluster. Contains only the minimum installation needed to get set up; other tools (e.g. Argo CD) will take over after bootstrapping is complete.
* `argocd-apps/nodes/<node>/<app>` (not in use) - Argo CD Applications
  * `argocd-apps/nodes/<node>/apps` - Argo CD ["App of Apps"](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/)

## Inventory
* `PROUD` - Windows laptop
* `pop`/`pop-os` - Linux laptop running Pop! OS (Ubuntu derivative)
* `ctmartin-web`/`vps` - DigitalOcean VPS (1GB RAM) which needs to be rebuilt
