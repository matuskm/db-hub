# db-hub

phpMyAdmin with multi-database support. Add as many servers as you want — via SSH tunnel or direct connection — all configured in one file.

## Quick start

```bash
make init    # creates .env and config/servers.conf from templates
             # edit .env → set PMA_BLOWFISH_SECRET (openssl rand -base64 32)
             # edit config/servers.conf → add your servers
make build   # build the image (first time only)
make up      # start
```

Open `http://localhost:6868` — change the port via `APP_PORT` in `.env`.

---

## Adding a server

Edit `config/servers.conf`, then run `make restart`.

**SSH tunnel**
```ini
[My Production DB]
type       = ssh
ssh_host   = 1.2.3.4
ssh_port   = 22
ssh_user   = ubuntu
ssh_key    = id_rsa       # file in ~/.ssh/ — or use ssh_pass for password auth
ssh_pass   =
db_host    = 127.0.0.1
db_port    = 3306
local_port = 3307         # must be unique per server
db_user    = myuser
db_pass    =              # leave empty → prompted at login
```

**Direct connection**
```ini
[My Direct DB]
type    = direct
db_host = 192.168.1.100
db_port = 3306
db_user = root
db_pass =
```

---

## Commands

| Command | Description |
|---|---|
| `make init` | Create `.env` and `config/servers.conf` from templates |
| `make up` | Start containers |
| `make down` | Stop containers |
| `make restart` | Reload config (after editing `servers.conf`) |
| `make build` | Rebuild the db-hub image |
| `make logs` | Tail logs |
| `make status` | Show container status |

---

## How it works

On startup, the `db-hub` container reads `servers.conf`, generates phpMyAdmin config, and opens one `autossh` tunnel per SSH server. SSH keys are read directly from `~/.ssh` on your host — nothing is copied into the container.


## Prvé spustenie

```bash
make init   # vytvorí .env a config/servers.conf zo šablón
# otvor .env a nastav PMA_BLOWFISH_SECRET (openssl rand -base64 32)
# otvor config/servers.conf a pridaj svoje servery
make build  # zbuilduje db-hub image (len prvý raz)
make up     # spustí kontajnery
```

Otvor `http://localhost:6868` (port zmeníš cez `APP_PORT` v `.env`).

---

## Pridanie servera — `config/servers.conf`

### Cez SSH tunel

```ini
[Názov v dropdowne]
type       = ssh
ssh_host   = 1.2.3.4        # IP / hostname SSH servera
ssh_port   = 22
ssh_user   = ubuntu
ssh_key    = id_rsa          # súbor v ~/.ssh/ — ALEBO vyplň ssh_pass
ssh_pass   =
db_host    = 127.0.0.1       # MySQL host z pohľadu SSH servera
db_port    = 3306
local_port = 3307            # ľubovoľný voľný port, každý server iný
db_user    = dbuser
db_pass    =                 # prázdne = phpMyAdmin sa opýta pri logine
```

### Priame pripojenie (bez SSH)

```ini
[Názov v dropdowne]
type    = direct
db_host = 192.168.1.100
db_port = 3306
db_user = root
db_pass =
```

Potom: `make restart`

---

## Príkazy

| Príkaz | Popis |
|---|---|
| `make init` | Vytvorí `.env` a `config/servers.conf` zo šablón |
| `make up` | Spustí kontajnery |
| `make down` | Zastaví kontajnery |
| `make restart` | Reštartuje (načíta zmeny v `servers.conf`) |
| `make build` | Prebuduje db-hub image |
| `make logs` | Zobrazí logy (Ctrl-C na ukončenie) |
| `make status` | Stav kontajnerov |

---

## Štruktúra

```
db-hub/
├── config/
│   ├── servers.conf          ← tvoje servery (gitignored)
│   └── servers.conf.example  ← šablóna
├── docker-compose.yml
├── Dockerfile.tunnels
├── entrypoint.py
├── .env                      ← APP_PORT + PMA_BLOWFISH_SECRET (gitignored)
├── .env.example
└── Makefile
```

## Ako to funguje

Pri štarte `db-hub` kontajner prečíta `servers.conf`, vygeneruje phpMyAdmin konfig a otvorí SSH tunely (jeden `autossh` proces per SSH server). phpMyAdmin sa k tunelovaným serverom pripája cez internú Docker sieť.
