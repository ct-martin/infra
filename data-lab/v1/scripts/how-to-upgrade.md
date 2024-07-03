# How to Upgrade

## Upgrading deployed software

Rerun each of the bash scripts in the `helm/deploy/` folder.

## MicroK8s versions

MicroK8s only supports upgrading incrementally across minor versions, and does not support downgrading.

For example, to upgrade from 1.28 to 1.30 you need to do:

```sh
sudo snap refresh microk8s --channel=1.29/stable
sudo snap refresh microk8s --channel=1.30/stable
```

## Upgrading Addons

The MicroK8s docs are a bit unclear on how to upgrade addons specifically.
The recommendation seems to be to update the repos (below) and then disable and enable the addon.
I don't know what this will do to some addons that require persistent storage.

### Upgrading Addon repos

```sh
sudo microk8s addons repo update core
```

This setup doesn't use them, but if needed you can find a list of additional repos (e.g. community) using:

```sh
microk8s addons repo list
```
