# Makefile
SHELL := /bin/bash
CC = gcc

# Compiler flags: all warnings + debugger meta-data
CFLAGS = -Wall -g -std=c99 -pthread -Wno-missing-braces


# The final executable program file, i.e. name of our program
#BIN = server dummyclient2 dummyclient client
BINDIR = build

# Object files from which $BIN depend
OBJSCLIENT = obj/clientApi.o obj/cliParser.o obj/clientInternals.o
OBJSSERVER = obj/filesystemApi.o obj/log.o obj/boundedbuffer.o obj/cacheFns.o obj/icl_hash.o obj/fileparser.o obj/rleCompression.o

# Path of Object files
OBJDIR = obj

SRCDIR = src
HEADDIR = include
# Libraries
LIBS = -lpthread -lm

.PHONY: all clean cleanall test1 test2 test3

all:	server client

server: $(SRCDIR)/$< $(OBJSSERVER)
	$(CC) $(CFLAGS) $(OBJSSERVER) $(SRCDIR)/$@.c $(LIBS) -o $(BINDIR)/$@

client: $(SRCDIR)/$< $(OBJSCLIENT)
	$(CC) $(CFLAGS) $(OBJSCLIENT) $(SRCDIR)/$@.c $(LIBS) -o $(BINDIR)/$@

clientTest3: $(SRCDIR)/$< $(OBJSCLIENT)
	$(CC) $(CFLAGS) $(OBJSCLIENT) $(SRCDIR)/client.c $(LIBS) -o $(BINDIR)/$@

# This rule compiles each module into its object file
$(OBJDIR)/%.o: $(SRCDIR)/%.c $(HEADDIR)/%.h
	$(CC) -c $(CFLAGS) $< -o $@ $(LIBS)

test1: server client
	./tests/test1.sh
	./statistiche.sh logs.json

test2: server client
	./tests/test2.sh

test3: server clientTest3
	./tests/test3.sh
	./statistiche.sh logs.json

clean:
	rm -f *~ $(OBJDIR)/*.o $(BINDIR)/*

cleanall:
	rm -f *~ $(OBJDIR)/*.o $(BINDIR)/* logs.json -r tests/evicted1 -r tests/evicted2 -r tests/evicted3 -r tests/test1dest1 -r tests/test1dest2 -r tests/test3dest1 -r tests/test3dest2