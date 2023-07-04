from web3 import Web3
import csv


# Funktion zur Ausgabe
def speichereUnternehmen(host, contract_address, contract_abi, speicherpfad):
    w3 = Web3(Web3.HTTPProvider(host))

    Contract = w3.eth.contract(address=contract_address, abi=contract_abi)

    unternehmensliste = Contract.functions.alleUnternehmenListe().call()

    with open(speicherpfad, "w+", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(
            [
                "ID",
                "Name",
                "WalletAdresse",
                "Typ",
                "Herkunftsland",
                "Strasse",
                "Ort",
                "Umsatzsteuernummer",
                "Zertifikate",
            ]
        )
        writer.writerows(unternehmensliste)


# Speichere alle Transaktionsgrundinformationen in einer spezifizierten Datei
def speichereTransaktionsgrundinfos(host, contract_address, contract_abi, speicherpfad):
    w3 = Web3(Web3.HTTPProvider(host))

    Contract = w3.eth.contract(address=contract_address, abi=contract_abi)

    grundinfos = Contract.functions.alleTransaktionengrundinformationenListe().call()

    with open(speicherpfad, "w+", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(
            [
                "T_ID",
                "Produkt",
                "Beschreibung",
                "Preis",
                "Menge",
                "Kaeufer",
                "Verkaeufer",
                "Einfuhrland",
                "Ausfuhrland",
            ]
        )
        writer.writerows(grundinfos)


# Speichere alle Transaktionszusatzinformationen in einer spezifizierten Datei
def speichereTransaktionszusatzinfos(
    host, contract_address, contract_abi, speicherpfad
):
    w3 = Web3(Web3.HTTPProvider(host))

    Contract = w3.eth.contract(address=contract_address, abi=contract_abi)

    zusatzinfos = Contract.functions.alleTransaktionenzusatzinformationenListe().call()

    with open(speicherpfad, "w+", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(
            [
                "T_ID",
                "Zeitpunkt",
                "LandInPositivliste",
                "RisikobehaftetesProdukt",
                "GueltigeZertifizierungen",
                "EinfuhrGueltig",
                "AusfuhrGueltig",
            ]
        )
        writer.writerows(zusatzinfos)


# Lade eine vordefinierte Datei mit Unternehmensinformationen auf die Blockchain
def uploadUnternehmensdatei(host, contract_address, contract_abi, speicherpfad, sender):
    w3 = Web3(Web3.HTTPProvider(host))

    Contract = w3.eth.contract(address=contract_address, abi=contract_abi)

    with open(
        speicherpfad,
        encoding="utf8",
    ) as file:
        reader = csv.reader(file, delimiter=";")
        next(reader)

        for row in reader:
            name = row[1]
            wallet = row[2]
            typ = row[3]
            herkunftsland = row[4]
            strasse = row[5]
            ort = row[6]
            zertifizierungen = row[7]

            zertifizierungen_liste = zertifizierungen.split(",")

            tx_hash = Contract.functions.erstelleUnternehmen(
                name,
                wallet,
                int(typ),
                herkunftsland,
                strasse,
                ort,
                zertifizierungen_liste,
            ).transact({"from": sender})


# Lade eine vordefinierte Datei mit Transaktionsinformationen auf die Blockchain
def uploadTransaktionsdatei(host, contract_address, contract_abi, speicherpfad, sender):
    w3 = Web3(Web3.HTTPProvider(host))

    Contract = w3.eth.contract(address=contract_address, abi=contract_abi)

    with open(
        speicherpfad,
        encoding="utf8",
    ) as file:
        reader = csv.reader(file, delimiter=";")
        next(reader)

        for row in reader:
            produkt = row[1]
            beschreibung = row[2]
            kaeufer = row[5]
            verkaeufer = row[6]
            preis = row[3]
            menge = row[4]

            tx_hash = Contract.functions.erstelleTransaktion(
                produkt,
                beschreibung,
                kaeufer,
                verkaeufer,
                int(round(float(preis), 0)),
                int(menge),
            ).transact({"from": sender})
