@SET PGPASSWORD=admin
psql -U postgres -d postgres -a -q -w -f database\drop.sql
psql -U postgres -d postgres -a -q -w -f database\create.sql
psql -U postgres -d postgres -a -q -w -f database\fill.sql