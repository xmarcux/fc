# Makefile for application fc

CC = gfortran
CFLAGS = -c -Wall

all: fc

fc: comp.o info.o fc.o
	$(CC) fc.o comp.o info.o -o fc

fc.o: fc.f95 info.o comp.o
	$(CC) $(CFLAGS) fc.f95

comp.o: comp.f95
	$(CC) $(CFLAGS) comp.f95

info.o: info.f95
	$(CC) $(CFLAGS) info.f95

clean:
	rm *.o *~ *.mod fc
