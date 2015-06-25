# Makefile for application fc

CC = gfortran
CFLAGS = -c -Wall

all: fc

fc: fc.o
	$(CC) fc.o -o fc

fc.o: fc.f95
	$(CC) $(CFLAGS) fc.f95

clean:
	rm *.o fc
