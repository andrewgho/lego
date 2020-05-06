# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = demo.stl

all: $(TARGETS)

demo.stl: demo.scad lego.scad
	$(OPENSCAD) -o demo.stl demo.scad

clean:
	@rm -f $(TARGETS)
