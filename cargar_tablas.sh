cat << 'EOF' > cargar_tablas.sh
#!/bin/bash
docker exec pinot-controller-1-1 mkdir -p /tmp/raw_data/transcript /tmp/raw_data/tracks /tmp/definitions/

docker cp transcript.csv pinot-controller-1-1:/tmp/raw_data/transcript/
docker cp transcript-schema.json pinot-controller-1-1:/tmp/definitions/
docker cp transcript-table-offline.json pinot-controller-1-1:/tmp/definitions/
docker cp docker-job-spec.yml pinot-controller-1-1:/tmp/definitions/

docker cp tracks.csv pinot-controller-1-1:/tmp/raw_data/tracks/
docker cp tracks-schema.json pinot-controller-1-1:/tmp/definitions/
docker cp tracks-table-offline.json pinot-controller-1-1:/tmp/definitions/
docker cp tracks_job_spec.yml pinot-controller-1-1:/tmp/definitions/

docker exec pinot-controller-1-1 /opt/pinot/bin/pinot-admin.sh AddTable -controllerPort 9001 -schemaFile /tmp/definitions/transcript-schema.json -tableConfigFile /tmp/definitions/transcript-table-offline.json -exec
docker exec pinot-controller-1-1 /opt/pinot/bin/pinot-admin.sh LaunchDataIngestionJob -jobSpecFile /tmp/definitions/docker-job-spec.yml

docker exec pinot-controller-1-1 /opt/pinot/bin/pinot-admin.sh AddTable -controllerPort 9001 -schemaFile /tmp/definitions/tracks-schema.json -tableConfigFile /tmp/definitions/tracks-table-offline.json -exec
docker exec pinot-controller-1-1 /opt/pinot/bin/pinot-admin.sh LaunchDataIngestionJob -jobSpecFile /tmp/definitions/tracks_job_spec.yml
EOF
chmod +x cargar_tablas.sh
git add cargar_tablas.sh && git commit -m "Añade script de carga de tablas" && git push