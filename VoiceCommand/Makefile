#GITREV  = -D'GITREV="$(shell git log -1 --pretty=format:"%h by %an on %ai")"'
BLDDEF  = -D'BUILDTS="$(shell date +"%y%m%d %H:%M:%S %z")"'

#Set Architecture
ARCH := x86
DEVEL := rel
LIBS := -lcurl -lboost_regex

#Compilers
ifeq ($(ARCH),arm-v7)
CC := g++-4.8 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard
else
ifeq ($(ARCH),arm)
CC := g++ -mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard
else
ifeq ($(ARCH),x86)
CC := g++ -m32
OUTPUT := x86/
else
CC := g++
OUTPUT := x64/
endif
endif
endif

#devel flags
ifeq ($(BUILD),devel)
FLAGS := -g -Wall
else
FLAGS := -O3
endif

voicecommand: voicecommand.cpp voicecommand.h
	$(CC) $(BLDDEF) $(FLAGS) -o $(addprefix $(OUTPUT), voicecommand) voicecommand.cpp $(LIBS)

clean:
	rm *.o voicecommand 2>/dev/null

install: google speech-recog.sh voicecommand tts tts-nofill speech_recog_1.sh
	install google /usr/bin/google
	install tts /usr/bin/tts
	install speech-recog.sh /usr/bin/speech-recog.sh
	install speech_recog_1.sh /usr/bin/speech_recog_1.sh
	install voicecommand /usr/bin/voicecommand
