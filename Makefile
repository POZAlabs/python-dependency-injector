VERSION := $(shell python setup.py --version)

CYTHON_SRC := $(shell find src/dependency_injector -name '*.pyx')

CYTHON_DIRECTIVES = -Xlanguage_level=3

ifdef DEPENDENCY_INJECTOR_DEBUG_MODE
	CYTHON_DIRECTIVES += -Xprofile=True
	CYTHON_DIRECTIVES += -Xlinetrace=True
endif


clean:
	# Clean sources
	find src -name '*.py[cod]' -delete
	find src -name '__pycache__' -delete
	find src -name '*.c' -delete
	find src -name '*.h' -delete
	find src -name '*.so' -delete
	find src -name '*.html' -delete
	# Clean tests
	find tests -name '*.py[co]' -delete
	find tests -name '__pycache__' -delete
	# Clean examples
	find examples -name '*.py[co]' -delete
	find examples -name '__pycache__' -delete

cythonize:
	cython $(CYTHON_DIRECTIVES) $(CYTHON_SRC)

build: clean cythonize
	poetry build

docs-live:
	sphinx-autobuild docs docs/_build/html

install: uninstall clean cythonize
	pip install -ve .

uninstall:
	- pip uninstall -y -q dependency-injector 2> /dev/null

test:
	# Unit tests with coverage report
	coverage erase
	coverage run --rcfile=./.coveragerc -m pytest -c tests/.configs/pytest.ini
	coverage report --rcfile=./.coveragerc
	coverage html --rcfile=./.coveragerc
