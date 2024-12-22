Periodic Table database and element query script.
FreeCodeCamp Relational Databases
certification project (4/5)

Database contains three three tables: elements, element properties and types;
Query script _element.sh_ accepts three formats: element atomic number (integer), element name (e.g. Hydrogen) and element symbol (e.g. H).

_periodic_table.sql_ is obtained by:
1. setup starter database _periodic_table_starter.sql_ with postgres psql;
2. execute _fix_db.sh_;
3. execute _cleanup.sh_.

Note1: The PSQL variable **in all shell scripts** should be modified to reflect the local user (see the --username=localuser flag);
Note2: _element.sh_ is compatible with _periodic_table.sql_;
Note3: database is not complete. 
