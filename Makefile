TOPFILE=top.v
TOPMODULE=top
EXTRAFILES=7seg.v lfsr.v

ICE40TYPE=hx1k
ICE40PACKAGE=tq144

OUTDIR=out
SYNTH=yosys
SYNTH_options=-p 'synth_ice40 -top $(TOPMODULE)'
PNR=nextpnr-ice40
PNR_options=--$(ICE40TYPE) --package $(ICE40PACKAGE) --Werror
BITPACK=icepack
BITPACK_options=
PROG=iceprog
PROG_options=

.PHONY: all prog clean
all: $(OUTDIR)/lfsr.bin

prog: $(OUTDIR)/lfsr.bin
	$(PROG) $(PROG_options) $<
clean:
	rm -f $(OUTDIR)/*
	rmdir $(OUTDIR)

$(OUTDIR)/lfsr.bin: $(OUTDIR)/lfsr.asc
	$(BITPACK) $(BITPACK_options) $< $@

$(OUTDIR)/lfsr.asc: $(OUTDIR)/lfsr.json lfsr-7seg.pcf
	$(PNR) $(PNR_options) --json $< --pcf lfsr-7seg.pcf --asc $@

$(OUTDIR)/lfsr.json: $(TOPFILE) $(EXTRAFILES) | $(OUTDIR)
	$(SYNTH) $(SYNTH_options) -p 'write_json $@' $^

$(OUTDIR):
	mkdir -p $@

