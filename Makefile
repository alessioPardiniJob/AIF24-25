# Makefile for automation

install:
        ./scripts/setup.sh

run:
        python3 src/main.py

test:
        pytest tests/

clean:
        rm -rf __pycache__ *.log
