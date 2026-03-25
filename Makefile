.PHONY: help install test coverage lint format typecheck clean run-examples quick-start

help:
	@echo "Available commands:"
	@echo "  make install      - Install dependencies"
	@echo "  make test         - Run tests"
	@echo "  make coverage     - Run tests with coverage report"
	@echo "  make lint         - Run ruff linter"
	@echo "  make format       - Format code with black"
	@echo "  make typecheck    - Run mypy type checking"
	@echo "  make clean        - Remove generated files"
	@echo "  make run-examples - Run all examples"
	@echo "  make quick-start  - Run quick start demo"

install:
	pip install -r requirements.txt

test:
	pytest tests/test_api_client.py -v

coverage:
	pytest tests/test_api_client.py --cov=api_client --cov-report=term-missing --cov-report=html
	@echo "Coverage report generated in htmlcov/index.html"

lint:
	ruff check api_client/ tests/ examples/

format:
	black api_client/ tests/ examples/
	ruff check --fix api_client/ tests/ examples/

typecheck:
	mypy api_client/ --strict

clean:
	rm -rf __pycache__ .pytest_cache .mypy_cache .coverage htmlcov
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete

run-examples:
	python examples/api_client_examples.py

quick-start:
	python examples/quick_start.py

all: format lint typecheck test
