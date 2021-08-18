function connect-sqlshell {
  if [[ -z "${NAMESPACE}" ]]; then
    if [[ -n ${1} ]]; then
      NAMESPACE=${1}
    else
      echo "Please provide a NAMESPACE, either set NAMESPACE environment, or pass as \${1}"
      return 1
    fi
  fi
  SPLICEDB=$(kubectl -n ${NAMESPACE} get splicedbcluster --no-headers -o custom-columns="NAME:.metadata.name"); echo ${SPLICEDB}
  JDBC_URL=$(kubectl -n ${NAMESPACE} get splicedbcluster ${SPLICEDB} -o json | jq -r '.status.urls.jdbc')
  DB_USER=$(kubectl -n ${NAMESPACE} get splicedbcluster ${SPLICEDB} -o json | jq -r '.spec.global.splice.user')
  DB_PASS=$(kubectl -n ${NAMESPACE} get splicedbcluster ${SPLICEDB} -o json | jq -r '.spec.global.splice.password')
  # sqlshell -U "${JDBC_URL};user=${DB_USER};password=${DB_PASS}"
  sqlline -u "${JDBC_URL}" -n ${DB_USER} -p ${DB_PASS}
}
