#!/bin/bash
# Copyright © 2022 sealos.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cd "$(dirname "$0")" >/dev/null 2>&1 || exit
source common.sh
storage=${1:-/var/lib/registry}

check_port_inuse
if command_exists docker; then
  error "docker already exist, uninstall docker and retry"
fi
check_cmd_exits docker
check_file_exits /var/run/docker.sock
check_file_exits $storage
if ! command_exists apparmor_parser; then
  sed -i 's/disable_apparmor = false/disable_apparmor = true/g' ../etc/config.toml
  warn "Replace disable_apparmor = false to disable_apparmor = true"
fi
if /usr/bin/crun --version 2>/dev/null | grep -q .99; then
  sed -i -E 's~default_runtime_name = ".+"~default_runtime_name = "crun"~' ../etc/config.toml
fi
logger "check root,port,cri success"
