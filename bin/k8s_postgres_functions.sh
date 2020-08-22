function set-k8s-postgres {
	export PGUSER=$(splicectl get system-settings | jq -r '.data.POSTGRES_USER' | base64 -d)
	export PGPORT=5432
	export PGHOST=localhost
	export PGDATABASE=$(splicectl get system-settings | jq -r '.data.POSTGRES_DATABASE')
	export PGPASSWORD=$(splicectl get system-settings | jq -r '.data.POSTGRES_PASSWORD' | base64 -d)
}

function connect-k8s-postgres {
	kubectl -n splice-system port-forward $(kubectl -n splice-system get pod --selector=kubedb.com/name=cloudmgr-database --no-headers | awk '{print $1}') 5432:5432
}

