PYTHON=`which python`
CYTHON=`which cython`
DESTDIR=/
PROJECT=python-scattnlay
VERSION=2.0
BUILDIR=$(CURDIR)/debian/$(PROJECT)
SRCDIR=$(CURDIR)/src

all:
	@echo "make source - Create source package for Python extension"
	@echo "make python_ext - Create Python extension"
	@echo "make install - Install Python extension on local system"
	@echo "make buildrpm - Generate a rpm package for Python extension"
	@echo "make builddeb - Generate a deb package for Python extension"
	@echo "make standalone - Create standalone programs (scattnlay and fieldnlay)"
	@echo "make clean - Delete temporary files"
#	make standalone

source:
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../

python_ext: $(SRCDIR)/nmie.cc $(SRCDIR)/py_nmie.cc $(SRCDIR)/scattnlay.pyx
	$(PYTHON) setup.py build_ext --inplace

install:
	$(PYTHON) setup.py install --root $(DESTDIR) $(COMPILE)

buildrpm:
	#$(PYTHON) setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall
	$(PYTHON) setup.py bdist_rpm --dist-dir=../

builddeb:
	# build the source package in the parent directory
	# then rename it to project_version.orig.tar.gz
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../ --prune
	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	# build the package
	export CFLAGS='-std=c++11' && dpkg-buildpackage -i -I -rfakeroot

standalone: $(SRCDIR)/farfield.cc $(SRCDIR)/nearfield.cc $(SRCDIR)/nmie.cc
	export CFLAGS='-std=c++11' && c++ -DNDEBUG -O2 -Wall -std=c++11 $(SRCDIR)/farfield.cc $(SRCDIR)/nmie.cc  -lm -o scattnlay
	mv scattnlay ../
	export CFLAGS='-std=c++11' && c++ -DNDEBUG -O2 -Wall -std=c++11 $(SRCDIR)/nearfield.cc $(SRCDIR)/nmie.cc  -lm -o fieldnlay
	mv fieldnlay ../

clean:
	$(PYTHON) setup.py clean
	$(MAKE) -f $(CURDIR)/debian/rules clean
	rm -rf build/ MANIFEST
	find . -name '*.pyc' -delete
	find . -name '*.o' -delete
	find . -name '*.so' -delete
