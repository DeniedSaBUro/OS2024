.PHONY: run clean

CFLAGS = -g -O0

run: main
	./$<

main: main.o fun.o
	$(CC) $(CFLAGS) -o $@ $?

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -rf *.o *~ main
