#!/bin/bash

splicecore_urls() {

    local cluster_name=$1
    local dns_domain=$2
    ingress_domain="${cluster_name}.${dns_domain}"
    ingress_admin_domain="${cluster_name}admin.${dns_domain}"
    ingress_hbase="${cluster_name}admin-hbase.${dns_domain}"
    ingress_hdfs="${cluster_name}admin-hdfs.${dns_domain}"
    ingress_dashboard="${cluster_name}-dashboard.${dns_domain}"
	
    echo "Your urls are:"
    echo "Dashboard:            https://${ingress_dashboard}/"
    echo "Kibana:               https://${ingress_admin_domain}/kibana"
    echo "Chronograf:           https://${ingress_admin_domain}/chronograf"
    echo "Oauth:                https://${ingress_admin_domain}/oauth2"
    echo "Cloud Manager Admin:  https://${ingress_admin_domain}"
    echo "Cloud Manager:        https://${ingress_domain}"
}


splicedb_urls () {
    local cluster_name=$1
    local dns_domain=$2
    SPLICEDB_CLUSTERS=($(kubectl get splicedbcluster -n default --no-headers | awk '{ print $1 }'))
    for DB in $SPLICEDB_CLUSTERS; do
        NS=$(kubectl get splicedbcluster $DB -o json | jq -r '.spec.global.dnsPrefix')
        echo "Splice DB JDBC:       ${NS}-${cluster_name}.${dns_domain}"
    done
}

