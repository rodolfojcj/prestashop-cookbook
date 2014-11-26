#
# Cookbook Name:: prestashop
# Recipe:: default
#
# Copyright 2014, OpenSinergia
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
#

include_recipe "prestashop::php5_mcrypt" if node['prestashop']['with_php5_mcrypt'] == true
include_recipe "prestashop::php5_imap" if node['prestashop']['need_imap_for_service_client'] == true
include_recipe "prestashop::presh" if node['prestashop']['presh']['enabled'] == true
