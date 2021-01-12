#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"

using namespace std;

void checkResults(PGresult* res, const PGconn* conn) {
	if (PQresultStatus(res) != PGRES_TUPLES_OK) {
		cout << "Risultati Inconsistenti: " << PQerrorMessage(conn) << endl;
		PQclear(res);
		exit(1);
	}
}

void printQuery(PGresult* results, int colonne, int righe) {
	for (int i = 0; i < colonne; ++i) {
		cout << PQfname(results, i);
		if(i+1 != colonne) cout << ",\t\t";
	}
	
	cout << endl;

	for (int i = 0; i < righe; ++i) {
		for (int j = 0; j < colonne; j++) {
			cout << PQgetvalue(results, i, j) << "\t\t";
		}
		cout << endl;
	}

	cout << "FINE OUTPUT" << endl << endl;
}

int main(int argc, char** argv) {
        #define PG_HOST		""
        #define PG_USER		""
	#define PG_DB		""
	#define PG_PASS		""
        #define PG_PORT		0000

	char ConnectionInfo[250];
	sprintf(ConnectionInfo, " user =%s password =%s dbname =%s hostaddr =%s port =%d", PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);
	PGconn* conn;
	conn = PQconnectdb(ConnectionInfo);

	if (PQstatus(conn) != CONNECTION_OK) {
		cout << "Errore di Connessione: " << PQerrorMessage(conn);
		exit(1);
	}
	else {
		cout << "Connessione Stabilita" << endl;
		PGresult* res;

		// Query 1
		cout << "Query 1: Mostrare la Matricola di tutti i Dipendenti che hanno svolto esclusivamente turni notturni" << endl;
		res = PQexec(conn, "SELECT MatricolaDip FROM Turno WHERE MatricolaDip LIKE 'V%' AND MatricolaDip NOT IN( SELECT MatricolaDip FROM Turno T JOIN Staff S ON T.MatricolaDip = S.Matricola WHERE(Inizio = '08:00:00' OR Inizio = '14:00:00'));");
		checkResults(res, conn);
		printQuery(res, PQnfields(res), PQntuples(res));
		PQclear(res);

		// Query 2
		cout << "Query 2: Mostrare il Codice Fiscale / Partita IVA degli espositori che esponevano almeno 5 veicol di marca Mercedes ma che non ne ha venduto nessuno" << endl;
		res = PQexec(conn, "SELECT Espositore, Count(Targa) as VeicoliMercedes FROM Veicolo V JOIN Espositore E ON V.Espositore = E.CF WHERE CF NOT IN ( SELECT CF FROM Espositore E JOIN Veicolo V on E.CF = V.Espositore  WHERE V.Marca = 'Mercedes' AND Prezzo > 0 ) GROUP BY Espositore HAVING Count(Targa) >= 5; ");
		checkResults(res, conn);
		printQuery(res, PQnfields(res), PQntuples(res));
		PQclear(res);

		// Query 3
		cout << "Query 3: Mostrare il CF dei clienti di sesso femminile che si sono registrate tramite una mail '@outlook.com' che hanno comprato almeno due veicoli per in importo totale inferiore a Euro 100.000" << endl;
		res = PQexec(conn, "SELECT CF,COUNT(CF) AS VeicoliComprati, SUM(Prezzo) AS ImportoTotale FROM Cliente C JOIN Veicolo V on C.CF = V.Acquirente WHERE Mail like '%@outlook.com' AND Sesso = 'F' GROUP BY C.CF HAVING COUNT(CF) >= 2 AND SUM(Prezzo) <= 100000; ");
		checkResults(res, conn);
		printQuery(res, PQnfields(res), PQntuples(res));
		PQclear(res);

		// Query 4
		cout << "Query 4: Calcolare il proffitto totale ottenuto dalla vendita dei veicoli raggruppati per marca e per i quali sono stati vednuti almeno due veicoli per un importo inferiore a Euro 75.000" << endl;
		res = PQexec(conn, "SELECT Marca, COUNT(Targa) AS NumeroVeicoliVenduti, SUM(Prezzo) AS ImportoTotale FROM Veicolo WHERE Prezzo > 0 GROUP BY Marca HAVING COUNT(Targa) >= 2 AND SUM(Prezzo) >= 75000; ");
		checkResults(res, conn);
		printQuery(res, PQnfields(res), PQntuples(res));
		PQclear(res);

		// Query 5
		cout << "Query 5: (VIEW) Creare una vista che mostri il profitto totale dei biglietti, raggruppati per tipo, posseduti da persone che hanno acquistato almeno un veicolo" << endl;
		res = PQexec(conn, "SELECT * FROM IncassoBigliettoAcquirenti;");
		checkResults(res, conn);
		printQuery(res, PQnfields(res), PQntuples(res));
		PQclear(res);

		// Query 6
		cout << "Query 6: Mostrare il nome degli eventi che si svolgono in contemporanea ma in piazze diverse" << endl;
		res = PQexec(conn, "SELECT DISTINCT S1.Data AS DataEvento, S1.OraInizio, Evento1.Nome AS Evento FROM Evento AS Evento1 JOIN Svolge AS S1 ON Evento1.Nome = S1.NomeEvento JOIN Evento AS Evento2 ON Evento1.Nome <> Evento2.Nome JOIN Svolge AS S2 ON Evento2.Nome = S2.NomeEvento WHERE S1.Data = S2.Data AND S1.OraInizio = S2.OraInizio AND S1.IDLuogo <> S2.IDLuogo;");
		checkResults(res, conn);
		printQuery(res, PQnfields(res), PQntuples(res));
		PQclear(res);

		PQfinish(conn);
	}

	cout << "Fine Programma" << endl;
	cout << "Termine Connessione" << endl;
	PQfinish(conn);
}
