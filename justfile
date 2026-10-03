set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

setup:
    mise install
    npm ci --ignore-scripts

fmt:
    ./node_modules/.bin/prettier --write .
    ruff check --fix template/scripts template/tests
    ruff format template/scripts template/tests

lint:
    ./node_modules/.bin/prettier --check .
    cd template && ../node_modules/.bin/eslint --max-warnings=0 --no-inline-config .
    ruff check --ignore-noqa template/scripts template/tests
    ruff format --check template/scripts template/tests
    cmp mise.toml template/mise.toml
    cmp package.json template/package.json
    cmp package-lock.json template/package-lock.json
    python3 template/scripts/workflow_lint.py
    python3 template/scripts/workflow_lint.py .
    zizmor --offline --persona auditor --no-ignores .github/workflows template/.github/workflows

test:
    python3 -m unittest discover -s template/tests -p 'test_*.py' -v

coverage:
    coverage run -m unittest discover -s template/tests -p 'test_*.py' -v
    coverage xml -o coverage/python.xml

security:
    osv-scanner scan source --lockfile=package-lock.json
    python3 template/scripts/security_source.py .
    gitleaks git --redact --no-banner .

build:
    cp mise.toml package.json package-lock.json template/

ci: lint test coverage security
