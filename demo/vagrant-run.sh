#!/bin/bash
set -x

# Copyright 2018 Inscope Metrics
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

sleep 5
/usr/bin/systemctl start scylla-server
sleep 15
/usr/bin/systemctl start kairosdb
sleep 5
/usr/bin/systemctl start grafana-server
sleep 5

ln -s /opt/mad/logs /var/log/mad
rm -rf /opt/mad/config/*
cp -r /vagrant/config/mad/* /opt/mad/config/

mkdir -p /opt/cluster-aggregator/target
chown cagg:cagg -R /opt/cluster-aggregator/target
ln -s /opt/cluster-aggregator/logs /var/log/cluster-aggregator
rm -rf /opt/cluster-aggregator/config/*
cp -r /vagrant/config/cagg/* /opt/cluster-aggregator/config/

mkdir -p /usr/share/metrics-portal/target
chown metrics-portal:metrics-portal -R /usr/share/metrics-portal/target
cp -r /vagrant/config/metrics-portal/* /usr/share/metrics-portal/conf/

cp /vagrant/config/telegraf/telegraf.conf /etc/telegraf/telegraf.conf

/usr/bin/systemctl restart cluster-aggregator
sleep 5
/usr/bin/systemctl restart mad
sleep 5
/usr/bin/systemctl restart metrics-portal
/usr/bin/systemctl restart telegraf

# Setup Grafana KairosDb data source
for file in /vagrant/data/grafana/data-sources/*.json; do
  [ -e "${file}" ] || continue
  curl -X POST \
    --user admin:admin \
    -H 'content-type: application/json;charset=UTF-8' \
    --data "@${file}" \
    http://localhost:3000/api/datasources
done

# Setup Grafana dashboards
for file in /vagrant/data/grafana/dashboards/*.json; do
  [ -e "${file}" ] || continue
  curl -X POST \
    --user admin:admin \
    -H 'content-type: application/json' \
    --data "@${file}" \
    http://localhost:3000/api/dashboards/db
done

exit 0
