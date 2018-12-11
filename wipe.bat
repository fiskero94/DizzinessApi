@SET PGPASSWORD=admin
psql -U postgres -d postgres -a -q -w -f database\wipe.sql