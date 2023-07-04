from web3 import Web3
import Hilfsfunktionen as hf
import json

# Verbindung herstellen
host = "http://127.0.0.1:7545"
w3 = Web3(Web3.HTTPProvider(host))

# Auf erfolgreiche Verbindung überprüfen
if w3.is_connected:
    print("+" * 20)
    print(f"Verbindung erfolgreich mit Blockchain {host} hergestellt")
    print("+" * 20)
else:
    print("+" * 20)
    print(f"Verbindung nicht erfolgreich mit Blockchain {host} hergestellt")
    print("+" * 20)

# Zuweisung einer eigenen Adresse und eines privaten Schlüssels
EigenesUnternehmenAdresse = w3.eth.accounts[0]

# Zuweisung des Standardaccounts für alle folgenden Transaktionen, erleichtert die Signierung von Transaktionen
w3.eth.default_account = EigenesUnternehmenAdresse

# ABI (Application Binary Interface) und permanente Adresse des Smart Contract laden
abi = json.loads(
    '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"transaktionsID","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"zeitpunkt","type":"uint256"},{"indexed":false,"internalType":"string","name":"beschreibung","type":"string"},{"indexed":false,"internalType":"string","name":"produkt","type":"string"},{"indexed":false,"internalType":"uint256","name":"menge","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"preis","type":"uint256"}],"name":"TransaktionErstellt","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"wallet","type":"address"},{"indexed":false,"internalType":"string","name":"name","type":"string"}],"name":"UnternehmenErstellt","type":"event"},{"inputs":[],"name":"alleTransaktionengrundinformationenListe","outputs":[{"components":[{"internalType":"uint256","name":"transaktionsID","type":"uint256"},{"internalType":"string","name":"produkt","type":"string"},{"internalType":"string","name":"beschreibung","type":"string"},{"internalType":"uint256","name":"preis","type":"uint256"},{"internalType":"uint256","name":"menge","type":"uint256"},{"internalType":"address","name":"kaeufer","type":"address"},{"internalType":"address","name":"verkaeufer","type":"address"},{"internalType":"string","name":"einfuhrland","type":"string"},{"internalType":"string","name":"ausfuhrland","type":"string"}],"internalType":"struct Lieferkettenanalyse.Transaktionsinformationen[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"alleTransaktionenzusatzinformationenListe","outputs":[{"components":[{"internalType":"uint256","name":"transaktionsID","type":"uint256"},{"internalType":"uint256","name":"zeitpunkt","type":"uint256"},{"internalType":"bool","name":"landInPositivliste","type":"bool"},{"internalType":"bool","name":"risikobehaftetesProdukt","type":"bool"},{"internalType":"bool","name":"gueltigeZertifizierungen","type":"bool"},{"internalType":"bool","name":"einOderAusfuhr","type":"bool"}],"internalType":"struct Lieferkettenanalyse.Transaktionszusatzinformationen[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"alleUnternehmenListe","outputs":[{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"address","name":"wallet","type":"address"},{"internalType":"uint256","name":"typ","type":"uint256"},{"internalType":"string","name":"herkunftsland","type":"string"},{"internalType":"string","name":"strasse","type":"string"},{"internalType":"string","name":"ort","type":"string"},{"internalType":"string[]","name":"zertifizierungen","type":"string[]"}],"internalType":"struct Lieferkettenanalyse.Unternehmensinformationen[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"anzahlAnTransaktionen","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"anzahlAnUnternehmen","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"wallet","type":"address"}],"name":"anzahlTransaktionenMitWallet","outputs":[{"internalType":"uint256","name":"anzahl","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"_produkt","type":"string"},{"internalType":"string","name":"_beschreibung","type":"string"},{"internalType":"address","name":"_kaeufer","type":"address"},{"internalType":"address","name":"_verkaeufer","type":"address"},{"internalType":"uint256","name":"_preis","type":"uint256"},{"internalType":"uint256","name":"_menge","type":"uint256"}],"name":"erstelleTransaktion","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_name","type":"string"},{"internalType":"address","name":"_wallet","type":"address"},{"internalType":"uint256","name":"_typ","type":"uint256"},{"internalType":"string","name":"_herkunftsland","type":"string"},{"internalType":"string","name":"_strasse","type":"string"},{"internalType":"string","name":"_ort","type":"string"},{"internalType":"string[]","name":"_zertifizierungen","type":"string[]"}],"name":"erstelleUnternehmen","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_neuerBesitzer","type":"address"}],"name":"neuenBesitzerfestlegen","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_produkt","type":"string"},{"internalType":"uint256","name":"_menge","type":"uint256"},{"internalType":"string","name":"_beschreibung","type":"string"},{"internalType":"address payable","name":"_verkaeufer","type":"address"}],"name":"sendeTransaktion","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"transaktionsgrundinformationen","outputs":[{"internalType":"uint256","name":"transaktionsID","type":"uint256"},{"internalType":"string","name":"produkt","type":"string"},{"internalType":"string","name":"beschreibung","type":"string"},{"internalType":"uint256","name":"preis","type":"uint256"},{"internalType":"uint256","name":"menge","type":"uint256"},{"internalType":"address","name":"kaeufer","type":"address"},{"internalType":"address","name":"verkaeufer","type":"address"},{"internalType":"string","name":"einfuhrland","type":"string"},{"internalType":"string","name":"ausfuhrland","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"transaktionszusatzinformationen","outputs":[{"internalType":"uint256","name":"transaktionsID","type":"uint256"},{"internalType":"uint256","name":"zeitpunkt","type":"uint256"},{"internalType":"bool","name":"landInPositivliste","type":"bool"},{"internalType":"bool","name":"risikobehaftetesProdukt","type":"bool"},{"internalType":"bool","name":"gueltigeZertifizierungen","type":"bool"},{"internalType":"bool","name":"einOderAusfuhr","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"unternehmen","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"address","name":"wallet","type":"address"},{"internalType":"uint256","name":"typ","type":"uint256"},{"internalType":"string","name":"herkunftsland","type":"string"},{"internalType":"string","name":"strasse","type":"string"},{"internalType":"string","name":"ort","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"wallet","type":"address"}],"name":"unternehmenMitWallet","outputs":[{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"address","name":"wallet","type":"address"},{"internalType":"uint256","name":"typ","type":"uint256"},{"internalType":"string","name":"herkunftsland","type":"string"},{"internalType":"string","name":"strasse","type":"string"},{"internalType":"string","name":"ort","type":"string"},{"internalType":"string[]","name":"zertifizierungen","type":"string[]"}],"internalType":"struct Lieferkettenanalyse.Unternehmensinformationen","name":"_unternehmen","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"string","name":"produkt","type":"string"}],"name":"validiereTransaktion","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"}]'
)

# Contract Variable festlegen, über welche alle Funktionen aufgerufen werden können
Contract = w3.eth.contract(
    address="0xb838f417DF84030bfb038b980d8d12E7dae5343f", abi=abi
)

# Lade eine vordefinierte Datei mit Unternehmensinformationen auf die Blockchain
hf.uploadUnternehmensdatei(
    host,
    "0xb838f417DF84030bfb038b980d8d12E7dae5343f",
    abi,
    "C:\\Users\\l-neg\\Desktop\\Uni\\Arbeiten\\Bachelorarbeit\\Daten\\Unternehmensinformationen.csv",
    EigenesUnternehmenAdresse,
)

# Lade eine vordefinierte Datei mit Transaktionsinformationen auf die Blockchain
hf.uploadTransaktionsdatei(
    host,
    "0xb838f417DF84030bfb038b980d8d12E7dae5343f",
    abi,
    "C:\\Users\\l-neg\\Desktop\\Uni\\Arbeiten\\Bachelorarbeit\\Daten\\Transaktionsinformationen.csv",
    EigenesUnternehmenAdresse,
)

# Speichere alle Unternehmensinformationen in einer ausgewählten CSV-Datei
hf.speichereUnternehmen(
    host,
    "0xb8075CA320d1ddD01170b251a7aCCE9A77903B29",
    abi,
    "unternehmen_extraktion.csv",
)

# Speichere alle Transaktionsgrundinformationen in einer ausgewählten CSV-Datei
hf.speichereTransaktionsgrundinfos(
    host,
    "0xb8075CA320d1ddD01170b251a7aCCE9A77903B29",
    abi,
    "transaktionenbasis_extraktion.csv",
)

# Speichere alle Transaktionszusatzinformationen in einer ausgewählten CSV-Datei
hf.speichereTransaktionszusatzinfos(
    host,
    "0xb8075CA320d1ddD01170b251a7aCCE9A77903B29",
    abi,
    "transaktionenzusatz_extraktion.csv",
)
