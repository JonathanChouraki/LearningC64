CC = java -jar ~/bin/KickAss.jar
CFLAGS = -showmem -execute x64
LDLIBS =
SRCDIR = src
BINDIR = bin

all:
	$(CC) $(CFLAGS) $(SRCDIR)/$(file).asm $(LDLIBS)

clean:
	rm $(SRCDIR)/*.sym
	rm $(SRCDIR)/*.prg
	rm ExecuteOutputLog.txt
