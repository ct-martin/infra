# Ansible

Ansible is an automation tool for provisioning and managing computers.
It supports a variety of playforms, however, for my purposes it's used solely for managing Linux systems.
This playbook is used for both desktops and servers, albeit to differing degrees.

## Overview

The Ansible workflow roughly boils down to:
* An "inventory" of "hosts" to configure
* A "playbook" that specified which "roles" and "tasks" are applicable to different hosts, including by hostname or group
* Various "roles" which contain "tasks" to perform
* "Collections" of modules that can be used in "tasks"

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

`ansible-playbook playbooks.playbook.yml`

Run against a single host or group:

`ansible-playbook -l web.ctmartin.me playbooks/playbook.yml`

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

## Tips

* Running Ansible can be slow; sometimes it's useful to temporarily comment out roles or `include_tasks` statements that aren't applicable in the current run (for example, aren't being changed/affected)
