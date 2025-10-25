# Ansible

Ansible is an automation tool for provisioning and managing computers.
It supports a variety of platforms, however, for my purposes it's used solely for managing Linux systems.
This playbook is used for both desktops and servers, albeit to differing degrees.

> [!WARNING]
> This is under active development; expect things to change.

## Overview

The Ansible workflow roughly boils down to:
* An "inventory" of "hosts" to configure
* A "playbook" that specified which "roles" and "tasks" are applicable to different hosts, including by hostname or group
* Various "roles" which contain "tasks" to perform
* "Collections" of modules that can be used in "tasks"
* "Tags" which can be used to run only a subset of roles/tasks

Ansible is intended to be idempotent, meaning that it defines the end state rather than the steps to take.
While this doesn't always work in practice without writing significantly more involved code, you will regularly see this approach used through the roles here, such as by getting state and using `when` statements.

As an additional aside, Ansible is supposedly technically agnostic to things like directory structure.
In practice, however, this doesn't tend to hold up, particularly if you're using something like AWX/Ansible Tower to automate provisioning (since AWX/Ansible Tower can be somewhat opinionated about directory structure at times).
This playbook doesn't use AXW/Ansible Tower and isn't tested against it, however, the directory structure is based on old/outdated recommendations and prior experience with AWX/Ansible Tower.

## Running

Make sure this directory is your current/working directory (`cd`).

Dry run (note that this doesn't work with some modules):

`ansible-playbook --check --diff playbooks/playbook.yml`

Run against all hosts:

`ansible-playbook playbooks/playbook.yml`

Run against a single host or group:

`ansible-playbook -l web.ctmartin.me playbooks/playbook.yml`

Run only roles tagged with "stacks" against a host:

`ansible-playbook -l web.ctmartin.me -t stacks playbooks/playbook.yml`

Run against a host for the first time (with an atypical login):

Make sure the host is in the `hosts.ini` inventory file and that any necessary host vars are set (particularly for managing logins).
There is a playbook (`init.yml`) that's designed to assist in provisioning machines.
This playbook is not comprehensive - its sole purpose is to get from a newly provisioned machine to something the full playbook can be run against.

Note that it should be expected for this command to fail since it's updating the password for the user running Ansible.

`ansible-playbook -l host-of-new-machine -e ansible_host=192.168.1.10 -u christian -k playbooks/init.yml`

You may need to install `sshpass` on the host running Ansible.
If you haven't logged into the machine at all, you may need either do so (to add it to the host keys file) or run with `-e ansible_host_key_checking=false`

Alternatively, you can manually set the password & SSH public keys, then run the usual command.

Note that some hosts give you a temporary password and require you to manually sign in and change the password;
Ansible (or at least this playbook) can't do that interactive workflow for you.

## Stacks

The role contained here introduce a concept of "stacks" (which is not native to Ansible).
Like as used in common parlance (such as "LAMP stack"), the "stacks" roles define various tools (and configuration for those tools) to be installed/configured.
While the roles are intended to focus on installation, they may contain configuration, be opinionated (`stacks/certbot` only supports Cloudflare DNS challenge), and/or require specific variables to be set.

Some of the roles (such as `stacks/nginx`) align with the typical use of the term "stacks" whereas others (such as `stacks/hugo`) are more of tools than stacks.
Some of the roles also have dependencies, such as `stacks/nginx` requiring `stacks/certbot`.

Stacks are primarily called in my playbook by the `stacks/fromvars` role, which merges any group or host variable called `stacks` or starting with `stacks_`.
This is necessary since variables can be overwritten (e.g. a host var called `stacks` will overwrite a group var called `stacks`) and so it's necessary to get a list of all desired stacks.

As an example, in my inventory, I have the following:
* The `vpn` group has a variable called `stacks_vpn` which declares `tailscale`
* The `web` group has a variable called `stacks_web_all` which declares `nginx`
* My old LAMP server had a variable called `stacks` which declared `php` & `mysql` (and was also part of the `web` group)

## Tips

* Running Ansible can be slow; sometimes it's useful to temporarily comment out roles or `include_tasks` statements that aren't applicable in the current run (for example, aren't being changed/affected)
  * Adding tags helps a **lot** but sometimes this is still necessary for testing
* Create encrypted variables with `ansible-vault encrypt_string`

## Useful Documentation

(Organized in a way that I find useful; not aligned with the organization of the documentation linked to)

* [Ansible](https://docs.ansible.com/ansible/latest/)
  * [Using Ansible playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/index.html)
    * [Using filters to manipulate data](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html)
    * [Conditionals](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html)
      * [Tests](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tests.html)
    * [Loops](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html)
    * [`ansible.builtin` Collection](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html)
  * [Using Variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html)
    * In particular, see the "Variable precedence" section
    * [Facts & magic variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html)
  * [`ansible-playbook`](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html)
  * [`ansible-vault`](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html) (secrets management)
* [Jinj2 Templating](https://docs.ansible.com/ansible/latest/playbook_guide/index.html) (used for all templating and conditional statements, for example, `.j2` template files and `when` statements)
