PROJECT_NAME = hello_semihosting

CFLAGS = -specs=nosys.specs -specs=rdimon.specs -specs=nano.specs -nostartfiles
LDFLAGS = -lrdimon -lc
