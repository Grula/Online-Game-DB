DIR	= Projekat
CC=gcc
PROGS	= app
CFLAGS	= -g -Wall -L/usr/lib/mysql -I/usr/include/mysql -lmysqlclient
DEPS = 
OBJ = app.o 

.PHONY: all create insert beauty dist progs

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

app: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

all: create insert $(app)

create:
	mysql -u root -proot -D mysql < DB.sql

insert:
	mysql -u root -proot -D mysql < Fill.sql
	
beauty:
	-indent $(PROGS).c

clean:
	-rm -f *~ $(PROGS)
	
dist: beauty clean
	-tar -czv -C .. -f ../$(DIR).tar.gz $(DIR)
	gcc -I/usr/include/mysql app.c -L/usr/lib/mysql -lmysqlclient -o app

