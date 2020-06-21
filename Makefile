CC          = gcc
CFLAGS      = -std=c11 -static

# for release build
SRCS        = $(wildcard *.c)
OBJS        = $(SRCS:.c=.o)
TARGET      = alloycc
HEADER      = $(TARGET).h

# for stg1 build
STG1DIR     = build-stg1
STG1OBJS    = $(addprefix $(STG1DIR)/, $(OBJS))
STG1TARGET  = $(STG1DIR)/$(TARGET)
BUILDCFLAGS = -g -o0 -DDEBUG

TSTDIR      = test
TSTSOURCE   = $(TSTDIR)/test.c

all: prep release

#release rules
release: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

$(OBJS): $(HEADER)

# stg1 rules
stg1: $(STG1TARGET)

$(STG1TARGET): $(STG1OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

$(STG1DIR)/%.o: %.c $(HEADER)
	$(CC) -c $(CFLAGS) $(BUILDCFLAGS) -o $@ $<

# for testing (w/ stg1)
test: $(STG1TARGET) $(TSTSOURCE) $(TSTDIR)/extern.o
	$(STG1TARGET) $(TSTSOURCE) > $(TSTDIR)/tmp.s
	$(CC) -static -o $(TSTDIR)/tmp $(TSTDIR)/tmp.s $(TSTDIR)/extern.o
	$(TSTDIR)/tmp

clean:
	rm -f $(TARGET) *.o *~ tmp* $(STG1DIR)/* $(TSTTARGET) $(TSTDIR)/*.o $(TSTDIR)/tmp*

prep:
	mkdir -p $(STG1DIR)
	mkdir -p $(TSTDIR)

.PHONY: test clean release stg1 prep
