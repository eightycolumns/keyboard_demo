abspath_to_makefile := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(patsubst %/,%,$(dir $(abspath_to_makefile)))

title := keyboard_demo
wav_file := $(makefile_dir)/$(title).wav

.PHONY: all
all: $(wav_file)

orchestra := $(makefile_dir)/orchestra
score := $(makefile_dir)/score

subdirs := instruments opcodes
includes := $(foreach subdir,$(subdirs),$(wildcard $(makefile_dir)/$(subdir)/*))

csound_flags := -b 256 -B 1024 --dither -m 135 -s

sampling_rate := 44100

# Oversample to 44100 * 4
csound_flags += --sample-rate=176400 --ksmps=1

$(wav_file): $(orchestra) $(score) $(includes)
	csound $(csound_flags) -W -o temp $(orchestra) $(score); \
	trap 'rm -f temp' EXIT; \
	sndfile-resample -to $(sampling_rate) -c 0 temp $(wav_file)

.PHONY: clean
clean:
	rm -f $(wav_file)
