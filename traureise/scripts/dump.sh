#!/usr/bin/env bash
# Writes one dump of the database to traureise/data/dumps and removes dumps of the same kind older than <days>.
# The images are not in the dump: they are the files in traureise/data/uploads; copy them the same day.
#
#   scripts/dump.sh <kind> <days to keep>      e.g. scripts/dump.sh daily 30
#
# Restore (into an empty database, with Traureise stopped):
#   docker compose stop traureise
#   gunzip -c data/dumps/<file>.sql.gz | docker compose exec -T db psql -U traureise -d traureise
#   docker compose start traureise
set -euo pipefail
cd "$(dirname "$0")/.."
kind=${1:?kind, e.g. hourly or daily}
days=${2:?days to keep}
mkdir -p data/dumps
file="data/dumps/${kind}-$(date -u +%Y%m%dT%H%M%SZ).sql.gz"
docker compose exec -T db pg_dump -U traureise -d traureise --clean --if-exists | gzip > "$file.tmp"
mv "$file.tmp" "$file"
find data/dumps -name "${kind}-*.sql.gz" -mtime "+${days}" -delete
echo "$file"
