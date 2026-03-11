# db-hub

phpMyAdmin s podporou viacerých databáz — priame pripojenie aj cez SSH tunel.
Všetky servery sa konfigurujú v jednom súbore: `config/servers.conf`.

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
