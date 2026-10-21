# stacks

How [traureise.de](https://traureise.de) runs [Traureise](https://github.com/Traureise/traureise): the compose files of the server, one folder per tool. It is public as a worked example of a production setup; take what is useful.

| Folder | What runs | Reachable |
|---|---|---|
| `traureise/` | Traureise and PostgreSQL 17; `legal/` holds this instance's Impressum, privacy policy and terms (AGB), `scripts/dump.sh` dumps the database | On the server's private address only: a reverse proxy in front passes requests on |

## How it is used

This repository is checked out on the server, and each folder's `.env` is written there. So:

- **There are no secrets and no server addresses in here.** Each folder's `.env.example` lists the names; the values are written on the server.
- **Nobody edits files on the server.** A change is a commit here, then a deployment.
- **Versions are pinned.** Upgrading Traureise is a commit that changes the image tag in `traureise/compose.yaml`.

## Legal texts

Traureise ships no Impressum, privacy policy or terms. This instance's are the Markdown files in `traureise/legal/`. The documentation build of Traureise/traureise copies them in and publishes them at [docs.traureise.de/impressum](https://docs.traureise.de/impressum/), [/datenschutz](https://docs.traureise.de/datenschutz/) and [/agb](https://docs.traureise.de/agb/); the app links them through `IMPRINT_URL`, `PRIVACY_URL` and `TERMS_URL` ([how it works](https://docs.traureise.de/legal-and-billing/)). After a change here, run "Publish docs" in Traureise/traureise to republish them. Their history here is the record of what each page said on which day.

## Backups

`traureise/scripts/dump.sh <kind> <days to keep>` writes one dump to `traureise/data/dumps` and removes older dumps of the same kind; how to restore is at the top of the script. The images are the files in `traureise/data/uploads`; copy them the same day. The privacy policy promises daily backups kept 30 days: whatever runs this stack has to schedule exactly that.

## Trying it yourself

```sh
cp traureise/.env.example traureise/.env   # fill in the password, SMTP and the URL; PRIVATE_IP=127.0.0.1 on a single machine
mkdir -p traureise/data/uploads
(cd traureise && docker compose up -d)
```

Without a real mail server, add a mail catcher in `traureise/compose.override.yaml` (ignored by git, loaded by compose automatically) and point `SMTP_HOST` at it.
