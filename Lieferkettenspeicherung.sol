// SPDX-License-Identifier: MIT
// Entwickelt von Leon Negwer
pragma solidity >=0.8.18 <0.9.0;

contract Lieferkettenanalyse {
    // Lege Besitzer des Smart Contracts fest
    address besitzer;

    constructor() {
        besitzer = msg.sender;
    }

    // Funktion um neuen Besitzer festzulegen
    function neuenBesitzerfestlegen(address _neuerBesitzer) external {
        require(
            msg.sender == besitzer,
            "Nur der aktuelle Besitzer kann seine Rechte uebertragen!"
        );
        besitzer = _neuerBesitzer;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////PART 1: UNTERNEHMENSBEZOGENE INFORMATIONEN////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Laufender Zähler zur Messung der Gesamtanzahl aller Unternehmen, wird verwendet, um die ID der Unternehmen festzulegen
    uint256 unternehmensanzahl = 0;

    // Struktur jedes Unternehmen und seiner Informationen
    struct Unternehmensinformationen {
        uint256 id;
        string name;
        address wallet;
        uint256 typ;
        string herkunftsland;
        string strasse;
        string ort;
        string[] zertifizierungen;
    }

    // Array, bzw. Liste mit der zuvor definierten Struktur
    Unternehmensinformationen[] public unternehmen;

    // Event welches eine Benachrichtigung entsendet, sobald ein neues Unternehmen erstellt wurde
    event UnternehmenErstellt(address indexed wallet, string name);

    // Funktion um neue Unternehmen zu laden und abzuspeichern
    function erstelleUnternehmen(
        string memory _name,
        address _wallet,
        uint256 _typ,
        string memory _herkunftsland,
        string memory _strasse,
        string memory _ort,
        string[] memory _zertifizierungen
    ) external {
        require(
            msg.sender == besitzer,
            "Nur der Besitzer des Smart Contracts kann neue Unternehmen registrieren."
        );

        // Erstelle ein neues Unternehmen mit den Eingabevariablen
        Unternehmensinformationen
            memory neuesUnternehmen = Unternehmensinformationen(
                unternehmensanzahl,
                _name,
                _wallet,
                _typ,
                _herkunftsland,
                _strasse,
                _ort,
                _zertifizierungen
            );

        // Neues Unternehmen wird zur Liste hinzugefügt
        unternehmen.push(neuesUnternehmen);

        // Inkrementiere die Gesamtanzahl der Unternehmen um +1
        unternehmensanzahl++;

        // Löse das zuvor definiertes Event aus
        emit UnternehmenErstellt(_wallet, _name);
    }

    // Funktion um die Ausgabe von einzelnen Unternehmen basierend auf ihrer Wallet-Adresse auszulösen
    // Gespeicherte Informationen werden einzeln ausgegeben
    function unternehmenMitWallet(
        address wallet
    ) external view returns (Unternehmensinformationen memory _unternehmen) {
        require(
            unternehmenExistiert(wallet),
            "Das gesuchte Unternehmen ist noch nicht gespeichert. Bitte registriere das Unternehmen, bevor nach diesem gesucht wird."
        );

        // Schleife um jede Wallet-Adresse mit der Ziel-Adresse zu vergleichen
        for (uint i = 0; i < unternehmen.length; i++) {
            // Wenn Treffer, dann gebe alle Informationen des Unternehmens zurück
            if (wallet == unternehmen[i].wallet) {
                return unternehmen[i];
            }
        }
    }

    function unternehmenExistiert(
        address wallet
    ) private view returns (bool result) {
        // Schleife um jede Wallet-Adresse mit der Ziel-Adresse zu vergleichen
        for (uint i = 0; i < unternehmen.length; i++) {
            // Wenn Treffer, dann gebe alle Informationen des Unternehmens zurück
            if (wallet == unternehmen[i].wallet) {
                return true;
            }
        }
        return false;
    }

    // Gebe eine Liste mit der Struktur Unternehmensinformationen aller gespeicherten Unternehmen aus
    function alleUnternehmenListe()
        external
        view
        returns (Unternehmensinformationen[] memory)
    {
        return unternehmen;
    }

    // Gebe eine Zahl aus, wie viele Unternehmen insgesamt gespeichert sind, z. B. 3
    function anzahlAnUnternehmen() external view returns (uint256) {
        return unternehmen.length;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////PART 2: TRANSAKTIONSBEZOGENE INFORMATIONEN////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Laufender Zähler zur Messung der Gesamtanzahl aller Transkationen, wird verwendet, um die TransaktionsID festzulegen
    uint256 transaktionsanzahl = 0;

    // Struktur jeder Transaktion und dessen Informationen
    struct Transaktionsinformationen {
        uint256 transaktionsID;
        string produkt;
        string beschreibung;
        uint256 preis;
        uint256 menge;
        address kaeufer;
        address verkaeufer;
        string einfuhrland;
        string ausfuhrland;
    }

    // Struktur aller Informationen die zusätzlich zu jeder Transaktion gespeichert werden
    struct Transaktionszusatzinformationen {
        uint256 transaktionsID;
        uint256 zeitpunkt;
        bool landInPositivliste;
        bool risikobehaftetesProdukt;
        bool gueltigeZertifizierungen;
        bool einfuhrGueltig;
        bool ausfuhrGueltig;
    }

    // Array, bzw. Liste zur Speicherung von grundlegenden Transaktionsinformationen
    Transaktionsinformationen[] public transaktionsgrundinformationen;

    // Array, bzw. Liste zur Speicherung von zusätzlichen Transaktionsinformationen
    Transaktionszusatzinformationen[] public transaktionszusatzinformationen;

    // Event welches eine Benachrichtigung entsendet, sobald eine neue Transaktion erstellt wurde
    event TransaktionErstellt(
        uint256 indexed transaktionsID,
        uint256 zeitpunkt,
        string beschreibung,
        string produkt,
        uint256 menge,
        uint preis
    );

    // Funktion um neue Transaktionen abzuspeichern
    function erstelleTransaktion(
        string memory _produkt,
        string memory _beschreibung,
        address _kaeufer,
        address _verkaeufer,
        uint256 _preis,
        uint256 _menge
    ) external {
        require(
            msg.sender == besitzer,
            "Nur der Besitzer des Smart Contracts kann diese Funktion nutzen."
        );
        require(
            unternehmenExistiert(_kaeufer),
            "Das Kaeuferunternehmen existiert noch nicht."
        );
        require(
            unternehmenExistiert(_verkaeufer),
            "Das Verkaeuferunternehmen existiert noch nicht."
        );

        // Erstelle eine neue Transaktion mit den Eingabevariablen
        Transaktionsinformationen
            memory neueTransaktion = Transaktionsinformationen(
                transaktionsanzahl,
                _produkt,
                _beschreibung,
                _preis,
                _menge,
                _kaeufer,
                _verkaeufer,
                this.unternehmenMitWallet(_kaeufer).herkunftsland,
                this.unternehmenMitWallet(_verkaeufer).herkunftsland
            );

        // Überprüfe auf gültige Ein- oder Ausfuhr
        (bool einfuhr, bool ausfuhr) = gueltigeEinOderAusfuhr(
            _produkt,
            this.unternehmenMitWallet(_kaeufer).herkunftsland,
            this.unternehmenMitWallet(_verkaeufer).herkunftsland,
            countryGreenlist,
            risikobehafteteProdukte
        );

        // Erstelle neue Transaktionszusatzinformationen für die Transaktion
        Transaktionszusatzinformationen
            memory neueZusatzinformationen = Transaktionszusatzinformationen(
                transaktionsanzahl,
                block.timestamp,
                gueltigesLand(
                    this.unternehmenMitWallet(_verkaeufer).herkunftsland,
                    countryGreenlist
                ),
                gefaehrlichesGut(_produkt, risikobehafteteProdukte),
                gueltigeZertifikateCheck(
                    this.unternehmenMitWallet(_verkaeufer).zertifizierungen,
                    anerkannteZertifizierungen
                ),
                einfuhr,
                ausfuhr
            );

        // Neue Transaktionsgrundinformationen werden zur Liste hinzugefügt
        transaktionsgrundinformationen.push(neueTransaktion);

        // Neue Transaktionzusatzinformationen werden zur Liste hinzugefügt
        transaktionszusatzinformationen.push(neueZusatzinformationen);

        // Löse das zuvor definiertes Event aus
        emit TransaktionErstellt(
            neueTransaktion.transaktionsID,
            neueZusatzinformationen.zeitpunkt,
            neueTransaktion.beschreibung,
            neueTransaktion.produkt,
            neueTransaktion.menge,
            neueTransaktion.preis
        );

        // Inkrementiere die Gesamtanzahl der Unternehmen um +1
        transaktionsanzahl++;
    }

    // Funktion um eine Transaktion mit Kryptowährung zu senden und gleichzeitig zu speichern
    function sendeTransaktion(
        string memory _produkt,
        uint256 _menge,
        string memory _beschreibung,
        address payable _verkaeufer
    ) external payable {
        // Nur der Besitzer des Smart Contracts (das eigene Unternehmen) kann Transaktionen verursachen
        require(
            msg.sender == besitzer,
            "Nur der Besitzer des Smart Contracts kann diese Funktion nutzen."
        );

        // Sender benötigt genügend Geld
        require(
            msg.sender.balance > msg.value,
            "Zu wenig Geld auf dem Konto, bitte ueberpruefe die Transaktion."
        );

        // Speichere Transaktion mit Parametern
        this.erstelleTransaktion(
            _produkt,
            _beschreibung,
            msg.sender,
            _verkaeufer,
            msg.value,
            _menge
        );

        // Überweise digitale Währung
        (bool sent, ) = _verkaeufer.call{value: msg.value}("");

        // Gebe eine Fehlermeldung aus, wenn ein Fehler bei der Übersendung passiert ist
        require(sent, "Transaktion nicht erfolgreich");
    }

    // Gebe eine Zahl aus, wie viele Transaktionen insgesamt gespeichert sind, z. B. 3
    function anzahlAnTransaktionen() external view returns (uint256) {
        return transaktionsgrundinformationen.length;
    }

    // Gebe eine Liste mit der Struktur Transaktionsinformationen aller gespeicherten Transaktionen aus
    function alleTransaktionengrundinformationenListe()
        external
        view
        returns (Transaktionsinformationen[] memory)
    {
        return transaktionsgrundinformationen;
    }

    // Gebe eine Liste mit der Struktur Transaktionsinformationen aller gespeicherten Transaktionen aus
    function alleTransaktionenzusatzinformationenListe()
        external
        view
        returns (Transaktionszusatzinformationen[] memory)
    {
        return transaktionszusatzinformationen;
    }

    function anzahlTransaktionenMitWallet(
        address wallet
    ) external view returns (uint256 anzahl) {
        for (uint i = 0; i < transaktionsgrundinformationen.length; i++) {
            // Wenn Treffer, dann gebe alle Informationen des Unternehmens zurück
            if (wallet == transaktionsgrundinformationen[i].verkaeufer) {
                anzahl++;
            }
        }
        return anzahl;
    }

    // Ansatz zur Überprüfung, ob Ausfuhrland zu einer grünen Liste von Ländern gehört, die gute arbeitsrechtliche Rahmenbedingungen besitzen
    string[] private countryGreenlist = [
        "Belgien",
        "Bulgarien",
        "Daenemark",
        "Deutschland",
        "Griechenland",
        "Schweden",
        "Portugal",
        "Oesterreich"
        "Spanien",
        "Frankreich",
        "Polen"
    ];

    // Beispielhafte Hash-Werte von anerkannten arbeitsrechtlichen Zertifikaten
    string[] private anerkannteZertifizierungen = [
        "63cac091c211761f5f81a211028ba3e1d6091c02a3e3784b4c7c982632fa09ea",
        "6ea3bf0ea17e82da49e480d535449b1c77039cf2dc0ded5bd3b80fefeb26846a",
        "c2f54f26c60e5c4d1d1bfedcbda5e106634ecfa8f8f60513bcfb83629d61fc19",
        "ae68e0261d6e8c8ae882f72c537d7e5e2a760bef071c36963c626be0c7bce0fa",
        "7ec0bd5fd51daf70877c991daa7369c4ded3c815d023e841b319b69e608ffb9d",
        "ddfa91f746dddc73e9b8a7ab06a77596e818e4888d06a83582e09eb8272fcd5c",
        "ab90ddde5e01cf058b569a4b780f635ae065562c0ade352d50623fcdba03f0bd",
        "782b84494acb9e9de37c85f70508d2e5226ec2b89a56cc4c788e8249d2c10433",
        "fdc54977ddd597277fd706e2f77981b3b4b0e2364d1fa427236a50948ed423c7",
        "05c9d03cd8e254f1192f90a0b4c5b9661ecf30a4140f55d60f0dd2efa9bbf1c4"
    ];

    // Nach dem Lieferkettengesetz als risikobehaftet klassifizierte Produkte und Güter mit Verbot oder Einschränkungen
    string[] private risikobehafteteProdukte = [
        "Quecksilber",
        "Zinnober",
        "Quecksilbersulfid",
        "Kalomel",
        "Aldrin",
        "Endrin",
        "Toxaphen",
        "Chlordan",
        "Dieldrin",
        "Heptachlor",
        "Mirex",
        "Hexachlorbenzol"
    ];

    // Mögliche Erweiterung, sodass ungültige Transaktionen erst gar nicht akzeptiert werden
    function validiereTransaktion(
        address sender,
        string memory produkt
    ) public view returns (bool) {
        // Erstelle neue Liste mit Informationen über den Verkäufer
        Unternehmensinformationen memory senderUnternehmen = this
            .unternehmenMitWallet(sender);

        // Überprüfe, ob die Eigenschaften die Transaktion als gültig oder ungültig einschätzen
        if (
            gueltigesLand(senderUnternehmen.herkunftsland, countryGreenlist) &&
            gueltigeZertifikateCheck(
                senderUnternehmen.zertifizierungen,
                anerkannteZertifizierungen
            ) &&
            !gefaehrlichesGut(produkt, risikobehafteteProdukte)
        ) {
            return true;
        } else {
            return false;
        }
    }

    // Hilfsfunktion um zu überprüfen, ob das Land des Verkäufers zur Liste der Positivländer gehört
    function gueltigesLand(
        string memory senderLand,
        string[] memory positiveListe
    ) private pure returns (bool) {
        for (uint256 i = 0; i < positiveListe.length; i++) {
            if (
                keccak256(bytes(senderLand)) ==
                keccak256(bytes(positiveListe[i]))
            ) {
                return true;
            }
        }
        return false;
    }

    // Hilfsfunktion um zu überprüfen, ob das transportierte Gut nach dem Lieferkettengesetz als risikobehaftet klassifiziert wird
    function gefaehrlichesGut(
        string memory produkt,
        string[] memory _risikobehafteteProdukte
    ) private pure returns (bool) {
        for (uint256 i = 0; i < _risikobehafteteProdukte.length; i++) {
            if (
                keccak256(bytes(produkt)) ==
                keccak256(bytes(_risikobehafteteProdukte[i]))
            ) {
                return true;
            }
        }
        return false;
    }

    // Hilfsfunktion um zu überprüfen, ob der Verkäufer gültige und nicht veränderte Zertifikate besitzt
    function gueltigeZertifikateCheck(
        string[] memory senderZertifikate,
        string[] memory gueltigeZertifikate
    ) private pure returns (bool) {
        uint256 anzahlKorrekt = 0;

        for (uint256 i = 0; i < senderZertifikate.length; i++) {
            for (uint256 j = 0; j < gueltigeZertifikate.length; j++) {
                if (
                    keccak256(bytes(gueltigeZertifikate[j])) ==
                    keccak256(bytes(senderZertifikate[i]))
                ) {
                    anzahlKorrekt++;
                }
            }
        }
        if (anzahlKorrekt != senderZertifikate.length) {
            return false;
        } else {
            return true;
        }
    }

    // Hilfsfunktion um zu überprüfen, ob der Verkäufer gültige und nicht veränderte Zertifikate besitzt
    function gueltigeEinOderAusfuhr(
        string memory produkt,
        string memory einfuhrland,
        string memory ausfuhrland,
        string[] memory positiveListe,
        string[] memory _risikobehafteteProdukte
    ) private pure returns (bool a, bool b) {
        // Wenn Einfuhr und Ausfuhrland in Positivliste und kein gefährdetes Produkt (true, true)
        // Wenn gefährlichesProdukt (false, false)
        // Wenn kein gefährdetes Produkt ein Einfuhrland in Positivliste (true, false)

        bool einfuhrPositiv = false;
        bool ausfuhrPositiv = false;
        bool sicheresProdukt = true;

        for (uint256 i = 0; i < _risikobehafteteProdukte.length; i++) {
            if (
                keccak256(bytes(einfuhrland)) ==
                keccak256(bytes(positiveListe[i]))
            ) {
                einfuhrPositiv = true;
            }
        }
        for (uint256 i = 0; i < _risikobehafteteProdukte.length; i++) {
            if (
                keccak256(bytes(ausfuhrland)) ==
                keccak256(bytes(positiveListe[i]))
            ) {
                ausfuhrPositiv = true;
            }
        }
        for (uint256 i = 0; i < _risikobehafteteProdukte.length; i++) {
            if (
                keccak256(bytes(produkt)) ==
                keccak256(bytes(_risikobehafteteProdukte[i]))
            ) {
                sicheresProdukt = false;
            }
        }
        if (einfuhrPositiv && ausfuhrPositiv && sicheresProdukt) {
            return (true, true);
        } else if (!einfuhrPositiv && !ausfuhrPositiv && !sicheresProdukt) {
            return (false, false);
        } else if (einfuhrPositiv && !ausfuhrPositiv && sicheresProdukt) {
            return (true, false);
        } else if (einfuhrPositiv && ausfuhrPositiv && !sicheresProdukt) {
            return (false, false);
        } else if (!einfuhrPositiv && ausfuhrPositiv && sicheresProdukt) {
            return (false, true);
        } else {
            return (false, false);
        }
    }
}
